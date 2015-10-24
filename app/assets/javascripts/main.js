var ready = (function () {

    // reset eventov na window elemente
    $(window).off('resize');
    $(window).off('scroll');

    if ($('#body-sessions-new').length) {
        Login.init();
    }

    if ($('#body-weeks-show').length) {
        Toggle.initWeekToggle();
        Nav.init();
        Progressbar.setupProgressbars();
    }

    if ($('#body-rooms-show').length) {
        Toggle.initWeekToggle();
        Nav.init();
        Progressbar.setupProgressbars();
    }

    if ($('#body-questions-show').length) {

        Nav.init();
        Slider.setupEvaluatorSlider();
        Question.setupForm();
        Question.initTimeLog();

    }

    if ($('#body-weeks-list').length) {
        Nav.init();
        Progressbar.setupProgressbars();
    }

    if ($('#body-administrations-setup_config').length) {
        Admin.setupWeekConceptTable();
    }

    if ($('#body-administrations-question_concept_config').length) {
        Admin.setupQuestionConceptConfig()
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
