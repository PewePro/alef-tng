var Admin = {
    setupWeekConceptTable : function() {
        $('#week-concept-table td').click(function() {
            var i = $(this).find('input[type=checkbox]');
            if(i.is(':checked')) {
                i.prop( "checked", false );
            } else {
                i.prop( "checked", true );
            }
        });

        $('#week-concept-table td input').click(function(event) {
            event.stopPropagation();
        });

        $('.switch-all').click(function() {
            var val = $(this).is(':checked');
            var week = $(this).data('week');
            $('input[data-week='+week+']').prop("checked",val);
        });
    }
};