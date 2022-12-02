from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re

app = Flask(__name__)

# Change this to your secret key (can be anything, it's for extra protection)
app.secret_key = 'your secret key'

# Enter your database connection details below
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'root'
app.config['MYSQL_DB'] = 'Skedulee'

# Intialize MySQL
mysql = MySQL(app)

# http://localhost:5000/pythonlogin/ - this will be the login page, we need to use both GET and POST requests

@app.route('/', methods=['GET', 'POST'])
def login():
    # Output message if something goes wrong...
    msg = ''
    # Check if "username" and "password" POST requests exist (user submitted form)
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        # Create variables for easy access
        username = request.form['username']
        password = request.form['password']
        # Check if account exists using MySQL
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM user_t WHERE username = %s AND password = %s', (username, password,)) 
        # Fetch one record and return result
        account = cursor.fetchone()
        # If account exists in accounts table in out database
        if account:
            # Create session data, we can access this data in other routes
            session['loggedin'] = True
            session['employee_id'] = account['employee_id']
            session['username'] = account['username']
            # Redirect to home page
            return redirect(url_for('home'))
        else:
            # Account doesnt exist or username/password incorrect
            msg = 'Incorrect username/password!'
    # Show the login form with message (if any)
    return render_template('index.html', msg=msg)

@app.route('/logout')
def logout():
    # Remove session data, this will log the user out
   session.pop('loggedin', None)
   session.pop('employee_id', None)
   session.pop('username', None)
   # Redirect to login page
   return redirect(url_for('login'))


# http://localhost:5000/Falsk/register - this will be the registration page, we need to use both GET and POST requests
@app.route('/register', methods=['GET', 'POST'])
def register():
    # Output message if something goes wrong...
    msg = ''
    # Check if "username", "password" and "email" POST requests exist (user submitted form)
    if request.method == 'POST' and 'username' in request.form and 'employee_id' in request.form and 'password' in request.form and 'email' in request.form :
        # Create variables for easy access
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']
        employeeid = request.form['employee_id']

        # Check if account exists using MySQL
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM user_t WHERE username = %s', (username,))
        account = cursor.fetchone()
        # If account exists show error and validation checks
        if account:
            msg = 'Account already exists!'
        elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
            msg = 'Invalid email address!'
        elif not re.match(r'[A-Za-z0-9]+', username):
            msg = 'Username must contain only characters and numbers!'
        elif not username or not password or not email:
            msg = 'Please fill out the form!'
        else:
            # Account doesnt exists and the form data is valid, now insert new account into accounts table
            cursor.execute('INSERT INTO user_t (username, employee_id, password, email) VALUES ( %s, %s, %s, %s)', (username, employeeid, password, email,)) 
            mysql.connection.commit()
            msg = 'You have successfully registered!'
    elif request.method == 'POST':
        # Form is empty... (no POST data)
        msg = 'Please fill out the form!'
    # Show registration form with message (if any)
    return render_template('register.html', msg=msg)

# http://localhost:5000/pythinlogin/home - this will be the home page, only accessible for loggedin users
@app.route('/home')
def home():
    # Check if user is loggedin
    if 'loggedin' in session:
        # User is loggedin show them the home page
        return render_template('home.html', username=session['username'])
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))

# http://localhost:5000/pythinlogin/calculator - this will be the labor productivity calculator, only accessible for loggedin users
@app.route('/calculator')
def calculator():
    # Check if user is loggedin
    if 'loggedin' in session:
        # User is loggedin show them the home page
        return render_template('calculator.html', username=session['username'])
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))

@app.route('/calculator', methods = ['POST'])
def get_data_from_html():
    if request.method == 'POST':
        sd = request.form['startDate']
        ed = request.form['endDate']
        st = request.form['startTime']
        et = request.form['endTime']
        p = request.form['profits']
        if(p != None and p != ""):
            return render_template('calculator.html', productivity = 0)
        if(p == 0):
            return render_template('calculator.html', productivity = 0)
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        # make sure inputs are correct, fix if needed, then fix if statements to use minutes intstead of hours and minutes
        cursor.execute('SELECT start_time, end_time FROM shift_t WHERE date <= %s AND date >= %s', (sd, ed))
        mysql.connection.commit()
        raw = cursor.fetchall()
        start = list()
        end = list()
        for row in raw:
            start.append(row.get("start_time"))
            end.append(row.get("end_time"))
        
        minutes = 0
        startSplit = [int(i) for i in st.split(":")]
        timeStart = int(startSplit[0])*60 + int(startSplit[1])
        endSplit = [eval(i) for i in et.split(":")]
        timeEnd = int(endSplit[0])*60 + int(endSplit[1])
        if timeStart >= timeEnd or timeStart == timeEnd:
            return render_template('calculator.html', productivity = 0)
        for x, y in zip(start, end):
            shiftStartSplit = [eval(i) for i in x.split(":")]
            shiftStart = int(shiftStartSplit[0]*60 + int(shiftStartSplit[1]))
            shiftEndSplit = [eval(i) for i in y.split(":")]
            shiftEnd = int(shiftEndSplit[0]*60 + int(shiftEndSplit[1]))
            if(shiftStart > timeEnd or shiftEnd < timeStart):
                # if the start of the shift is after the desired end OR the end of the shift is before the desired start, then no need to check hours
                break
            if(shiftStart < timeStart):
                # if the start of the shift is before the desired start, then adjust to only use the hours during the desired shift
                shiftStart = timeStart
            if(shiftEnd > timeEnd):
                # if the end of the shift is after the desired end, then adjust to only use the hours during the desired shift
                shiftEnd = timeEnd
            minutes +=  shiftEnd - shiftStart
        hours = minutes / 60.0
        if hours != 0:
            productivity = float(int((p / hours) * 100.0))/100.0
        else:
            productivity = 0
        cursor.close()
        return render_template('calculator.html', productivity = productivity)

