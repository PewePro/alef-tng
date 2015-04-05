var Nav = {

    ueHeight : null, //user element height
    nav : null,

    initUserElement : function() {
        this.nav = $('nav');
        this.ueHeight = $('#user-element').outerHeight();
        navHeight = this.nav.outerHeight();
        $('.nav-offset').css( "height", navHeight + this.ueHeight );

        $('#faux-background').css( "top", this.ueHeight  );


        Nav.autoScrollNav();
        $(window).scroll(function() {
            Nav.autoScrollNav();
        });

        $(document).scrollTop(this.ueHeight);
    },

    autoScrollNav : function() {
        var scroll = $(document).scrollTop();
        if(scroll < this.ueHeight) {

            this.nav.css('position','absolute');
            this.nav.css('top',this.ueHeight);

        } else {
            this.nav.css('position','fixed');
            this.nav.css('top',0);
        }
    }
};