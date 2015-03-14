var ready = (function () {
    if ($('#body-sessions-new').length) {
        Login.initLogin();
        console.log(4);
    }

    if ($('#body-weeks-show').length) {
        console.log(5);
    }

    if ($('#body-questions-show').length) {
        console.log(6);
        Nav.initAutohideNav();
    }
});

// Uprava kvoli turbolinkam, tento ready kod sa nacita pri kazdom presmerovani
$(document).ready(ready);
$(document).on('page:load', ready);
