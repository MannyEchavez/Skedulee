function con(){
    var con = mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "root",
        database: "Skedulee"
      });
    con.connect(function(err) {
        if (err) throw err;
        con.query("SELECT * FROM shift_t", function (err, result, fields) {
          if (err) throw err;
          console.log(result);
        });
      });
      
}

function profileNotes(){
    alert(con());
}

function profileEdit(){

}

function profileDelete(){

}