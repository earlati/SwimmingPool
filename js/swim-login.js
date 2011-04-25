//==============================================
$(document).ready(function() {

	Log("swim-login loading .... ");

	Log( "check login " + $('#FormLogin').length );
	Log( "check register " + $('#FormRegister').length );
	
	if(  $('#FormLogin').length > 0 )
		{
		  InitLogin();
		}
	else if(  $('#FormRegister').length > 0 )
	{
	    InitRegister();
	}
	

})


//==============================================
function InitLogin()
{
	var user, pwd;

	$('#FormLogin #buttonCancel').click(function() {
		Log('Pressed buttonCancel ');
		$("#ChildBox").hide('slow');
		return false;
	});

	$('#FormLogin #buttonRegister').click(function() {
		Log('Pressed buttonRegister ');
		ChildBox('/SwimmingPool/lib/swim.pl?prog=register')
		return false;
	});

	$('#FormLogin #buttonOk').click(function() {
        var jqxhr, urlQuery, urlData;
	
		user = $('#FormLogin input[name="user_name"]').attr('value');
		pwd = $('#FormLogin input[name="password"]').attr('value');
		Log('Pressed button OK user=' + user + '  pwd=' + pwd);
		$.cookie('CurrentUser', user, {
			espires : 20
		});

		/**********************************
		urlQuery = '/SwimmingPool/lib/swim.pl?prog=checkLogin';
		urlData  = "&user=" + user;
		urlData += "&password=" + pwd;
        Log( "UrlQuery : " + urlQuery + ' ' + urlData );
    	$('#HelpBox').load(urlQuery + urlData );
    	$('#HelpBox').show();
		*************************************/
		
		urlQuery = '/SwimmingPool/lib/swim.pl?prog=checkLogin';
		urlData  = "{ 'user' : '" + user + "', ";
		urlData += " 'password' : '" + pwd + "' }";
        Log( "UrlQuery : " + urlQuery + ' ' + urlData );

        jqxhr = $.getJSON(urlQuery, function(data) {
			$.each(data, function(key, val) {
				Log("json: " + key + " : " + val + ' type: ' + typeof (val));
			});
        });
			
    	jqxhr.error(function() {
    		Error("error " + "QueryJson on url: " + urlQuery);
    	});

		return false;
	});
	
}    // ________  function InitLogin()



//==============================================
function InitRegister()
{
	var user, pwd, enabled, email;
	$('#FormRegister #buttonCancel').click(function() {
		Log('Pressed buttonCancel ');
		$("#ChildBox").hide('slow');
		return false;
	});

	
	$('#FormRegister #buttonOk').click(function() {
        var jqxhr, urlQuery, urlData;
	
		user = $('#FormRegister input[name="user_name"]').attr('value');
		pwd = $('#FormRegister input[name="password"]').attr('value');
		enabled = $('#FormRegister input[name="enabled_user"]').attr('value');
		email = $('#FormRegister input[name="email"]').attr('value');

		Log('Pressed button OK user=' + user + '  pwd=' + pwd + ' enabled=' + enabled + ' email=' + email );

		/**********************************
		urlQuery = '/SwimmingPool/lib/swim.pl?prog=checkLogin';
		urlData  = "&user=" + user;
		urlData += "&password=" + pwd;
        Log( "UrlQuery : " + urlQuery + ' ' + urlData );
    	$('#HelpBox').load(urlQuery + urlData );
    	$('#HelpBox').show();
		*************************************/
		
		urlQuery = '/SwimmingPool/lib/swim.pl?prog=storeRegister';
		urlData  = "{ 'user' : '" + user + "', ";
		urlData += " 'password' : '" + pwd + "' }";
		urlData += " 'enabled_user' : '" + enabled + "' }";
		urlData += " 'email' : '" + email + "' }";
        Log( "UrlQuery : " + urlQuery + ' ' + urlData );

        jqxhr = $.getJSON(urlQuery, function(data) {
			$.each(data, function(key, val) {
				Log("json: " + key + " : " + val + ' type: ' + typeof (val));
			});
        });
			
    	jqxhr.error(function() {
    		Error("error " + "QueryJson on url: " + urlQuery);
    	});

		return false;
	});
	
}    // ________  function InitRegister()




