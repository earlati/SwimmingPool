//==============================================
$(document).ready(function() {
	var user, pwd;

	Log("swim-login loading .... ");

	$('#FormLogin #buttonCancel').click(function() {
		Log('Pressed buttonCancel ');
		$("#ChildBox").hide('slow');
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

})
