var Nav = {

    ueHeight : null, //user element height
    nav : null,
    lastZoom : null,

    init : function() {
        Contact.init();
        Nav.initUserElement();

        // nastavovanie spravania pri zoomovani
        lastZoom = detectZoom.zoom();
        setInterval(this.checkZoom, 500);
    },

    initUserElement : function() {
        // nastavovanie vysok a umiestneni rozlicnych elementov
/*        this.nav = $('nav');
        this.ueHeight = $('#user-element').outerHeight();
        var navHeight = this.nav.outerHeight();
        $('.nav-offset').css( "height", navHeight + this.ueHeight );
        $('#faux-background').css( "top", this.ueHeight  );*/
    },

    checkZoom : function() {
        var currentZoom = detectZoom.zoom();
        if(currentZoom > 1 && Nav.lastZoom <= 1) {
            Nav.hideNav();
        }
        if(currentZoom <= 1 && Nav.lastZoom > 1) {
            Nav.showNav();
        }
        Nav.lastZoom = currentZoom;
    },

    showNav : function () {
        $('.not-zoomable').css('opacity',1);
        this.offset.toggleClass('hidden');
    },

    hideNav : function() {
        $('.not-zoomable').css('opacity',0);
        this.offset.toggleClass('hidden');
    }

};