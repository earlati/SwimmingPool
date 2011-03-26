// ==============================================
// FILE: swim.js -- rev. 1.001 18.03.2011
// ==============================================
// use as: <script src="/js/swim.js" type="text/javascript"></script>
// ==============================================

var userid, userkey;


// ================================================================
$(document).ready( function(){ InitPage() });
// ================================================================
function InitPage()
{
	// $( "div#debug").hide();
    Log( "Starting ... " );
	
    $.ajax({ url : '/cgi-bin/update-counter.pl', 
          success:  function(data){ Log( "Counter: " + data ); }
    	   })
    
    $("img").hover(function() {
        $(this).fadeTo("slow", 0.44);
        $(this).fadeTo("slow", 1.0);
    });
	
    
}   // ________ function InitPage()

//==============================================
function Log( msg )
{
   var msgout, s1, dt, now;
   dt = new Date();
   now=Math.ceil(dt.getTime()/1000);

   msgout = "<li> " +now + " " + msg + "</li>";

   $( "div#debug ol" ).prepend( msgout );

}

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
function sleep(milliseconds) {
	var start = new Date().getTime();
	for ( var i = 0; i < 1e7; i++) {
		if ((new Date().getTime() - start) > milliseconds) {
			break;
		}
	}
}


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
function OnChangeAbilitaObjecTemplate() {
	var obj1, obj2;
	obj1 = $("input[name=ABILITA_ObjecTemplate]");
	obj2 = $("#ObjecTemplate");
	ShowCheckedObject(obj1, obj2);

} // ________ function OnChangeAbilitaObjecTemplate()



// ================================================================
function AggiornaListaModuliPerl() {
	QueryAjax("/cgi-bin/ListPerlModule.pl", "ListaModuliPerl");
}
// ================================================================
function QueryAjax(urlQuery, idOutput1) {
	var len, obj1, obj2;
	obj1 = $("#" + idOutput1);

	$.ajax( {
		url : urlQuery,
                cache : false,
		beforeSend : function() {
			len = obj1.html().length;
			obj1.css( {
				"color" : "#0000AA",
				"font" : "30px auto"
			});
			if (len > 0)
                        {
				obj1.html('Clearing data ....' );
			        obj1.fadeTo( "slow", 0.3);
				obj1.text('' );
                                return false;
			} 
                        else
                        {
				obj1.html('Processing request ....' );
			        obj1.fadeTo("slow", 0.3);
			}
		},
		success : function(data, stato) {
			obj1.css( {
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


