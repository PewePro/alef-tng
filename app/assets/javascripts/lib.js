function isBound(el, ev, action) {
    var found = false;

    var events = $._data(el).events[ev];
    if (events !== undefined) {
        $.each(events, function(i, e) {
            if (e.handler === action) {
                found = true;
            }
        });
    }

    return found;
}


function bindIfNotBounded(el, ev, action) {
    if(!isBound(el, ev, action)) {
        $(el).on(ev, action);
    }
}

// @source http://product.reverb.com/2015/04/09/fun-with-setinterval-and-turbolinks/
function turbolinksSetInterval(intervalFunction, seconds) {
    var interval = setInterval(intervalFunction, seconds);
    $(document).on('page:change', removeInterval);

    function removeInterval() {
        clearInterval(interval);
        $(document).off('page:change', removeInterval);
    }
}