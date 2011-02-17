$(document).ready(function() {
	var params = { bgcolor: "#7cbbd9" };
	var attributes = {};
	var flashvars = {};
    if ((screen.height>=768)) {
	    swfobject.embedSWF("/duck.swf", "insert", "100%", "140", "9.0.0", "expressInstall.swf", flashvars, params, attributes);
        $("#push").height(235);
    }
});

