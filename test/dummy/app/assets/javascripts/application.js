//= require popper
//= require bootstrap-sprockets
//= require @rails/ujs
//= require notyf/notyf.min

Rails.start();

window.addEventListener('DOMContentLoaded', function () {
    'use strict';
    var notyfAlert = document.querySelector('.js-notyf-alert'),
        notyfNotice = document.querySelector('.js-notyf-notice'),
        notyf = new Notyf(),
        openNotyf;

    openNotyf = function (element, type, backgroundColor) {
        notyf.open({
            type: type,
            icon: false,
            background: backgroundColor,
            position: {
                x: 'center',
                y: 'bottom'
            },
            message: element.innerText,
            duration: 9000,
            ripple: true,
            dismissible: true
        });
    };

    if (notyfAlert !== null) {
        openNotyf(notyfAlert, 'error', '#E1531B');
    }

    if (notyfNotice !== null) {
        openNotyf(notyfNotice, 'success', '#0D3CC8');
    }
});
