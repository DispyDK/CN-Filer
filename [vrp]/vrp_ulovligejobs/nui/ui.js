$(document).ready(function(){
    window.addEventListener( 'message', function( event ) {
        var item = event.data;
        if ( item.showPlayerMenu == true ) {
	        $('body').css('background-color','transparent');
            $('.container-fluid').css('display','block');
        } else if ( item.showPlayerMenu == false ) { // Hide the menu
            $('.container-fluid').css('display','none');
            $('body').css('background-color','transparent important!');
            $("body").css("background-image","none");
        }
    });
    $("#producent").click(function(){
        $.post('http://vrp_ulovligejobs/producent', JSON.stringify({}));
        2
    });
    $("#kemiker").click(function(){
        $.post('http://vrp_ulovligejobs/kemiker', JSON.stringify({}));
        2
    });
    $("#pusher").click(function(){
        $.post('http://vrp_ulovligejobs/pusher', JSON.stringify({}));
        2
    });
    $("#indbrudstyv").click(function(){
        $.post('http://vrp_ulovligejobs/indbrudstyv', JSON.stringify({}));
        2
    });
    $("#closebtn").click(function(){
        $.post('http://vrp_ulovligejobs/closeButton', JSON.stringify({}));
        2
    });
})
