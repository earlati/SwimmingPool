//==============================================


// ==============================================
function InitPageSwimLogin() {

	var user = $.cookie('CurrentUser');
	var idconn = $.cookie('IdConnection');

	$('#CallLogin').click(function() {
		var idconn = $.cookie('IdConnection');
		if (idconn === undefined || idconn === null) 
		{ 
			LoadFormLogin();
		} 
		else 
		{
			$.cookie('IdConnection', null);
			$('#CallLogin').html('Login');
			window.location.reload();
		}
	});
	
	$('#CallRegister').click(function()   {	LoadFormRegister();	  });
	$('#CallResetPwd').click(function()   {	LoadFormResetPwd();	  });
	$('#CallChangePwd').click(function()  {	LoadFormChangePwd();  });
	$('#CallEnableUser').click(function() {	LoadFormEnableUser(); });

	LoginProcedure();

}  // ________ function InitPageSwimLogin()


// ==============================================
function LoadFormLogin() 
{
	Log( " LoadFormLogin .... " );
	ChildBox('/SwimmingPool/lib/swim.pl?prog=formLogin', null, InitLogin );
			
}  // _______  function LoadFormLogin()

// ==============================================
function LoadFormRegister() 
{
	Log( " LoadFormRegister .... " );
	ChildBox('/SwimmingPool/lib/swim.pl?prog=formRegister', null, InitRegister );
			
}  // _______  function LoadFormRegister()



// ==============================================
function LoadFormResetPwd() 
{
	Log( " LoadFormResetPwd .... " );
	ChildBox('/SwimmingPool/lib/swim.pl?prog=formResetPwd', null, InitResetPwd );
			
}  // _______  function LoadFormResetPwd()


// ==============================================
function LoadFormChangePwd() 
{
	Log( " LoadFormChangePwd .... " );
	ChildBox('/SwimmingPool/lib/swim.pl?prog=formChangePwd', null, InitChangePwd );
			
}  // _______  function LoadFormResetPwd()



// ==============================================
function LoadFormEnableUser() 
{
	Log( " LoadFormEnableUser .... " );
	ChildBox('/SwimmingPool/lib/swim.pl?prog=formEnableUser', null, InitEnableUser );
			
}  // _______  function LoadFormEnableUser()


