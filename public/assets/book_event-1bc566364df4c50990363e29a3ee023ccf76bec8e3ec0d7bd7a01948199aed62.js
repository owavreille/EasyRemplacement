document.addEventListener('turbo:load', function() {
  const reserveButton = document.querySelector('.reserve-button');
  const form = document.querySelector('.form');

  if (reserveButton && form) {
    reserveButton.setAttribute('role', 'button');
    reserveButton.setAttribute('aria-label', 'Réserver ce remplacement');

    reserveButton.addEventListener('keydown', function(event) {
      if (event.key === 'Enter' || event.key === ' ') {
        event.preventDefault();
        form.submit();
      }
    });

    reserveButton.addEventListener('click', function(event) {
      event.preventDefault();
      form.submit();
    });
  }
});
