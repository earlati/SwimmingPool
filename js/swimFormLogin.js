//==============================================


// ==============================================
function InitPageSwimLogin() {

	var user = $.cookie('CurrentUser');
	var idconn = $.cookie('IdConnection');

	$('#CallLogin').click(function() {
		var idconn = $.cookie('IdConnection');
		if (idconn === undefined || idconn === null) { LoadFormLogin();
		} else {
			$.cookie('IdConnection', null);
			$('#CallLogin').html('Login');
			window.location.reload();
		}
	});
	$('#CallRegister').click(function() {
		LoadFormRegister();
	});

	LoginProcedure();

} // ________ function InitPageSwimLogin()


// ==============================================
function LoadFormLogin() 
{
	Log( " LoadFormLogin .... " );
	ChildBox('/SwimmingPool/lib/swim.pl?prog=login', null, InitLogin );
			
}  // _______  function LoadFormLogin()

// ==============================================
function LoadFormRegister() 
{
	Log( " LoadFormRegister .... " );
	ChildBox('/SwimmingPool/lib/swim.pl?prog=register', null, InitRegister );
			
}  // _______  function LoadFormRegister()



// ==============================================
function LoginProcedure() {
	var jqxhr, urlQuery, urlData;
	var param = new Array();
	var user = $.cookie('CurrentUser');
	var idconn = $.cookie('IdConnection');

	Log("[LoginProcedure] Current user=" + user + " IdConn=" + idconn);

	if (idconn === undefined || idconn === null) 
	{
		LoadFormLogin();
	} 
	else 
	{
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
	
	Log( "[LoginProcedure] Ended" );
	

} // ________ function LoginProcedure()



// ==============================================
function InitLogin() {
	var user, pwd, idsess;

    Log( '[InitLogin]' );
	$('#FormLogin #buttonCancel').click(function() {
		Log('[Login] Pressed buttonCancel ');
		$("#ChildBox").hide('slow');
		return false;
	});

	$('#FormLogin #buttonRegister').click(function() {
		Log('[Login] Pressed buttonRegister ');
		$("#ChildBox").hide('slow');
        LoginFormRegister();
		return false;
	});

	$('#FormLogin #buttonOk').click(function() {
		var jqxhr, urlQuery, urlData;
		var param = new Array();

		user = $('#FormLogin input[name="user_name"]').val();
		pwd = $('#FormLogin input[name="password"]').val();
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

    $( '.Loading' ).hide( 'slow' );

} // ________ function InitLogin()



// ==============================================
function InitRegister() {
	var user, pwd, enabled, email, email2;

    Log( '[InitRegister]' );

	$('#FormRegister #buttonCancel').click(function() {
		Log('[Register] Pressed buttonCancel ');
		$("#ChildBox").hide('slow');
		return false;
	});

	$('#FormRegister #buttonLogin').click(function() {
		Log('[Register] Pressed buttonLogin ');
		$("#ChildBox").hide('slow');
		LoginFormLogin();
		return false;
	});

	$('#FormRegister #buttonOk').click(function() {
		var jqxhr, urlQuery, urlData;
		var param = new Array();

		user = $('#FormRegister input[name="user_name"]').val();
		pwd = $('#FormRegister input[name="password"]').val();
		checked = $('#FormRegister input[name="enabled_user"]').attr('checked');
		email = $('#FormRegister input[name="email"]').val();
		email2 = $('#FormRegister input[name="email2"]').val();

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
		urlData += "&email2=" + email2;

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

    $( '.Loading' ).hide( 'slow' );

} // ________ function InitRegister()

