var Progressbar = {
  setupProgressbars : function() {
      $.each( $('.week-progressbar'), function( _, progressbar ) {
        var numberAll = $(progressbar).data('number-all');
        var numberDone = $(progressbar).data('number-done');
        var percents = Math.floor(numberDone/numberAll * 100)
        var caption = $(progressbar).find('.progressbar-caption');
        caption.html("Vyriešené testy " + numberDone + "/" + numberAll + " (" + percents + "%)");
        $(progressbar).progressbar({
           value: numberDone,
           max: numberAll
        });
      });
      $.each( $('.question-progressbar'), function( _, progressbar ) {
          var numberAll = $(progressbar).data('number-all');
          var numberDone = $(progressbar).data('number-done');
          var caption = $(progressbar).find('.progressbar-caption');
          caption.html("Dosiahnuté " + parseFloat(numberDone).toFixed(2) + " - Minimum " + parseFloat(numberAll).toFixed(2));
          $(progressbar).progressbar({
              value: parseFloat(numberDone),
              max: numberAll
          });
      });
      $.each( $('.room-progressbar'), function( _, progressbar ) {
          var numberAll = $(progressbar).data('number-all');
          var numberDone = $(progressbar).data('number-done');
          var percents = Math.floor(numberDone/numberAll * 100)
          var caption = $(progressbar).find('.progressbar-caption');
          caption.html("Správne zodpovedané " + numberDone + "/" + numberAll + " (" + percents + "%)");
          $(progressbar).progressbar({
              value: numberDone,
              max: numberAll
          });
      });
  }
};