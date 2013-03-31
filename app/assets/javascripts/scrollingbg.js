 $(document).ready(function() {    
//**
// SCROLLING HORIZONTAL BG
// **
    var offset = 0;
 
    function scrollbackgroundw() {
        // decrease the offset by 1, or if its less than 1 increase it by
        // the background height minus 1
        offset = (offset < 1) ? offset + (4000 - 1) : offset - 1;
        // apply the background position
        $('#clouds').css("background-position", + offset + "px");
        // call self to continue animation
        setTimeout(function() {
            scrollbackgroundw();
            }, 100
        );
    }
 
    // Start the animation
    scrollbackgroundw();

 });