document.getElementById('user-icon').onclick = function () {
    var dropdown = document.getElementById('dropdown-content');
    if (dropdown.style.display === "none" || dropdown.style.display === "") {
        dropdown.style.display = "block"; // Hiển thị dropdown
    } else {
        dropdown.style.display = "none"; // Ẩn dropdown
    }
};

// Đóng dropdown nếu nhấp ra ngoài
window.onclick = function (event) {
    if (!event.target.matches('.user-icon')) {
        var dropdowns = document.getElementsByClassName("dropdown-content");
        for (var i = 0; i < dropdowns.length; i++) {
            var openDropdown = dropdowns[i];
            if (openDropdown.style.display === "block") {
                openDropdown.style.display = "none"; // Ẩn dropdown nếu nhấp ra ngoài
            }
        }
    }
}
