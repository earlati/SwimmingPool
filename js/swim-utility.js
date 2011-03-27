//==============================================
function ManageDebugSection() {
	var debug, tmp;
	debug = $.cookie('debug');
	Log("Debug from cookie: " + debug);
	tmp = $.getUrlVars()['debug'];
	Log("Debug: " + tmp);
	if (tmp != null) {
		if (tmp > 1)
			tmp = 1;
		debug = tmp;
	}
	$.cookie('debug', debug);
	if (debug == 0)
		$("div#debug").hide();
	else
		$("div#debug").show();

}

// ==============================================
function Log(msg) {
	var msgout, s1, dt, now;
	dt = new Date();
	now = Math.ceil(dt.getTime() / 1000);

	msgout = "<li> " + now + " " + msg + "</li>";

	$("div#debug ol").prepend(msgout);

}

// ===========================================
// geturl.params.js
// ===========================================

$.extend({
	getUrlVars : function() {
		var vars = [], hash;
		var hashes = window.location.href.slice(
				window.location.href.indexOf('?') + 1).split('&');
		for ( var i = 0; i < hashes.length; i++) {
			hash = hashes[i].split('=');
			vars.push(hash[0]);
			vars[hash[0]] = hash[1];
		}
		return vars;
	},
	getUrlVar : function(name) {
		return $.getUrlVars()[name];
	}
});

// ================================================================
// sleep
// ================================================================
function sleep(milliseconds) {
	var start = new Date().getTime();
	for ( var i = 0; i < 1e7; i++) {
		if ((new Date().getTime() - start) > milliseconds) {
			break;
		}
	}
}

// ================================================================
// Toggle
// ================================================================
function Toggle(t, id) {
	var obj;
	obj = document.getElementById(id);
	if (obj.style.display == 'none') {
		$('#' + id).show("slow");
	} else {
		$('#' + id).hide("slow");
	}
	return false;
}

// ================================================================
// ShowCheckedObject
// ================================================================
function ShowCheckedObject(objChecker, objTarget) {
	var obj1, obj2, checked, s1;
	obj1 = objChecker;
	obj2 = objTarget;

	checked = obj1.attr('checked') ? 1 : 0;
	if (checked == 0) {
		obj2.hide("slow");
	} else {
		obj2.show("slow");
	}

} // ________ function ShowCheckedObject()

// ================================================================
// QueryAjax("/cgi-bin/ListPerlModule.pl", "ListaModuliPerl");
// ================================================================
function QueryAjax(urlQuery, idOutput1) {
	var len, obj1, obj2;
	obj1 = $("#" + idOutput1);

	$.ajax({
		url : urlQuery,
		cache : false,
		beforeSend : function() {
			len = obj1.html().length;
			obj1.css({
				"color" : "#0000AA",
				"font" : "30px auto"
			});
			if (len > 0) {
				obj1.html('Clearing data ....');
				obj1.fadeTo("slow", 0.3);
				obj1.text('');
				return false;
			} else {
				obj1.html('Processing request ....');
				obj1.fadeTo("slow", 0.3);
			}
		},
		success : function(data, stato) {
			obj1.css({
				"color" : "#006600",
				"font" : "13px auto"
			});
			if (len > 0) {
				obj1.text('');
			} else {
				obj1.text('');
				obj1.html(data);
				obj1.fadeTo("slow", 1);
			}
		},
		error : function(richiesta, stato, errori) {
			alert("E' evvenuto un errore. Codice errore:[" + stato + "]");
		}
	});
}