// ==============================================
function LoginProcedure() {
	var jqxhr, urlQuery, urlData;
	var param  = new Array();
	var user   = $.cookie('CurrentUser');
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
//  SECTION : INIT PROCEDURE
// ==============================================


// ==============================================
function JsonCommonCompleteStatus( jqxhr, _headerLog, formStsName, urlQuery, param ) 
{
    var HeaderLog = '[' + _headerLog + ']';
    	
		jqxhr.error(function() {
			Error( HeaderLog + " error " + "QueryJson on url: " + urlQuery);
		});

		jqxhr.complete(function() {
			Log( HeaderLog + " complete info: " + param['info']);
			Log( HeaderLog + " complete error: " + param['error']);
			$('#' + formStsName ).html('<p>' + param['info']);
			
			if( param['error'] != undefined  &&  param['error'].length > 3 )
			{
				Error( HeaderLog + " complete error: " + param['error'] );
			}
			else { Info( param['info'] ); }
		});	
	
}  // ______________ function JsonCommonCompleteStatus( jqxhr, headerLog, ... )

// ==============================================
function InitLogin() {
	var user, pwd, idsess;
	var Fun = "[InitLogin] ";
	var idForm = '#FormLogin';
	
	user = $.cookie('CurrentUser');
	idsess = $.cookie('IdConnection');
	Log( Fun + ' Found user=' + user );
	
	$( idForm + ' input[name="user_name"]').val( user );

    Log( Fun );
    
	$( idForm + ' #buttonCancel').click(function() {
		Log( Fun + 'Pressed buttonCancel ');
		$("#ChildBox").hide('slow');
		return false;
	});

	$( idForm + ' #buttonRegister').click(function() {
		Log( Fun + 'Pressed buttonRegister ');
        LoadFormRegister();
		return false;
	});

	$( idForm + ' #buttonResetPassword').click(function() {
		Log( Fun + 'Pressed buttonResetPassword ');
		LoadFormResetPwd();
		return false;
	});

	$( idForm + ' #buttonOk').click(function() {
		var jqxhr, urlQuery, urlData;
		var param = new Array();

		user = $( idForm + ' input[name="user_name"]').val();
		pwd = $( idForm + ' input[name="password"]').val();
		Log( Fun + ' Pressed OK user=' + user + '  pwd=' + pwd);
		$.cookie('CurrentUser', user, { espires : 20 });

		/***********************************************************************
		 * urlQuery = '/SwimmingPool/lib/swim.pl?prog=checkLogin'; 
		 * urlData = "&user=" + user; 
		 * urlData += "&password=" + pwd; 
		 * Log( "UrlQuery : " + urlQuery + ' ' + urlData ); 
		 * $('#HelpBox').load(urlQuery + urlData );
		 * $('#HelpBox').show();
		 **********************************************************************/

		urlQuery = '/SwimmingPool/lib/swim.pl?prog=checkLogin';
		urlData = "user=" + user;
		urlData += "&pwd=" + pwd;
		Log( Fun + "UrlQuery : " + urlQuery + ' ' + urlData);

		jqxhr = $.getJSON(urlQuery, urlData, function(data) {
			$.each(data, function(key, val) {
				Log( Fun + "JSON: " + key + " : " + val);
				param[key] = val;
			});
		});

        JsonCommonCompleteStatus( jqxhr, "Login", 'StatusFormLogin', urlQuery, param );

		jqxhr.complete(function() {
			// $('#StatusFormLogin').html('<p> ' + param['info']);
			$.cookie('IdConnection', param['idSession'], { espires : 20 });
			idsess = $.cookie('IdConnection');
			
			Log( Fun + 'CurrentUser: ' + $.cookie('CurrentUser') );
			Log( Fun + 'IdConnection: ' + $.cookie('IdConnection') );
			
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
	var idForm = '#FormRegister';

    Log( '[InitRegister]' );

	$( idForm + ' #buttonCancel').click(function() {
		Log('[Register] Pressed buttonCancel ');
		$("#ChildBox").hide('slow');
		return false;
	});

	$( idForm + ' #buttonLogin').click(function() {
		Log('[Register] Pressed buttonLogin ');
		LoadFormLogin();
		return false;
	});

	$( idForm + ' #buttonOk').click(function() {
		var jqxhr, urlQuery, urlData;
		var param = new Array();

		user = $(idForm + ' input[name="user_name"]').val();
		pwd = $(idForm + ' input[name="password"]').val();
		checked = $(idForm + ' input[name="enabled_user"]').attr('checked');
		email = $(idForm + ' input[name="email"]').val();
		email2 = $(idForm + ' input[name="email2"]').val();

		Log('[Register] Pressed OK : user=' + user + ' email=' + email);

		/***********************************************************************
		 * urlQuery = '/SwimmingPool/lib/swim.pl?prog=storeRegister'; 
		 * urlData = "&user=" + user; 
		 * urlData += "&password=" + pwd; 
		 * Log( "UrlQuery : " + urlQuery + ' ' + urlData ); 
		 * $('#HelpBox').load(urlQuery + urlData );
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

        JsonCommonCompleteStatus( jqxhr, "Register", 'StatusFormRegister', urlQuery, param );
		return false;
	});

    $( '.Loading' ).hide( 'slow' );

} // ________ function InitRegister()




// ==============================================
function InitResetPwd() {
	var user, email;
	var idForm = '#FormResetPwd';

    Log( '[InitResetPwd]' );

	$( idForm + ' #buttonCancel').click(function() {
		$("#ChildBox").hide('slow');
		return false;
	});

	$( idForm + ' #buttonOk').click(function() {
		var jqxhr, urlQuery, urlData;
		var param = new Array();

		email = $( idForm + ' input[name="email"]').val();

		Log('[ResetPwd] Pressed OK : email=' + email);

		/***********************************************************************
		 * urlQuery = '/SwimmingPool/lib/swim.pl?prog=reqRemoteResetPwd'; 
		 * urlData = "&email=" + email; 
		 * $('#HelpBox').load(urlQuery + urlData );
		 * $('#HelpBox').show();
		 **********************************************************************/

		urlQuery = '/SwimmingPool/lib/swim.pl?prog=reqRemoteResetPwd';
		urlData  = "email=" + email;

		Log("[ResetPwd] UrlQuery : " + urlQuery + ' ' + urlData);

		jqxhr = $.getJSON(urlQuery, urlData, function(data) {
			$.each(data, function(key, val) {
				Log("[ResetPwd] key=" + key + " : val=" + val);
				param[key] = val;
			});
		});

        $( "#StatusFormResetPwd" ).empty().html('<img src="/images/loading3.gif" width="300px"/> ');
        JsonCommonCompleteStatus( jqxhr, "ResetPwd", 'StatusFormResetPwd', urlQuery, param );
		return false;
	});

    $( '.Loading' ).hide( 'slow' );

} // ________ function InitResetPwd()





// ==============================================
function InitChangePwd() {
	var user, oldpwd, newpwd, newpwd2, obj;
	var fun = '[ChangePwd]';
	var idForm = '#FormChangePwd';

	user = $.cookie('CurrentUser');
	obj = $( idForm + ' input[name="user_name"]');
	obj.val(user);

    Log( fun + 'Starting  currUser: ' + user );
	/***********************************************************************
	 **********************************************************************/

	$( idForm + ' #buttonCancel').click(function() {
		$("#ChildBox").hide('slow');
		return false;
	});

	$( idForm + ' #buttonOk').click(function() {
		var jqxhr, urlQuery, urlData;
		var param = new Array();

		user    = $( idForm + ' input[name="user_name"]').val();
		oldpwd  = $( idForm + ' input[name="password"]').val();
		newpwd  = $( idForm + ' input[name="newpwd1"]').val();
		newpwd2 = $( idForm + ' input[name="newpwd2"]').val();

        // in newpwd != newpwd2 then error  goto to input pwd
		Log( fun + "user : " + user + ' oldpwd:' + oldpwd + ' npwd:' + newpwd + ' npwd2:' + newpwd2);

		urlQuery = '/SwimmingPool/lib/swim.pl?prog=changePwd';
		urlData  = "user=" + user;
		urlData += "&oldpwd=" + oldpwd;
		urlData += "&newpwd=" + newpwd;

        //  UrlQuery : /SwimmingPool/lib/swim.pl?prog=changePwd undefinedoldpwd=&newpwd=aaa
		Log( fun + "CLICK: UrlQuery : " + urlQuery + ' ' + urlData);

		jqxhr = $.getJSON(urlQuery, urlData, function(data) {
			$.each(data, function(key, val) {
				Log( fun + "key=" + key + " : val=" + val);
				param[key] = val;
			});
		});

        $( "#StatusFormChangePwd" ).empty().html('<img src="/images/loading3.gif" width="300px"/> ');
        JsonCommonCompleteStatus( jqxhr, "ChangePwd", 'StatusFormChangePwd', urlQuery, param );
		return false;
	});

    $( '.Loading' ).hide( 'slow' );

} // ________ function InitChangePwd()

// ==============================================
function InitEnableUser() {
	var user, pwd, enable_user, email, obj1;
	var fun = '[EnableUser] ';
	var idForm = '#FormEnableUser';

    Log( "Init" + fun );

	$( idForm + ' #buttonCancel').click(function() {
		$("#ChildBox").hide('slow');
		return false;
	});

	$( idForm + ' #buttonOk').click(function() {
		var jqxhr, urlQuery, urlData;
		var param = new Array();

		email = $( idForm + ' input[name="email"]').val();
		enable_user = $( idForm + ' input[name="enabled_user"]').is(':checked');
		
		Log( fun + 'Pressed OK : email=' + email + ' enabled: ' + enable_user );

		/***********************************************************************
		 * urlQuery = '/SwimmingPool/lib/swim.pl?prog=reqRemoteResetPwd'; 
		 * urlData = "&email=" + email; 
		 * $('#HelpBox').load(urlQuery + urlData );
		 * $('#HelpBox').show();
		 **********************************************************************/

		urlQuery = '/SwimmingPool/lib/swim.pl?prog=reqRemoteEnableUser';
		urlData  = "enable_user=" + enable_user;
		urlData += "&email=" + email;

		Log( fun + "UrlQuery : " + urlQuery);

		jqxhr = $.getJSON(urlQuery, urlData, function(data) {
			$.each(data, function(key, val) {
				Log( fun + "key=" + key + " : val=" + val);
				param[key] = val;
			});
		});

		jqxhr.error(function() {
			Error(fun + "Error " + "QueryJson on url: " + urlQuery);
		});

        $( "#StatusFormEnableUser" ).empty().html('<img src="/images/loading3.gif" width="300px"/> ');
        JsonCommonCompleteStatus( jqxhr, "EnableUser", 'StatusFormEnableUser', urlQuery, param );

		return false;
	});

    $( '.Loading' ).hide( 'slow' );

} // ________ function InitEnableUser()

