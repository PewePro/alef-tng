var Slider = {
    setupEvaluatorSlider : function() {
        var slider = $('#evaluator-slider');
        if (slider.length == 0) return;

        $(slider).slider({
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
    }
};