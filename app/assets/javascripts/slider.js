var Slider = {
    setupEvaluatorSlider : function(slider) {
            $(slider).slider({
                animate: 'fast',
                max: 7,
                min: 1,
                orientation: 'horizontal',
                range: "min",
                value: 4
            });
    }
};