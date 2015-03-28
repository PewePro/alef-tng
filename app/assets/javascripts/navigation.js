var Nav = {

    ueHeight : null, //user element height

    initUserElement : function() {
        this.ueHeight = $('#user-element').height();
        $('.nav-offset').css( "height", "+="+this.ueHeight );
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