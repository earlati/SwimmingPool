


// ================================================================
function PreviewBoxVolantini(queryUrl ) {

        var objChild, objInnerChild, w, h, shtml;

        
        $("#PreviewBox").show();

        objChild = $("#PreviewBox");
        objInnerChild = objChild.find("#InnerPreviewBox");
        w = objInnerChild.width(); 
        h = objInnerChild.height(); 

        if( queryUrl.length == 0 )
        {  
			objChild.hide();
			return;
			}

        objInnerChild.empty().html('<img src="/images/loading2.gif" /> <i>Loading: ' + queryUrl +'</i>' );
        objChild.show();
        
        $.get( queryUrl , function(data) { shtml = data; 
       
        shtml = '<img src="' + queryUrl + '" width="' + w + '" height="' + h + '" />' ;
        objInnerChild.empty().html(shtml);
        });        
        

} // ________ function PreviewBoxVolantini()


// ================================================================
// AjaxLoadIamgesList( '../lib/loadListImages.pl', 'images_list', 'volantino' );
// ================================================================
function AjaxLoadIamgesList( urlQuery, idOutput, idClass ) {
	var len, obj1, obj2;
	
	obj1 = $("#" + idOutput);

	$.ajax({ url : urlQuery, cache : false, 
	beforeSend : function() {
		obj1.css({ "color" : "#0000AA", "font" : "30px auto" });
		obj1.text('');
		obj1.html('Processing request ....');
		obj1.fadeTo("slow", 0.3);
	}, 
	success : function(data, stato) {
		obj1.css({ "color" : "#006600", "font" : "13px auto" });
		obj1.text('');
	    obj1.html( data );
        obj1.append( '<br/><br/><br/> ' );

		obj1.fadeTo("slow", 1);
		
		$( '.' + idClass ).hover( 
	         function() {
				 var href, imgname;
				 imgname = $(this).find( 'a' ).attr( 'href' );
				 PreviewBoxVolantini( imgname );
				 },
	         function() { 
				  // $("#InnerPreviewBox").empty();
				    $("#PreviewBox").hide();
				  }
		);
		
		$( '.' + idClass ).click( 
	         function() {
				 var urlname, imgname;
				 imgname = $(this).find( 'a' ).attr( 'href' );
                 window.open(imgname, imgname, null );
             	}); 
    },    	
	error : function(richiesta, stato, errori) {
		obj1.css({ "color" : "#FF0000", "font" : "20px auto" });
		obj1.html( 'ERRORE. Codice errore:[' + stato + ']  ' + errori + ' <p></p> ' );
		obj1.fadeTo("slow", 1);
	} });
}

// ==============================================
function LoadListatoVolantini() {

    $( '#TitoloListato1' ).html( 'Listato Volantini corse podistiche' )
	 	                  .css( ' border-bottom: 1px solid black;' );
	$( '#TitoloListato1' ).attr( 'class', 'rblu' ) ;
    AjaxLoadIamgesList( '../SwimmingPool/lib/loadListImages.pl', 'Listato1', 'volantino' );

       return false;

}  // ________ function LoadListatoVolantini()

// ==============================================
function InitPagePodismo() {

	var user = $.cookie('CurrentUser');
	var idconn = $.cookie('IdConnection');

    $( '#TitoloListato1' ).click( function() {  LoadListatoVolantini(); return false; });
    $( '#VolantiniPodismo' ).click( function() {  LoadListatoVolantini(); return false; });

     //  LoadListatoVolantini();
     
     

}  // ________ function InitPagePodimso()

