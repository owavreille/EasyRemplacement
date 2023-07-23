document.addEventListener('DOMContentLoaded', function() {
    const reserveButton = document.querySelector('.reserve-button');
    const form = document.querySelector('.form');

    reserveButton.addEventListener('click', function(event) {
      event.preventDefault();
      form.submit();
    });
  });