var ready = (function () {
    if ($('#body-sessions-new').length) {
        Login.initLogin();
    }

    if ($('#body-weeks-show').length) {
    }

    if ($('#body-questions-show').length) {
        Nav.initAutohideNav();
    }
});

// Uprava kvoli turbolinkam, tento ready kod sa nacita pri kazdom presmerovani
$(document).ready(ready);
$(document).on('page:load', ready);
