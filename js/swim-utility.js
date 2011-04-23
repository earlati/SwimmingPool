// ==============================================
// ==============================================
// ==============================================

// ======================================================
// <script type="text/javascript" src="/js/jquery-1.4.2.min.js" ></script>
// <script type="text/javascript" src="/js/jquery-ui.js" ></script>
// ======================================================
// include_js_file('\/js\/jquery-1.4.2.min.js', 'head');
// include_js_file('\/js\/jquery-ui.js', 'head')
// ======================================================
function include_js_file(filename, location) {
	var body = document.getElementsByTagName('body').item(0);
	script = document.createElement('script');
	script.src = filename;
	script.type = 'text/javascript';
	body.appendChild(script);
}

// ==============================================
$(document).ready(function() {
	include_js_file('/SwimmingPool/js/swim-login.js', 'head');

})

// ==============================================
function ManageDebugSection() {
	var debug, tmp;
	debug = $.cookie('debug');
	Log("Debug from cookie: " + debug);

	if (debug === undefined || debug === null)
		debug = 0;
	tmp = $.getUrlVars()['debug'];
	Log("Debug from web: " + tmp);

	if (tmp === null || tmp === undefined) {
	} else {
		if (tmp > 0) {
			tmp = 1;
			$.cookie('debug', tmp, { expires : 2 });
		} else {
			tmp = 0;
			$.cookie('debug', tmp);
		}
		debug = tmp;
	}
	Log("Debug: " + debug);
	if (debug == 0) {
		$("div#debug").hide();
	} else {
		$("div#debug").show();
	}

} // _________ function ManageDebugSection()

// ==============================================
function Log(msg) {
	var msgout, s1, dt, now;
	dt = new Date();
	now = Math.ceil(dt.getTime() / 1000);

	msgout = "<li> " + now + " " + msg + "</li>";

	$("div#debug ol").prepend(msgout);

}

// ==============================================
function Error(msg) {
	var msgout, s1, dt, now;
	dt = new Date();
	now = Math.ceil(dt.getTime() / 1000);

	msgout = "<li> " + now + " " + msg + "</li>";

	$("div#error").show();
	$("div#error ol").prepend(msgout);

}

// ===========================================
// geturl.params.js
// ===========================================

$.extend({ getUrlVars : function() {
	var vars = [], hash;
	var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
	for ( var i = 0; i < hashes.length; i++) {
		hash = hashes[i].split('=');
		vars.push(hash[0]);
		vars[hash[0]] = hash[1];
	}
	return vars;
}, getUrlVar : function(name) {
	return $.getUrlVars()[name];
} });

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

	$.ajax({ url : urlQuery, cache : false, beforeSend : function() {
		len = obj1.html().length;
		obj1.css({ "color" : "#0000AA", "font" : "30px auto" });
		if (len > 0) {
			obj1.html('Clearing data ....');
			obj1.fadeTo("slow", 0.3);
			obj1.text('');
			return false;
		} else {
			obj1.html('Processing request ....');
			obj1.fadeTo("slow", 0.3);
		}
	}, success : function(data, stato) {
		obj1.css({ "color" : "#006600", "font" : "13px auto" });
		if (len > 0) {
			obj1.text('');
		} else {
			obj1.text('');
			obj1.html(data);
			obj1.fadeTo("slow", 1);
		}
	}, error : function(richiesta, stato, errori) {
		Error("E' evvenuto un errore. Codice errore:[" + stato + "]" + errori);
	} });
}

// ================================================================
// $('[id]').hover(
// function(){ ShowHint( $("#HelpBox") ); GetHelp( $(this), $("#HelpBox") ); },
// function(){ HideHint( $("#HelpBox") ); }
// )
// ================================================================
function ShowHint(objHint) {
	objHint.show();
} // ________ function ShowHint()

// ================================================================
// ================================================================
function HideHint(objHint) {
	objHint.hide();

} // ________ function ShowHint()

// ================================================================
// 
// ================================================================
function GetHelp(objItem, objHint) {

	var obj1, uri, uri2, msg_id, title;
	uri = "/SwimmingPool/swim-help.html";

	// Log("[getHelp] start : objItem => " + objItem.text());

	title = $(objItem).clone().attr("title");
	msg_id = $(objItem).clone().attr("id");
	if (msg_id === null) {
		msg_id = $(objItem).clone().attr("class");
	}
	uri2 = uri + ' #' + msg_id;
	// Log("[getHelp] uri2=" + uri2);
	objHint.load(uri2);
	objHint.prepend('<b>' + msg_id + '</b>');
	// Log("[getHelp] text=" + objHint.text());
    return false;
}

// ================================================================

// ================================================================
// QueryJson("/SwimmingPool/lib/swim.pl", "TestOne");
// ================================================================
function QueryJson(urlQuery, idOutput1) {
	var len, obj1, obj2, jqxhr;
	obj1 = $("#" + idOutput1);

	Log("QueryJson on url: " + urlQuery);

	jqxhr = $.getJSON(urlQuery, function(data) {
		var items = [];

		$.each(data, function(key, val) {
			items.push('<li id="' + key + '">' + key + ' : ' + val + '</li>');
			Log("json: " + key + " : " + val + ' type: ' + typeof (val));
		});

		shtml = items.join(' ');
		obj1.html(shtml);
		obj1.show();
		Log("end ... ");
	}).success(function() {
		Log("success " + "QueryJson on url: " + urlQuery);
	}).error(function() {
		Error("error " + "QueryJson on url: " + urlQuery);
	}).complete(function() {
		Log("complete " + "QueryJson on url: " + urlQuery);
	});

	jqxhr.success(function() {
		Log("success2 " + "QueryJson on url: " + urlQuery);
	});
	jqxhr.complete(function() {
		Log("complete2 " + "QueryJson on url: " + urlQuery);
	});
}

// ================================================================
// ================================================================
function ChildBox(queryUrl, queryParam) {

	var objChild, objInnerChild, fullQuery;
	objChild = $("#ChildBox");
	objInnerChild = $("#InnerChildBox");

	Log("[ChildBox] queryUrl => " + queryUrl);

	objChild.show();
	objInnerChild.empty().html('<img src="/images/loading2.gif" /> ');

	// if (queryParam.lenght > 0)
	// fullQuery = queryUrl + '?' + queryParam;
	// else
	fullQuery = queryUrl;
	objInnerChild.load(fullQuery);

} // ________ function ChildBox()

