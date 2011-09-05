// ================================================================
// FILE: swimMain.js -- rev. 1.001 14.07.2011
// ================================================================
// use as: <script src="/js/swim.js" type="text/javascript"></script>
// ================================================================


//================================================================
//================================================================

var userid, userkey;

// ================================================================
$(document).ready(function() {
	$("div#error").hide();
	$("div#HelpBox").hide();
	$("div#ChildBox").hide();

    // $.ajaxSetup({ async:false});

   	Log('swim-main loading InitPage().....');
    InitPage();

});
// ================================================================
function InitPage() {
	$("div#error").hide();
	$("div#HelpBox").hide();
	$("div#ChildBox").hide();
	
	// $( "#user_menu" ).msDropDown( {mainCSS:'dd2'} );

	$("img").hover(function() {
		$(this).fadeTo("slow", 0.44);
		$(this).fadeTo("slow", 1.0);
	});

	ManageDebugSection();

	Log("[InitPage] Starting swim-main ... ");
	Log("[InitPage] Param debug: " + $.getUrlVars()['debug']);

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

    UpdateForm_TotalAccess( 'TotalAccess' );
    // InitFormLogin();
	InitPageSwimLogin();

} // ________ function InitPage()

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
