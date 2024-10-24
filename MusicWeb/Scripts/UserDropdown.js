const userIcon = document.getElementById('user-icon');
const dropdownContent = document.getElementById('dropdown-content');

userIcon.addEventListener('click', () => {
    dropdownContent.style.display = dropdownContent.style.display === 'block' ? 'none' : 'block';
});

// Để ẩn dropdown khi nhấn ra ngoài
window.addEventListener('click', (event) => {
    if (!userIcon.contains(event.target) && !dropdownContent.contains(event.target)) {
        dropdownContent.style.display = 'none';
    }
});