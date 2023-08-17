function toggleSidebar() {
  const sidebar = document.getElementById("sidebar");
  sidebar.classList.toggle("hidden");

  const yieldContent = document.querySelector(".yield-content");
  yieldContent.classList.toggle("sidebar-visible");

  const navbarBrand = document.querySelector(".navbar-brand"); // Ciblez le navbar-brand

  const toggleIcon = document.getElementById("toggleIcon");
  if (!sidebar.classList.contains("hidden")) {
    yieldContent.style.marginLeft = "140px";
    navbarBrand.style.marginLeft = "140px"; // Ajustez le marginLeft du navbar-brand
    toggleIcon.classList.remove("bi-list");
    toggleIcon.classList.add("bi-x");
  } else {
    yieldContent.style.marginLeft = "";
    navbarBrand.style.marginLeft = ""; // Réinitialisez le marginLeft du navbar-brand
    toggleIcon.classList.remove("bi-x");
    toggleIcon.classList.add("bi-list");
  }
}

document.querySelector('.yield-content').addEventListener('click', function() {
  const sidebar = document.getElementById('sidebar');
  if (!sidebar.classList.contains('hidden')) {
    toggleSidebar();
  }
});
