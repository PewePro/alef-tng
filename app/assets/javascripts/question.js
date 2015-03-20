var Question = {

    type : null,

    isSingleChoice : function() { return this.type == "singlechoicequestion"; },
    isMultiChoice : function() { return this.type == "multichoicequestion"; },
    isEvaluator : function() { return this.type == "evaluatorquestion"; },

    setupForm : function() {

        // nastavi typ otazky
        var formId = $('.question-form').attr('id');
        this.type = (/form-(.*)/.exec(formId))[1];

        // nastavi formular
        $('.question-evaluations').hide();
        $(".question-form").submit(function() {
            Question.disableForm();
        });
        $('.answer-input').prop('disabled',false);
    },

    disableForm : function() {
        // Upravi moznosti pod otazkou a vypne formulare

        if (this.isEvaluator()) {
            $('#evaluator-slider').slider("disable")
        }
        if (this.isSingleChoice() || this.isMultiChoice()) {
            $('.answer-input').prop('disabled',true);
        }
        $('.question-button').hide();
    },

    evaluateAnswers : function(solution) {

        if (this.isEvaluator()) {
            this.evaluateEvaluatorQuestion(solution);
        }
        if (this.isSingleChoice() || this.isMultiChoice()) {
            this.evaluateChoiceQuestion(solution);
        }

        $('#question-evaluation-next').show();
    },

    evaluateEvaluatorQuestion : function(solution) {

    },

    evaluateChoiceQuestion : function(solution) {

        var isSolutionCorrect = true;

        $('.answer-input').each(function() {
            var isChecked = $(this).is(':checked');
            var inputValue = parseInt($(this).val());
            var isRight = $.inArray(inputValue, solution) != -1;

            if(isChecked == isRight) {
                $(this).addClass('answer-is-correct');
            } else {
                $(this).addClass('answer-is-incorrect');
                isSolutionCorrect = false;
            }
        });

        if(isSolutionCorrect) {
            $('#question-evaluation-right').show();
        } else {
            $('#question-evaluation-wrong').show();
        }
    },

    showSolution : function(solution) {

        if (this.isEvaluator()) {
            this.showEvaluatorSolution(solution);
        }
        if (this.isSingleChoice() || this.isMultiChoice()) {
            this.showChoiceSolution(solution);
        }

        $('#question-evaluation-next').show();
    },

    showEvaluatorSolution : function(solution) {

    },

    showChoiceSolution : function(solution) {
        $('.answer-input').each(function() {
            var inputValue = parseInt($(this).val());
            var isRight = $.inArray(inputValue, solution) != -1;

            if(isRight) {
                $(this).prop( "checked", true );
            } else {
                $(this).prop( "checked", false );
            }

        });

        $('#question-evaluation-show').show();
    }
};