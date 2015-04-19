var Alert = {
    success : function(message) {

        outerDiv = $('<div/>', {
            class: 'alert'
        }).prependTo('body');

        $('<div/>', {
            class: 'message',
            text: message
        }).appendTo(outerDiv);
    }
}