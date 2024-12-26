function toggleSidebar() {
  const sidebar = document.getElementById("sidebar");
  sidebar.classList.toggle("hidden");

  const yieldContent = document.querySelector(".yield-content");
  yieldContent.classList.toggle("sidebar-visible");

  const navbarBrand = document.querySelector(".navbar-brand");
  const toggleIcon = document.getElementById("toggleIcon");

  if (!sidebar.classList.contains("hidden")) {
    yieldContent.style.marginLeft = "140px";
    navbarBrand.style.marginLeft = "140px";
    toggleIcon.classList.remove("bi-list");
    toggleIcon.classList.add("bi-x");
  } else {
    yieldContent.style.marginLeft = "";
    navbarBrand.style.marginLeft = "";
    toggleIcon.classList.remove("bi-x");
    toggleIcon.classList.add("bi-list");
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
});
