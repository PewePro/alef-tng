var Nav = {

    ueHeight : null, //user element height
    nav : null,
    lastZoom : null,

    init : function() {
        Contact.init();
        Nav.initUserElement();

        // nastavovanie spravania pri zoomovani
        Nav.lastZoom = detectZoom.zoom();
        Nav.firstZoom = detectZoom.zoom() + 0.1; // mala odchylka, aby clovek nemusel odzoomovat nadoraz
        setInterval(this.checkZoom, 500);
    },

    initUserElement : function() {
        var ue = $('#user-element');
        this.ueHeight = ue.outerHeight();
        this.ueHeight = ue.height(0);
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
        $('.not-zoomable').css('opacity',1);
        this.offset.toggleClass('hidden');
    },

    hideNav : function() {
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