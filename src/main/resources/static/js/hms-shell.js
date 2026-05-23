(function () {
    "use strict";

    var toggleButton = document.getElementById("hmsSidebarToggle");
    var sidebar = document.getElementById("hmsSidebar");

    if (toggleButton && sidebar) {
        toggleButton.addEventListener("click", function () {
            sidebar.classList.toggle("open");
        });
    }
})();
