function toggleSidebar() {
  const sidebar = document.getElementById("sidebar");
  const isHidden = sidebar.classList.toggle("hidden");
  sidebar.setAttribute("aria-hidden", isHidden);

  const yieldContent = document.querySelector(".yield-content");
  yieldContent.classList.toggle("sidebar-visible");

  const navbarBrand = document.querySelector(".navbar-brand");
  const toggleIcon = document.getElementById("toggleIcon");

  if (!sidebar.classList.contains("hidden")) {
    yieldContent.style.marginLeft = "140px";
    navbarBrand.style.marginLeft = "140px";
    toggleIcon.classList.remove("bi-list");
    toggleIcon.classList.add("bi-x");
    toggleIcon.setAttribute("aria-label", "Fermer le menu");
  } else {
    yieldContent.style.marginLeft = "";
    navbarBrand.style.marginLeft = "";
    toggleIcon.classList.remove("bi-x");
    toggleIcon.classList.add("bi-list");
    toggleIcon.setAttribute("aria-label", "Ouvrir le menu");
  }
}

// Attendre que le DOM soit chargé
document.addEventListener('turbo:load', function() {
  const yieldContent = document.querySelector('.yield-content');
  if (yieldContent) {
    yieldContent.addEventListener('click', function() {
      const sidebar = document.getElementById('sidebar');
      if (sidebar && !sidebar.classList.contains('hidden')) {
        toggleSidebar();
      }
    });
  }

  // Ajouter les attributs ARIA initiaux
  const toggleIcon = document.getElementById("toggleIcon");
  if (toggleIcon) {
    toggleIcon.setAttribute("role", "button");
    toggleIcon.setAttribute("aria-label", "Ouvrir le menu");
    toggleIcon.setAttribute("tabindex", "0");
  }

  const sidebar = document.getElementById("sidebar");
  if (sidebar) {
    sidebar.setAttribute("role", "navigation");
    sidebar.setAttribute("aria-label", "Menu principal");
  }
});
