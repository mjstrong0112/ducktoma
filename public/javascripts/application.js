var keyCodes = [ 37, 38, 39, 40, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 8, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105 ];
function loadFooterSwf() {
	var flashvars = {};
	var params = {};
	var attributes = {};
	swfobject.embedSWF("duck.swf", "insert", "100%", "180", "9.0.0", "expressInstall.swf", flashvars, params, attributes);
}			   
$(document).ready(function() {
	loadFooterSwf();					   
	var input = $("#duck-count-input");
	
	input.val(0);
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
			$("#submit-duck-button").addClass('blue-button');
			$("#submit-duck-button").removeClass('blue-button-disabled');
		}else {
			$("#submit-duck-button").addClass('blue-button-disabled');
			$("#submit-duck-button").removeClass('blue-button');
		}
	});				
});
function duck_price(duckCount) {
	var price = duckCount*50;
	return 'Total: $'+price+".00";
}

