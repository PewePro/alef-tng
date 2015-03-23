var Progressbar = {
  setupProgressbars : function() {
      $.each( $('.week-progressbar'), function( _, progressbar ) {
        var numberAll = $(progressbar).data('number-all');
        var numberDone = $(progressbar).data('number-done');
        var percents = Math.floor(numberDone/numberAll * 100)
        var caption = $(progressbar).find('.progressbar-caption');
        caption.html("Dokončené " + numberDone + "/" + numberAll + " (" + percents + "%)");
        $(progressbar).progressbar({
           value: numberDone,
           max: numberAll
        });
      });
  }
};