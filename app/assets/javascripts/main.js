var ready = (function () {

    // reset eventov na window elemente
    $(window).off('resize');
    $(window).off('scroll');

    if ($('#body-sessions-new').length) {
        Login.init();
    }

    if ($('#body-weeks-show').length || $('#body-rooms-show').length || $('#body-rooms-eval').length) {
        Toggle.initWeekToggle();
        Nav.init();
        Progressbar.setupProgressbars();
    }

    if ($('#body-questions-show').length) {

        Toggle.initWeekToggle();
        Nav.init();
        Slider.setupEvaluatorSlider();
        Question.setupForm();
        Question.initTimeLog();
        Progressbar.setupProgressbars();

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

    if ($('.admin-nav').length) {
        Admin.checkNavOffset();
    }

    // Aktivacia tooltipov.
    $('[data-toggle="tooltip"]').tooltip();

    // Aktivacia moment.js.
    moment.locale('sk');
    $('.livestamp').each(function(){
        $(this).livestamp($(this).attr('data-timestamp'));
    });

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
