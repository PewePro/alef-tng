var Login = {
    positionLogo : function() {
        var height = $(window).height();
        var logo = $('h1');

        if(height < 430) {
            logo.hide();
        } else {
            var offset = (height - 430) / 2;
            logo.css('top',offset);
            logo.show();
        }
    }
}

$(function(){
    Login.positionLogo();
});
$(window).resize(function() {
    Login.positionLogo();
});