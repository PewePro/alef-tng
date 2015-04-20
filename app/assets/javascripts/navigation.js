var Nav = {

    ueHeight : null, //user element height
    nav : null,
    offset : null,

    lastZoom : null,
    firstZoom : null,

    init : function() {
        Contact.init();
        Nav.initUserElement();

        // nastavovanie spravania pri scrollovani
        $(document).scrollTop(this.ueHeight);
        Nav.autoScrollNav();
        $(window).scroll(function() {
            Nav.autoScrollNav();
        });

        // nastavovanie spravania pri zoomovani
        Nav.lastZoom = detectZoom.zoom();
        Nav.firstZoom = detectZoom.zoom() + 0.1; // mala odchylka, aby clovek nemusel odzoomovat nadoraz
        setInterval(this.checkZoom, 500);
    },

    initUserElement : function() {
        // nastavovanie vysok a umiestneni rozlicnych elementov
        this.nav = $('nav');
        this.ueHeight = $('#user-element').outerHeight();
        this.offset = $('.nav-offset');
        var navHeight = this.nav.outerHeight();
        this.offset.css( "height", navHeight + this.ueHeight );
        $('#faux-background').css( "top", this.ueHeight  );
    },

    checkZoom : function() {
        var currentZoom = detectZoom.zoom();
        if(currentZoom > Nav.firstZoom && Nav.lastZoom <= Nav.firstZoom) {
            Nav.hideNav();
        }
        if(currentZoom <= Nav.firstZoom && Nav.lastZoom > Nav.firstZoom) {
            Nav.showNav();
        }
        Nav.lastZoom = currentZoom;
    },

    showNav : function () {
        this.isScrolling = false;
        $('.not-zoomable').css('opacity',1);
        this.offset.toggleClass('hidden');
    },

    hideNav : function() {
        this.isScrolling = true;
        $('.not-zoomable').css('opacity',0);
        this.offset.toggleClass('hidden');
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