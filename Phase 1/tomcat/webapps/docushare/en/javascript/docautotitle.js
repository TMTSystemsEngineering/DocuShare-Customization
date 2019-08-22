// Start of translation section
var updateFilenameMsg = "Update with filename";
// End of translation section

// docautotitle.js file
// Begin autoTitle JavaScript //
window.onload = init;  // initiate functions on page load...

function init(){ // run the appropriate functions...
	createoverridebutton();
	document.getElementsByName('document')[0].onchange = autotitle;
	var dcnFields = document.getElementsByName('PickDCN');
	for (var i = 0; i < dcnFields.length; i++) {
	    if (dcnFields[i].nodeName == "SELECT") {
	    	dcnFields[i].onchange = DCNchosen;
	    }
	}
}

function createoverridebutton(){
	//creating button...
	var getFileTextButton = document.createElement("input");
	getFileTextButton.setAttribute("type", "button");
	getFileTextButton.setAttribute("id", "fileTextButton");
	getFileTextButton.setAttribute("value", updateFilenameMsg);
	getFileTextButton.setAttribute("style", "margin-left:5px");
	getFileTextButton.setAttribute("onclick", "titleoverride()");
	if (typeof window.opera == 'undefined' && document.all) {  // if it's not opera but is IE...
		getFileTextButton.style.setAttribute("cssText", "margin-left:5px");  
		getFileTextButton.onclick = titleoverride;
	}
	//establishing a reference point and inserting it into the DOM tree...
	var parentTD = document.getElementsByName('title')[0].parentNode;
	parentTD.appendChild(getFileTextButton);
	
	//disabling it if the title field is blank on page load...
	if(document.getElementsByName('title')[0].value == "" && document.getElementsByName('document')[0].value == ""){
		document.getElementById('fileTextButton').disabled = true;
	}else{
		document.getElementById('fileTextButton').disabled = false;
	}
}

function autotitle(){ // when a new file has been uploaded or changed, update the title field value...
	var titlefield = document.getElementsByName('title')[0];
	var docValue = document.getElementsByName('document')[0].value;
	var lastslash = docValue.lastIndexOf('\\');	// check for /:\
	var lastbackslash = docValue.lastIndexOf('/');
	var lastcolon = docValue.lastIndexOf(':');
	var lastpath = (lastslash > lastbackslash) ? ((lastslash > lastcolon) ? lastslash : lastcolon ) : ((lastbackslash > lastcolon) ? lastbackslash : lastcolon );
	if(titlefield.value == ''){
		titlefield.value = docValue.substr(lastpath+1);
		titlefield.select();
		document.getElementById('fileTextButton').disabled = false;
	}else{document.getElementById('fileTextButton').disabled = false;
	}
}

function titleoverride(){
	var titlefield = document.getElementsByName('title')[0];
	var docValue = document.getElementsByName('document')[0].value;
	var lastslash = docValue.lastIndexOf('\\');	// check for /:\
	var lastbackslash = docValue.lastIndexOf('/');
	var lastcolon = docValue.lastIndexOf(':');
	var lastpath = (lastslash > lastbackslash) ? ((lastslash > lastcolon) ? lastslash : lastcolon ) : ((lastbackslash > lastcolon) ? lastbackslash : lastcolon );
	titlefield.value = docValue.substr(lastpath+1);
	titlefield.select();
}

function DCNchosen(){
	var titlefield = document.getElementsByName('title')[0];
	var dcnField = document.getElementsByName('DCN')[0];
	var pickField;
	var pickFields = document.getElementsByName('PickDCN');
	for (var i = 0; i < pickFields.length; i++) {
	    if (pickFields[i].nodeName == "SELECT") {
		pickField = pickFields[i];
		break;
	    }
	}
	if (pickField.selectedIndex > 0) {
	    var combo = pickField.options[pickField.selectedIndex].text;
	    var title;
	    var DCN;
	    if (combo.includes(" - ")) {
	        var pos = combo.indexOf(" - ");
	        title = combo.substr(pos+3);
		DCN = combo.substr(0, pos);
		titlefield.value = title;
		dcnField.value = DCN;
	    }
	}
}
