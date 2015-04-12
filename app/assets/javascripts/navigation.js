var Nav = {

    ueHeight : null, //user element height
    ue : null,
    nav : null,

    startingWidth : null, // pouziva sa pri kontrole zoomu
    lastWidth : null,

    init : function() {

        // nastavovanie vysok a umiestneni rozlicnych elementov
        this.nav = $('nav');
        this.ue = $('#user-element');
        this.ueHeight = this.ue.outerHeight();
        navHeight = this.nav.outerHeight();
        $('.nav-offset').css( "height", navHeight + this.ueHeight );
        $('#faux-background').css( "height", '+='+this.ueHeight  );

        // nastavovanie spravania pri scrollovani
        Nav.autoScrollNav();
        $(window).scroll(function() {
            Nav.autoScrollNav();
        });
        $(document).scrollTop(this.ueHeight);

        // nastavovanie spravania pri zoomovani
        /*this.startingWidth = window.innerWidth;
        this.lastWidth = window.innerWidth;*/
        setInterval(this.checkZoom, 2000);
    },

    checkZoom : function() {
        var zoom = detectZoom.zoom();
        var device = detectZoom.device();
        alert(zoom+' '+device);
       /* var nowWidth = window.innerWidth

        if (nowWidth == Nav.lastWidth) return;


        if (nowWidth >= Nav.startingWidth && Nav.lastWidth < Nav.startingWidth) Nav.showNav();
        if (nowWidth < Nav.startingWidth && Nav.lastWidth >= Nav.startingWidth) Nav.hideNav();

        Nav.lastWidth = nowWidth;*/

    },

    showNav : function () {
        $('.not-zoomable').css('opacity',1);
    },

    hideNav : function() {
        $('.not-zoomable').css('opacity',0);
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