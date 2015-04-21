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
        var ue = $('#user-element');
        this.ueHeight = ue.outerHeight();
        this.ueHeight = ue.height(0);
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