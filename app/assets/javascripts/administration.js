var Admin = {
    setupWeekConceptTable : function() {
        $('#week-concept-table td').click(function() {
            var i = $(this).find('input[type=checkbox]');
            if(i.is(':checked')) {
                i.click();
            } else {
                i.click();
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
    },

    setupQuestionConceptConfig : function() {
        this.setupConceptDelete();
        $('.question-concept-table-cell').click(function() {
            $(this).toggleClass('show');
        });

        $('.concept-autocomplete').autocomplete({
            source: gon.concepts
        });

        $('.concept-add').click(function() {
            var input = $('.concept-autocomplete[data-question-id='+$(this).data('question-id')+']');
            Admin.addConcept(input);
        });

        $('.concept-autocomplete').keyup(function(e){
            if (e.keyCode==13) {
                Admin.addConcept($(this));
            }
        })

    },

    addConcept : function(input) {
        $.ajax({
            url: window.location+'/add_question_concept',
            method: 'POST',
            data: {
                question_id: input.data('question-id'),
                concept_name: input.val()
            }
        });
    },

    setupConceptDelete : function() {
        $('.concept-delete').click(function() {
            $.ajax({
                url: window.location+'/delete_question_concept',
                method: 'POST',
                data: {
                    question_id: $(this).data('question-id'),
                    concept_id: $(this).data('concept-id')
                }
            });
        });
    }

};