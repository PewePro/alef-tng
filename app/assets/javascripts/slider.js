var Slider = {

    slider : null,

    setupEvaluatorSlider : function() {
        this.slider = $('.evaluator-slider');
        if (this.slider.length == 0) return;

        $(this.slider).slider({
            animate: 'fast',
            max: 100,
            min: 0,
            orientation: 'horizontal',
            range: "min",
            value: 50,

            change: function(event, ui) {
                var name_id = "answer[" + event.target.id.toString() + "]";
                var value = ui.value;
                var answerInput = $('input[name="' + name_id + '"]');
                answerInput.val(value);
            }
        });
    },

    showSolution : function(solution, key) {
        this.slider = $('#' + key);

        if(solution == null) {
            solution = 50;
        }

        this.slider.slider( "value", Math.round(solution) );
        var handle = this.slider.find('.ui-slider-handle').first();
        this.createSolutionInfo(handle,solution);

    },

    evaluateAnswer : function(solution, key) {
        this.slider = $('#' + key);

        if(solution == null) {
            solution = 50;
        }

        var value = this.slider.slider( "value" );
        var solution = Math.round(solution);

        this.slider.slider( "option", { range: true } );
        this.slider.slider( "values", 0, value );
        this.slider.slider( "values", 1, value );

        var handles = this.slider.find('.ui-slider-handle');


        if (solution < value) {

            this.slider.slider( "values", 0, solution);
            this.createSolutionInfo(handles.first(),solution);
            this.createAnswerInfo(handles.last());

        } else {

            this.slider.slider( "values", 1, solution);
            this.createSolutionInfo(handles.last(),solution);
            this.createAnswerInfo(handles.first());

        }
    },

    createSolutionInfo : function(handle,solution) {
        $('<div/>', {
            id: 'handle-solution-info',
            text: 'Priemer: ' + Math.round(solution)
        }).prependTo(handle);
    },

    createAnswerInfo : function(handle) {
        $('<div/>', {
            id: 'handle-answer-info',
            text: 'Tvoja odpoveď'
        }).prependTo(handle);
    }
};