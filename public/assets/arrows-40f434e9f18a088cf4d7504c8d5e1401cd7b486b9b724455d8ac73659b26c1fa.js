document.addEventListener('keydown', function(event) {
    if (event.key === "ArrowLeft") {
      document.getElementById('previous-button').click();
    } else if (event.key === "ArrowRight") {
      document.getElementById('next-button').click();
    }
  });
  
