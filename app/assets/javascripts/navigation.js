var Nav = {

    initAutohideNav : function() {
        $('.nav-offset').height($('nav').outerHeight());
        Nav.autohideNav();
        $(window).scroll(function() {
            Nav.autohideNav();
        });
    },

    autohideNav : function() {
        var scroll = $(document).scrollTop();
        var size = $('nav h2').height();
        if(scroll > size) {
            $('nav').css('position','fixed');
            $('nav h2').hide();
            $('.nav-offset').show();
        } else {
            $('nav').css('position','static');
            $('nav h2').show();
            $('.nav-offset').hide();
        }
    }
};