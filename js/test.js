 
$(document).ready(function() 
{

   $("#testLogin").click( function(){ QueryAjax("/SwimmingPool/lib/test.pl?formLogin", "OutputCommand", "pre" ); })

   $("#testMail").click( function(){ QueryAjax("/SwimmingPool/t/test_sendmail.pl", "OutputCommand", "pre"); })
   
   $('#testJson').click( function() { QueryJson("/SwimmingPool/t/testJson.pl", "OutputCommand", "pre"); })
					
})
		
