var Question = {

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
        alert(solution);
        // disable formular
        // zmaz tlacidla

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