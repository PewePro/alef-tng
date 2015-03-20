var Question = {

    setupSubmit : function() {
        $('.question-evaluations').hide();
        $(".question-form").submit(function() {
            Question.disableForm();
        });
    },

    disableForm : function() {
        // Upravi moznosti pod otazkou a vypne formulare

        if ($('#question-form-evaluatorquestion').length) {
            $('#evaluator-slider').slider("disable")
        }
        if ($('#question-form-singlechoicequestion').length ||
            $('#question-form-multichoicequestion').length) {
            $('input').prop('disabled',true);
        }
        $('.question-button').hide();
        $('.question-evaluations').show();
    },

    evaluateAnswers : function(solution) {
        if ($('#question-form-evaluatorquestion').length) {
            this.evaluateEvaluatorQuestion(solution);
        }
        if ($('#question-form-singlechoicequestion').length ||
            $('#question-form-multichoicequestion').length) {
            this.evaluateChoiceQuestion(solution);
        }
    },

    evaluateEvaluatorQuestion : function(solution) {

    },

    evaluateChoiceQuestion : function(solution) {
        // Ak hodnotime
        // pre kazdu odpoved hod flag is-correct, is-incorrect
        // ak je rozpor v odpovediach vykresli NESPRAVNE
        // inak vykresli SPRAVNE

        // Ak vykreslujeme
        // Odznac formular
        // pre kazdu odpoved hod flag is-correct-noeval, is-incorrect-noeval

        // Vykresli tlacidlo dalsia otazka
    }
};