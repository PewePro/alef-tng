var Login = {
    
    init : function() {
        Login.positionLogo();
        $(window).resize(function() {
            Login.positionLogo();
        });
    },

    positionLogo : function() {
        var height = $(window).height();
        var logo = $('h1');
        var form = $('.login-form');

        if(height < 430) {
            logo.hide();
            form.css('position','static');
        } else {
            var offset = (height - 430) / 2;
            logo.css('top',offset);
            logo.show();
            form.css('position','absolute');
        }
    }
};