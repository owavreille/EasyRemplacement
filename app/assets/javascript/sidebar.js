function toggleSidebar() {
  const sidebar = document.getElementById("sidebar");
  if (!sidebar) return;
  
  sidebar.classList.toggle("hidden");

  const yieldContent = document.querySelector(".yield-content");
  if (!yieldContent) return;
  
  yieldContent.classList.toggle("sidebar-visible");

  const navbarBrand = document.querySelector(".navbar-brand");
  const toggleIcon = document.getElementById("toggleIcon");
  
  if (!sidebar.classList.contains("hidden")) {
    yieldContent.style.marginLeft = "140px";
    if (navbarBrand) navbarBrand.style.marginLeft = "140px";
    if (toggleIcon) {
      toggleIcon.classList.remove("bi-list");
      toggleIcon.classList.add("bi-x");
    }
  } else {
    yieldContent.style.marginLeft = "";
    if (navbarBrand) navbarBrand.style.marginLeft = "";
    if (toggleIcon) {
      toggleIcon.classList.remove("bi-x");
      toggleIcon.classList.add("bi-list");
    }
  }
}

document.addEventListener('DOMContentLoaded', function() {
  const yieldContent = document.querySelector('.yield-content');
  const sidebar = document.getElementById('sidebar');
  
  if (yieldContent && sidebar) {
    yieldContent.addEventListener('click', function() {
      if (!sidebar.classList.contains('hidden')) {
        toggleSidebar();
      }
    });
  }
});
