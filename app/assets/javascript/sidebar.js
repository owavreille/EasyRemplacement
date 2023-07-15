document.querySelector('.container').addEventListener('click', function() {
    const sidebar = document.getElementById('sidebar');
    if (!sidebar.classList.contains('hidden')) {
      toggleSidebar();
    }
  });
  
  function toggleSidebar() {
    const sidebar = document.getElementById("sidebar");
    sidebar.classList.toggle("hidden");
  
    const container = document.querySelector(".container");
    container.classList.toggle("sidebar-visible");
  
    const yieldContent = document.querySelector(".yield-content");
    yieldContent.classList.toggle("sidebar-visible");
  
    const navbar = document.querySelector(".navbar");
    navbar.classList.toggle("sidebar-visible");
  
    const toggleIcon = document.getElementById("toggleIcon");
    if (!sidebar.classList.contains("hidden")) {
      yieldContent.style.marginLeft = "140px";
      navbar.style.marginLeft = "140px";
      toggleIcon.classList.remove("bi-list");
      toggleIcon.classList.add("bi-x");
    } else {
      yieldContent.style.marginLeft = "";
      navbar.style.marginLeft = "";
      toggleIcon.classList.remove("bi-x");
      toggleIcon.classList.add("bi-list");
    }
  }
  