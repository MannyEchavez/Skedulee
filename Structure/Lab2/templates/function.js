// attempted Search function
function search() {
    let input = document.getElementById('searchbar').value
    input=input.toLowerCase();
    let x = document.getElementsByClassName('animals');
      
    for (i = 0; i < x.length; i++) { 
        if (!x[i].innerHTML.toLowerCase().includes(input)) {
            x[i].style.display="none";
        }
        else {
            x[i].style.display="list-item";                 
        }
    }
}

function profileNotes(){
    alert("test"); //alert can be used to create a lil pop up message, just replace "test" with the necessary info if possible. or this may be deleted as well.
}

function profileEdit(){
  //form would go here for editting profiles

}

function profileDelete(){
  //not sure if we'll need this tho
}

//we may need this file still in order to create a pop-up form when editting profiles. 

