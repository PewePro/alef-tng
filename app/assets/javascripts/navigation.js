var Nav = {

    ueHeight : null, //user element height

    initUserElement : function() {
        this.ueHeight = $('#user-element').outerHeight();
        $('.nav-offset').css( "height", "+="+this.ueHeight );

        // pripad ked je prilis mala obrazovka a neslo by zoscrollovat dost dole
        if($(document).height() - $(window).height() - $(window).scrollTop() == 0) {
            $('#faux-background').css( "height", "+="+this.ueHeight );
        }

        $(document).scrollTop(this.ueHeight);
        $(window).scroll(function() {
            Nav.autoScrollNav();
        });
    },

    autoScrollNav : function() {
        var scroll = $(document).scrollTop();
        if(scroll < this.ueHeight) {
            $('nav').css('top', this.ueHeight - scroll);
        } else {
            $('nav').css('top',0);
        }
    }
};