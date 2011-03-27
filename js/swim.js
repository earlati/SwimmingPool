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
	ManageDebugSection();
	Log( "Totaccess: " + $( '.TotalAccess').text( ));
	
	// $( "div#debug").hide();
    Log( "Starting ... " );
    Log( "params debug: " + $.getUrlVars()['debug'] );
    Log( "params test1: " + $.getUrlVars()['test1'] );
	
    $.ajax({ url : '/cgi-bin/update-counter.pl', 
          success:  function(data){
        	   // http_refer [http://enzo7/SwimmingPool/] Total visit to [http://enzo7/SwimmingPool/] => TotalVisitors=[22] 
        	   var s1, sa;
        	   Log( "Counter: " + data ); 
        	   // data.replace( /.*TotalVisitors=\[(\d+)\]/, '$1' );
        	   sa = data.split( 'TotalVisitors');
        	   s1 = sa[1].replace( /\=\[(\d+)\]/, '$1' );
        	   Log( "Total Visitor: " + s1 ); 
        	   $( '.TotalAccess').text( s1 );
        	   }
    	   })
    
    $("img").hover(function() {
        $(this).fadeTo("slow", 0.44);
        $(this).fadeTo("slow", 1.0);
    });
	
    
    $.hint({ img: '/img/hint.png', opacity:70, color:'#00FFAA' });
    
}   // ________ function InitPage()


// ================================================================
function AggiornaListaModuliPerl() {
	QueryAjax("/cgi-bin/ListPerlModule.pl", "ListaModuliPerl");
}



