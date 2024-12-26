document.addEventListener('turbo:load', function() {
  const reserveButton = document.querySelector('.reserve-button');
  const form = document.querySelector('.form');

  if (reserveButton && form) {
    reserveButton.addEventListener('click', function(event) {
      event.preventDefault();
      form.submit();
    });
  }
});