# http://localhost:5000/pythinlogin/profile - this will be the profile page, only accessible for loggedin users
@app.route('/profile')
def profile():
    # Check if user is loggedin
    if 'loggedin' in session:
        # We need all the account info for the user so we can display it on the profile page
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM user_t WHERE employee_id = %s', (session['employee_id'],)) 
        account = cursor.fetchone()
        # Show the profile page with account info
        return render_template('profile.html', account=account)
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))

#this will route to the database page
@app.route('/database')
def database():
    # Check if user is loggedin
    if 'loggedin' in session:
        # User is loggedin show them the home page
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM employee_t')
        emp_t = cursor.fetchall()
        cursor.execute('SELECT * FROM location_t')
        loc_t = cursor.fetchall()
        cursor.execute('SELECT * FROM notes_t')
        note_t = cursor.fetchall()
        cursor.execute('SELECT * FROM position_t')
        pos_t = cursor.fetchall()
        cursor.execute('SELECT * FROM role_t')
        rol_t = cursor.fetchall()
        cursor.execute('SELECT * FROM shift_t')
        shf_t = cursor.fetchall()
        cursor.execute('SELECT * FROM user_t')
        usr_t = cursor.fetchall()
        return render_template('database.html', username=session['username'], emp_t=emp_t, loc_t=loc_t, note_t=note_t, pos_t=pos_t, rol_t=rol_t, shf_t=shf_t, usr_t=usr_t)
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))

#this will route to the employee profiles page
@app.route('/employeeprofiles')
def employeeprofiles():
    # Check if user is loggedin
    if 'loggedin' in session:
        # User is loggedin show them the home page
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM employee_t')
        emp_t = cursor.fetchall()
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM notes_t')
        note_t = cursor.fetchall()
        return render_template('employeeprofiles.html', username=session['username'], emp_t=emp_t, note_t=note_t) 
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))

#this will route to the schedule page
@app.route('/schedule')
def schedule():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM employee_t')
    emp_t=cursor.fetchall()
    cursor.execute('SELECT * FROM position_t')
    pos_t=cursor.fetchall()
    cursor.execute('SELECT * FROM location_t')
    loc_t=cursor.fetchall()
    # Check if user is loggedin
    if 'loggedin' in session:
        # User is loggedin show them the home page
        return render_template('schedule.html', username=session['username'], emp_t=emp_t, pos_t=pos_t, loc_t=loc_t)
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))

@app.route('/schedule', methods=['GET', 'POST'])
def shifts():
    #Instantiating cursor, and passing employee table through for employee selection dropdown menu in schedule.html
    msg = '' #Provides the user with a message depending on status.
    #This if statement is for adding shifts. TODO: Add shift via SQL queries to the database
    if request.method == 'POST' and 'startTime' in request.form and 'endTime' in request.form and 'date' in request.form and 'employee' in request.form and 'position' in request.form and 'storeID' in request.form and request.form['shiftRadio']=='add':
        st = request.form['startTime']
        et = request.form['endTime']
        d = request.form['date']
        emp = request.form['employee']
        pos = request.form['position']
        store = request.form['storeID']
        msg = 'Addition success!'
    #This elif statement is for removing shifts.
    elif request.method == 'POST' and 'startTime' in request.form and 'endTime' in request.form and 'date' in request.form and 'employee' in request.form and 'position' in request.form and 'storeID' in request.form and request.form['shiftRadio']=='remove':
        st = request.form['startTime']
        et = request.form['endTime']
        d = request.form['date']
        emp = request.form['employee']
        pos = request.form['position']
        store = request.form['storeID']
        msg = 'Removal success!'
    #This elif statement is triggered when the form is not fully filled out.
    elif request.method == 'POST':
        msg = 'Please provide the proper information'
    return render_template('schedule.html', username=session['username'], msg=msg)


if __name__ == '__main__':
    app.run()
