var keyCodes = [ 37, 38, 39, 40, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 8, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105 ];			   
$(document).ready(function() {				   
	var input = $("#adoption_duck_count");
	
    if (!input.val) {
        input.val(0);
    }
	input.focus(function() {
		if(input.val() == 0) {		
			input.val('');
		}
	});
	input.blur(function() {
		if(input.val() == '') {
			input.val(0);
		}						
	});
	input.numeric();	
	input.keyup(function(event) {		
		var duckCount = $(this).val();
		$("#duck-form-total").text(duck_price(duckCount));
		
		//if more than one duck
		if(duckCount > 1 || duckCount == 0) {
			//pluralize word "duck"
			$("#duck-count").text("ducks")
		}else{
			$("#duck-count").text("duck")
		}
		if(duckCount != 0) {            
			$("#adoption_submit").addClass('blue-button');
			$("#adoption_submit").removeClass('blue-button-disabled');
		}else {
			$("#adoption_submit").addClass('blue-button-disabled');
			$("#adoption_submit").removeClass('blue-button');
		}
	});				
});
function duck_price(duckCount) {
	var price = duckCount*50;
	return 'Total: $'+price+".00";
}

