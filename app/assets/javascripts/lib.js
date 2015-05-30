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
