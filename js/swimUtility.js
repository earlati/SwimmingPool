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
//function include_js_file(filename, location) {
	//var body = document.getElementsByTagName('body').item(0);
	//script = document.createElement('script');
	//script.src = filename;
	//script.type = 'text/javascript';
	//body.appendChild(script);
//}

// ==============================================
// $(document).ready(function() {
//	include_js_file('/SwimmingPool/js/swimFormLogin.js', 'head');
// })

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
	// now = Math.ceil(dt.getTime() / 1000);
	now = dt.getHours() + ":" + dt.getMinutes() + ":" +  
	      dt.getSeconds() + "." + dt.getMilliseconds();

	msgout = "<li> " + now + " " + msg + "</li>";

	$("div#debug ol").prepend(msgout);
}

// ==============================================
function Info(msg) {
	var msgout, s1, dt, now;
	dt = new Date();
	now = dt.getHours() + ":" + dt.getMinutes() + ":" +  
	      dt.getSeconds() + "." + dt.getMilliseconds();

	msgout =  "<p/>" + msg ;
	$("div#info ol").html(msgout);
	$("div#info").fadeIn( 'slow');
	$("div#info").fadeOut( 8000 );
}


// ==============================================
function Error(msg) {
	var msgout, s1, dt, now;
	dt = new Date();
	// now = Math.ceil(dt.getTime() / 1000);
	now = dt.getHours() + ":" + dt.getMinutes() + ":" +  
	      dt.getSeconds() + "." + dt.getMilliseconds();

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
function QueryAjax(urlQuery, idOutput1, usePre ) {
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
		} else 
		{
			obj1.text('');
			if (usePre === undefined || usePre === null )
			{
			    obj1.html(  data );
			}
			else
			{
			    obj1.html( '<pre>' + data + '</pre>' );
			}

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
	// objHint.prepend('<b>' + msg_id + '</b>');
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
			Log("json: " + key + " : " + val );
		});

		shtml = items.join(' ');
		obj1.html(shtml);
		obj1.show();
		Log("end ... ");
	}).success(function() {
		Log("QueryJson success " + " on url: " + urlQuery);  
	}).error(function( jqXHR, textStatus ) {
		Error("QueryJson error [" + textStatus + "]  on url: " + urlQuery +
              "incoming Text " + jqXHR.responseText);
	}).complete(function() {
		Log("QueryJson complete " + " on url: " + urlQuery);
	});


}


// ================================================================
function CenterBox( objBox ) {
    var left, top;
	left = ( $(window).width() - objBox.width() ) / 2;
	top  = ( $(window).height() - objBox.height() ) / 2;
	if( top < 0 ) 
	{
        // Log( "[CenterBox] window.height " + $(window).height() + " objBox.height " + objBox.height()  );
        // Log( "[CenterBox] objBox. top " + top + " ** FORCE to 1 ** " );
		top = 1;
    }

	objBox.css( { 'left': left + 'px', 'top' : top + 'px' });
	
}  // ________ function CenterBox( objBox )


// ================================================================
// ================================================================
function ChildBox(queryUrl, queryParam, callback ) {

	var objChild, objInnerChild, fullQuery, position, left, top;
	objChild = $("#ChildBox");
	objInnerChild = $("#InnerChildBox");

	// Log("[ChildBox] queryUrl => " + queryUrl );

	CenterBox( objChild );
	objChild.show();
	
	objInnerChild.empty().html('<img src="/images/loading2.gif" /> ');

	fullQuery = queryUrl;
	objInnerChild.load(fullQuery, function(response, status, xhr)  
	{    
      if (status == "error") 
      {
         var msg = "Sorry but there was an error: ";
         Log( "[ChildBox] ERRORE " + msg );
         Error( "[ChildBox] ERRORE [" + xhr.status + "]" + response );
      }
      else
      {  
		  if ( callback ) 
		  {  
			  callback();  
		  }
	   }	  
    });

} // ________ function ChildBox()


// ================================================================
//   UpdateForm_TotalAccess( 'TotalAccess' );
// ================================================================
function UpdateForm_TotalAccess( idResult ) 
{
	$.ajax({ url : '/cgi-bin/update-counter.pl', 
	    success : function(data) {
		var s1, sa;
		// Log("[UpdateForm_TotalAccess]  data: " + data);
		// 23:12:3.765 [UpdateForm_TotalAccess] data: Total visit to [http://enzo7/SwimmingPool/index.html] => TotalVisitors=[40] 
		sa = data.split('TotalVisitors');
		s1 = sa[1].replace(/\=\[(\d+)\]/, '$1');
		Log("[UpdateForm_TotalAccess] Total Visitor: " + s1);
		$( '#' + idResult ).text('Visits:' + s1);
	} })

	
}  // _________  function UpdateForm_TotalAccess()



