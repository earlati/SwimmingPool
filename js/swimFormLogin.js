//==============================================
$(document).ready(function() {

	Log("swim-login loading .... ");

	Log("check login " + $('#FormLogin').length);
	Log("check register " + $('#FormRegister').length);

	if ($('#FormLogin').length > 0) {
		InitLogin();
	} else if ($('#FormRegister').length > 0) {
		InitRegister();
	}

	$('.Loading').hide('slow');
})
// ________ $(document).ready(function()

// ==============================================
function InitLogin() {
	var user, pwd, idsess;

	$('#FormLogin #buttonCancel').click(function() {
		Log('[Login] Pressed buttonCancel ');
		$("#ChildBox").hide('slow');
		return false;
	});

	$('#FormLogin #buttonRegister').click(function() {
		Log('[Login] Pressed buttonRegister ');
		ChildBox('/SwimmingPool/lib/swim.pl?prog=register')
		return false;
	});

	$('#FormLogin #buttonOk').click(function() {
		var jqxhr, urlQuery, urlData;
		var param = new Array();

		user = $('#FormLogin input[name="user_name"]').attr('value');
		pwd = $('#FormLogin input[name="password"]').attr('value');
		Log('[Login] Pressed OK user=' + user + '  pwd=' + pwd);
		$.cookie('CurrentUser', user, { espires : 20 });

		/***********************************************************************
		 * urlQuery = '/SwimmingPool/lib/swim.pl?prog=checkLogin'; urlData =
		 * "&user=" + user; urlData += "&password=" + pwd; Log( "UrlQuery : " +
		 * urlQuery + ' ' + urlData ); $('#HelpBox').load(urlQuery + urlData );
		 * $('#HelpBox').show();
		 **********************************************************************/

		urlQuery = '/SwimmingPool/lib/swim.pl?prog=checkLogin';
		urlData = "user=" + user;
		urlData += "&pwd=" + pwd;
		Log("[Login] UrlQuery : " + urlQuery + ' ' + urlData);

		jqxhr = $.getJSON(urlQuery, urlData, function(data) {
			$.each(data, function(key, val) {
				Log("[Login] json: " + key + " : " + val);
				param[key] = val;
			});
		});

		jqxhr.error(function() {
			Error("[Login] error " + "QueryJson on url: " + urlQuery);
		});

		jqxhr.complete(function() {
			$('#StatusFormLogin').html('<p> ' + param['info']);
			$.cookie('IdConnection', param['idSession'], { espires : 20 });
			idsess = $.cookie('IdConnection');
			if (idsess != undefined) {
				$("#ChildBox").hide('slow');
				window.location.reload();
			}
		});

		return false;
	});

} // ________ function InitLogin()

// ==============================================
function InitRegister() {
<<<<<<< HEAD
	var user, pwd, enabled, email, email2;
=======
	var user, pwd, enabled, email;
>>>>>>> 4b30d2513a35fca7302277adc911bf01c25903d1

	$('#FormRegister #buttonCancel').click(function() {
		Log('[Register] Pressed buttonCancel ');
		$("#ChildBox").hide('slow');
		return false;
	});

	$('#FormRegister #buttonLogin').click(function() {
		Log('[Register] Pressed buttonLogin ');
		ChildBox('/SwimmingPool/lib/swim.pl?prog=login')
		return false;
	});

	$('#FormRegister #buttonOk').click(function() {
		var jqxhr, urlQuery, urlData;
		var param = new Array();

		user = $('#FormRegister input[name="user_name"]').attr('value');
		pwd = $('#FormRegister input[name="password"]').attr('value');
		checked = $('#FormRegister input[name="enabled_user"]').attr('checked');
		email = $('#FormRegister input[name="email"]').attr('value');
<<<<<<< HEAD
		email2 = $('#FormRegister input[name="email2"]').attr('value');
=======
>>>>>>> 4b30d2513a35fca7302277adc911bf01c25903d1

		Log('[Register] Pressed OK : user=' + user + ' email=' + email);

		/***********************************************************************
		 * urlQuery = '/SwimmingPool/lib/swim.pl?prog=storeRegister'; urlData =
		 * "&user=" + user; urlData += "&password=" + pwd; Log( "UrlQuery : " +
		 * urlQuery + ' ' + urlData ); $('#HelpBox').load(urlQuery + urlData );
		 * $('#HelpBox').show();
		 **********************************************************************/

		urlQuery = '/SwimmingPool/lib/swim.pl?prog=storeRegister';
		urlData = "user=" + user;
		urlData += "&pwd=" + pwd;
		urlData += "&checked=" + checked;
		urlData += "&email=" + email;
<<<<<<< HEAD
		urlData += "&email2=" + email2;
=======
>>>>>>> 4b30d2513a35fca7302277adc911bf01c25903d1

		Log("[Register] UrlQuery : " + urlQuery);

		jqxhr = $.getJSON(urlQuery, urlData, function(data) {
			$.each(data, function(key, val) {
				Log("[Register] key=" + key + " : val=" + val);
				param[key] = val;
			});
		});

		jqxhr.error(function() {
			Error("[Register] error " + "QueryJson on url: " + urlQuery);
		});

		jqxhr.complete(function() {
			Log("[Register] complete info: " + param['info']);
			Log("[Register] complete error: " + param['error']);
			$('#StatusFormRegister').html('<p>' + param['info']);
		});

		return false;
	});

} // ________ function InitRegister()

