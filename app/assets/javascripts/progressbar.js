var Progressbar = {
  setupProgressbars : function() {
      $.each( $('.week-progressbar'), function( _, progressbar ) {
        var numberAll = $(progressbar).data('number-all');
        var numberDone = $(progressbar).data('number-done');
        $(progressbar).progressbar({
           value: numberDone,
           max: numberAll
        });
      });
  }
};