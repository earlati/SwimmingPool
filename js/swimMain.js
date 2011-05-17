// ================================================================
// FILE: swim.js -- rev. 1.001 18.03.2011
// ================================================================
// use as: <script src="/js/swim.js" type="text/javascript"></script>
// ================================================================

// ================================================================
// include_js_file('\/js\/jquery-1.4.2.min.js', 'head');
// include_js_file('\/js\/jquery-ui.js', 'head')
// ================================================================
function include_js_file(filename, location) {
	var body = document.getElementsByTagName('body').item(0);
	script = document.createElement('script');
	script.src = filename;
	script.type = 'text/javascript';
	body.appendChild(script);
}
//================================================================
//================================================================

var userid, userkey;

// ================================================================
$(document).ready(function() {
	Log('swim-main loading .....');
	InitPage()
});
// ================================================================
function InitPage() {
	$("div#error").hide();
	$("div#HelpBox").hide();
	$("div#ChildBox").hide();

	$("img").hover(function() {
		$(this).fadeTo("slow", 0.44);
		$(this).fadeTo("slow", 1.0);
	});

	ManageDebugSection();

	Log("Starting swim-main ... ");
	Log("Param debug: " + $.getUrlVars()['debug']);

	$.ajax({ url : '/cgi-bin/update-counter.pl', success : function(data) {
		// http_refer [http://enzo7/SwimmingPool/] Total visit to
		// [http://enzo7/SwimmingPool/] => TotalVisitors=[22]
		var s1, sa;
		Log("Counter: " + data);
		// data.replace( /.*TotalVisitors=\[(\d+)\]/, '$1' );
		sa = data.split('TotalVisitors');
		s1 = sa[1].replace(/\=\[(\d+)\]/, '$1');
		Log("Total Visitor: " + s1);
		$('#TotalAccess').text('Visits:' + s1);
	} })

	$('.BtnClose').click(function() {
		$(this).parent().hide('slow');
	})
	$('div#debug .BtnMinimize').click(function() {
		if ($(this).parent().height() > '21') {
			$(this).parent().animate({ 'height' : '20px' });
			$(this).css({ 'background-image' : "url(/SwimmingPool/images/arrowUp4.jpg)" });
		} else {
			$(this).parent().animate({ 'height' : '40%' });
			$(this).css({ 'background-image' : "url(/SwimmingPool/images/arrowDown4.jpg)" });
		}

	})

	$("#TotalAccess").click(function() {
		window.open('/cgi-bin/print-counter-log.pl');
		return false;
	});

	$('[class="hint"]').hover(function(e) {
		var objHelp = $("#HelpBox");
		if (objHelp.is(':visible')) {
			return false;
		}
		GetHelp($(this), objHelp);
		var len = objHelp.text().length;
		if (len == 0)
			return;
		var posx, posy, cw, cy;
		cw = $(window).width() / 2;
		cy = $(window).height() / 2;
		posx = e.pageX, posy = e.pageY;
		if (posx > cw)
			posx = posx - objHelp.width();
		if (posy > cy)
			posy = posy - objHelp.height();
		objHelp.css({ 'left' : posx + 'px', 'top' : posy + 'px' });
		ShowHint(objHelp);
	}, function() {
		var objHelp = $("#HelpBox");
		HideHint(objHelp);
	})

	InitPageSwimLogin();

} // ________ function InitPage()

// ==============================================
function InitPageSwimLogin() {

	var user = $.cookie('CurrentUser');
	var idconn = $.cookie('IdConnection');

	// $('#buttonCancel').click( function(){ $("#ChildBox").hide('slow'); } )
	$('#CallLogin').click(function() {
		var idconn = $.cookie('IdConnection');
		if (idconn === undefined || idconn === null) {
			ChildBox('/SwimmingPool/lib/swim.pl?prog=login');
            // window.location.reload();
		} else {
			$.cookie('IdConnection', null);
			$('#CallLogin').html('Login');
			window.location.reload();
		}
	});
	$('#CallRegister').click(function() {
		ChildBox('/SwimmingPool/lib/swim.pl?prog=register');
	});

	Log("Calling LoginProcedure ..... ");
	LoginProcedure();

} // ________ function InitPageSwimLogin()

// ==============================================
function LoginProcedure() {
	var jqxhr, urlQuery, urlData;
	var param = new Array();
	var user = $.cookie('CurrentUser');
	var idconn = $.cookie('IdConnection');

	Log("[LoginProcedure] Current user=" + user + " IdConn=" + idconn);

	if (idconn === undefined || idconn === null) {
		ChildBox('/SwimmingPool/lib/swim.pl?prog=login');
	} else {
		// if idconn has a value query the server for check its validity

		urlQuery = '/SwimmingPool/lib/swim.pl?prog=checkLogin';
		urlData = "idSession=" + idconn;

		jqxhr = $.getJSON(urlQuery, urlData, function(data) {
			$.each(data, function(key, val) {
				param[key] = val;
			});
		});

		jqxhr.error(function() {
			Error("[LoginProcedure] error " + "QueryJson on url: " + urlQuery);
		});

		jqxhr.complete(function() {
			Log("[LoginProcedure.checkIdConn] complete info: " + param['info']);
			Log("[LoginProcedure.checkIdConn] complete error: " + param['error']);
			Log("[LoginProcedure.checkIdConn] idSession: " + param['idSession']);

			$.cookie('IdConnection', param['idSession'], { espires : 20 });
			$.cookie('CurrentUser', param['user'], { espires : 20 });

			idsess = $.cookie('IdConnection');
			user = $.cookie('CurrentUser');

			if (window.idsess != undefined) {
				Log("[LoginProcedure] idSession: " + idsess);
				$('#swim-header ul').append('<li> user:' + user + '</li>');
				$('#CallLogin').html('Logout');
			} else {
				$('#CallLogin').html('Login');
			}
		});
	}

} // ________ function LoginProcedure()

// ================================================================
function AggiornaListaModuliPerl() {
	QueryAjax("/cgi-bin/ListPerlModule.pl", "ListaModuliPerl");
}

// ================================================================
function TestAjax() {
	QueryAjax("/SwimmingPool/lib/swim.pl", "TestOne");
}
// ================================================================
function TestJson() {
	QueryJson("/SwimmingPool/lib/testJson.pl", "TestOne");
}
// ================================================================
