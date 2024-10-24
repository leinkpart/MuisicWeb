document.addEventListener('DOMContentLoaded', function () {
    // Tìm tất cả các nút play với lớp playListPlay và play-circle
    const playButtons = document.querySelectorAll('.playListPlay, .play-circle');
    let currentAudio = null; // Biến lưu audio hiện tại đang phát
    let currentButton = null; // Biến lưu nút hiện tại tương ứng với bài hát đang phát

    playButtons.forEach(button => {
        button.addEventListener('click', function () {
            const songItem = this.closest('.songItem') || this.closest('.ItemSong'); // Tìm phần tử chứa bài hát
            const audio = songItem.querySelector('audio'); // Tìm phần tử audio trong cùng thẻ songItem hoặc ItemSong

            // Kiểm tra nếu bài đang phát và nút được nhấn là bài hiện tại
            if (audio === currentAudio && !audio.paused) {
                audio.pause(); // Tạm dừng nhạc 
                this.className = this.className.replace('bi-pause-circle-fill', 'bi-play-circle-fill'); // Đổi biểu tượng thành play
                currentAudio = null; // Đặt currentAudio về null khi tạm dừng
                currentButton = null; // Đặt currentButton về null khi tạm dừng
            } else {
                // Nếu một bài khác đang phát thì dừng nó và đặt thời gian về 0
                if (currentAudio && currentAudio !== audio) {
                    currentAudio.pause();
                    currentAudio.currentTime = 0; // Đặt thời gian phát về 0 cho bài khác
                    if (currentButton) {
                        currentButton.className = currentButton.className.replace('bi-pause-circle-fill', 'bi-play-circle-fill'); // Đổi biểu tượng bài trước thành play
                    }
                }

                // Phát bài hiện tại
                audio.play();
                this.className = this.className.replace('bi-play-circle-fill', 'bi-pause-circle-fill'); // Đổi biểu tượng thành pause
                currentAudio = audio; // Cập nhật audio hiện tại
                currentButton = this; // Cập nhật nút hiện tại

                // Xóa sự kiện cũ trước khi thêm mới để tránh xung đột
                audio.removeEventListener('ended', handleAudioEnded);
                audio.addEventListener('ended', handleAudioEnded);
            }
        });
    });

    // Hàm xử lý sự kiện khi audio kết thúc
    function handleAudioEnded() {
        // Thay đổi biểu tượng của bài hát trước khi phát bài tiếp theo
        if (currentButton) {
            currentButton.className = currentButton.className.replace('bi-pause-circle-fill', 'bi-play-circle-fill'); // Đổi biểu tượng thành play
        }

        // Tìm bài hát tiếp theo
        const songItem = currentButton.closest('.songItem') || currentButton.closest('.ItemSong'); // Tìm phần tử chứa bài hát hiện tại
        const nextSongItem = songItem.nextElementSibling; // Lấy phần tử kế tiếp
        if (nextSongItem) {
            const nextAudio = nextSongItem.querySelector('audio'); // Tìm audio trong phần tử kế tiếp
            const nextButton = nextSongItem.querySelector('.playListPlay, .play-circle'); // Tìm nút play trong phần tử kế tiếp
            if (nextAudio) {
                // Phát bài tiếp theo
                nextAudio.play();
                nextButton.className = nextButton.className.replace('bi-play-circle-fill', 'bi-pause-circle-fill'); // Đổi biểu tượng thành pause
                currentAudio = nextAudio; // Cập nhật audio hiện tại
                currentButton = nextButton; // Cập nhật nút hiện tại

                // Thêm sự kiện kết thúc cho bài tiếp theo
                nextAudio.addEventListener('ended', handleAudioEnded);
            }
        } else {
            // Nếu không còn bài nào, đặt currentAudio và currentButton về null
            currentAudio = null;
            currentButton = null;
        }
    }  


    let leftScroll = document.getElementById('leftScroll');
    let rightScroll = document.getElementById('rightScroll');
    let pop_song = document.getElementsByClassName('pop_song')[0];

    leftScroll.addEventListener('click', () => {
        pop_song.scrollLeft -= 64;
    })
    rightScroll.addEventListener('click', () => {
        pop_song.scrollLeft += 64;
    })

    let left_scrolls = document.getElementById('left_scrolls');
    let right_scrolls = document.getElementById('right_scrolls');
    let artistContainer = document.getElementsByClassName('artistContainer')[0];

    left_scrolls.addEventListener('click', () => {
        artistContainer.scrollLeft -= 44;
    })
    right_scrolls.addEventListener('click', () => {
        artistContainer.scrollLeft += 44;
    })
});
