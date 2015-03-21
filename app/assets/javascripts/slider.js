var Slider = {

    slider : null,

    setupEvaluatorSlider : function() {
        this.slider = $('#evaluator-slider');
        if (this.slider.length == 0) return;

        $(this.slider).slider({
            animate: 'fast',
            max: 100,
            min: 0,
            orientation: 'horizontal',
            range: "min",
            value: 50,

            change: function(event, ui) {
                var value = ui.value;
                var answerInput = $('input[name=answer]');
                answerInput.val(value);
            }
        });
    },

    showSolution : function(solution) {

        this.slider.slider( "value", Math.round(solution) );

    },

    evaluateAnswer : function(solution) {

        var value = this.slider.slider( "value" );
        var solution = Math.round(solution);

        this.slider.slider( "option", { range: true } );
        this.slider.slider( "values", 0, value );
        this.slider.slider( "values", 1, value );

        if (solution < value)
            this.slider.slider( "values", 0, solution);
        else
            this.slider.slider( "values", 1, solution);

    }
};