var ready = (function () {

    // reset eventov na window elemente
    $(window).off('resize');
    $(window).off('scroll');

    if ($('#body-sessions-new').length) {
        Login.initLogin();
    }

    if ($('#body-weeks-show').length) {
        Toggle.initWeekToggle();
        Nav.initUserElement();
        Progressbar.setupProgressbars();
    }

    if ($('#body-questions-show').length) {
        Nav.initUserElement();
        Slider.setupEvaluatorSlider();
        Question.setupForm();
    }

    if ($('#body-weeks-list').length) {
        Nav.initUserElement();
        Progressbar.setupProgressbars();
    }
});

// Uprava kvoli turbolinkam, tento ready kod sa nacita pri kazdom presmerovani
$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:restore', ready);


// Vyhodnotenie gon premennych pri restorovani stranky (napr. "back" v prehliadaci)
var gonfix = function(){
    eval($("#gonvariables > script").html());
};
$(document).on('page:restore', gonfix);
