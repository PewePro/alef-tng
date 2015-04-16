var Toggle = {
    initWeekToggle : function() {
        toggle = $('.toggle');
        toggle.find('.toggle-item').click(function() {
            var id = $(this).attr('id');

            switch(id) {
                case 'week-toggle-learning':
                    $.ajax({
                        url: '/user/toggle-show-solutions',
                        method: 'POST',
                        data: {
                            show_solutions: true
                        }
                    });
                    break;
                case 'week-toggle-testing':
                    $.ajax({
                        url: '/user/toggle-show-solutions',
                        method: 'POST',
                        data: {
                            show_solutions: false
                        }
                    });
                    break;
            }
        });
        toggle.find('.toggle-help-btn').click(function() {
            Toggle.help(toggle);
        });
    },

    reset : function(toggle) {
        toggle.find('.toggle-item').removeClass('active');
    },

    select : function(toggle,itemName) {
        id = toggle.attr('id');
        $('#'+id+'-'+itemName).addClass('active');
    },

    help : function(toggle) {
        id = toggle.attr('id');
        $('#'+id+'-help').toggleClass('active');
    }

}