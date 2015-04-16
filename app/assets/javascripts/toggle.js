var Toggle = {
    initWeekToggle : function() {
        $('#week-toggle .toggle-item').click(function() {
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
    },

    reset : function(element) {
        element.find('.toggle-item').removeClass('active');
    },

    select : function(toggle,itemName) {
        id = toggle.attr('id');
        $('#'+id+'-'+itemName).addClass('active');
    }
}