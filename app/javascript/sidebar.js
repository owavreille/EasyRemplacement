document.addEventListener('turbo:load', function() {
  const sidebar = document.getElementById('sidebar');
  const sidebarToggleBtn = document.querySelector('.sidebar-toggle-btn');
  const mainContent = document.querySelector('.main-content');
  const container = document.querySelector('.container');

  if (sidebar && sidebarToggleBtn) {
    sidebarToggleBtn.addEventListener('click', function(e) {
      e.stopPropagation();
      sidebar.classList.toggle('active');
      mainContent.classList.toggle('shifted');
    });

    // Fermer la sidebar en cliquant sur le container
    container?.addEventListener('click', function(e) {
      if (sidebar.classList.contains('active')) {
        sidebar.classList.remove('active');
        mainContent.classList.remove('shifted');
      }
    });
  }
}); 