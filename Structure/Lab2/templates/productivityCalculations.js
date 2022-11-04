function productivityCalculator(profit, startDate, endDate, startTime, endTime){
    /*
    startDate format - '0000:00:00'
    endDate format - '0000:00:00'
    startTime format - '00:00'
    endTime format - '00:00'
    */
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor);
    if(startDate == endDate){
        cursor.execute('SELECT start_time, end_time FROM shift_t WHERE date = %s', session[startDate]);
    }else{
        cursor.execute('SELECT start_time, end_time FROM shift_t WHERE date >= %s AND date <= %s', session[startDate, endDate]);
    }
    shifts = cursor.fetchall();
    hours = 0.0;
    shifts.forEach((shift, index) => {
        hours += getHours(shift, startTime, endTime);
    })
    return profit/hours;
}

function getHours(shift, startTime, endTime){
    /*
    Helper method for productivityCalculator
    */
    shiftStart = shift[0].split(':');
    shiftEnd = shift[1].split(':');
    start = startTime.split(':');
    end = endTime.split(':');
    if(shiftStart[0] > end[0] || (shiftStart[0] == end[0] && shiftStart[1] > end[1]) || shiftEnd[0] < start[0] || (shiftEnd[0] == start[0] && shiftEnd[1] < start[1])){
        // if the start of the shift is after the desired end OR the end of the shift is before the desired start, then no need to check hours
        return 0.0;
    }
    if(shiftStart[0] < start[0] || (shiftStart[0] == start[0] && shiftStart[1] < start[1])){
        // if the start of the shift is before the desired start, then adjust to only use the hours during the desired shift
        shiftStart[0] = start[0];
        shiftStart[1] = start[1];
    }
    if(shiftEnd[0] > end[0] || (shiftEnd[0] == end[0] && shiftEnd[1] > end[1])){
        // if the end of the shift is after the desired end, then adjust to only use the hours during the desired shift
        shiftEnd[0] = end[0];
        shiftEnd[1] = end[1];
    }
    startMinute = shiftStart[0]*60 + shiftStart[1];
    endMinute = shiftEnd[0]*60 + shiftEnd[1];
    return (endTime - startTime)/60.0;
}