CREATE database MusicWeb

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),                -- ID của người dùng, tự động tăng
    Username NVARCHAR(50) NOT NULL UNIQUE,               -- Tên đăng nhập, phải là duy nhất
    Email NVARCHAR(100) NOT NULL UNIQUE,                 -- Email người dùng, phải là duy nhất
    PasswordHash NVARCHAR(255) NOT NULL,				 -- Mật khẩu được mã hóa
	Salt NVARCHAR(50) NOT NULL,
    DisplayName NVARCHAR(100),                           -- Tên hiển thị
    DateOfBirth DATE,                                    -- Ngày sinh
    Gender NVARCHAR(10),                                 -- Giới tính
    Country NVARCHAR(50),                                -- Quốc gia
    Avatar NVARCHAR(255),                                -- Đường dẫn ảnh đại diện người dùng
    CreatedAt DATETIME DEFAULT GETDATE(),                 -- Ngày tạo tài khoản
	LastLogin DATETIME									 -- Thời gian đăng nhập cuối cùng
);
GO

CREATE TABLE Artists (
    ArtistID INT PRIMARY KEY IDENTITY(1,1),              -- ID nghệ sĩ, tự động tăng
    ArtistName NVARCHAR(100) NOT NULL,                   -- Tên nghệ sĩ
    Bio NVARCHAR(MAX),                                   -- Tiểu sử nghệ sĩ
    Country NVARCHAR(50),                                -- Quốc gia
    Avatar NVARCHAR(255),                                -- Đường dẫn ảnh đại diện nghệ sĩ
    CreatedAt DATETIME DEFAULT GETDATE(),                 -- Ngày tạo nghệ sĩ
	FollowerCount BIGINT DEFAULT 0                    -- Số lượng người theo dõi
);
GO

CREATE TABLE Albums (
    AlbumID INT PRIMARY KEY IDENTITY(1,1),               -- ID album, tự động tăng
    AlbumTitle NVARCHAR(100) NOT NULL,                   -- Tên album
    ArtistID INT FOREIGN KEY REFERENCES Artists(ArtistID) ON DELETE CASCADE, -- Nghệ sĩ của album
    ReleaseDate DATE,                                    -- Ngày phát hành album
    CoverImage NVARCHAR(255),                            -- Đường dẫn ảnh bìa album
    CreatedAt DATETIME DEFAULT GETDATE()                 -- Ngày tạo album
);
GO


CREATE TABLE Genres (
    GenreID INT PRIMARY KEY IDENTITY(1,1),               -- ID thể loại, tự động tăng
    GenreName NVARCHAR(50) NOT NULL                      -- Tên thể loại (Pop, Rock, Jazz...)
);
GO

CREATE TABLE Songs (
    SongID INT PRIMARY KEY IDENTITY(1,1),                -- ID bài hát, tự động tăng
    SongTitle NVARCHAR(100) NOT NULL,                    -- Tiêu đề bài hát
    AlbumID INT FOREIGN KEY REFERENCES Albums(AlbumID) ON DELETE CASCADE, -- Album chứa bài hát
    ArtistID INT FOREIGN KEY REFERENCES Artists(ArtistID), -- Nghệ sĩ
	GenreID INT FOREIGN KEY REFERENCES Genres(GenreID),      -- Ràng buộc khóa ngoại với bảng Genres
    Duration INT,                                        -- Thời lượng bài hát (giây)
    AudioFile NVARCHAR(255),							 -- Đường dẫn file âm thanh
	ImageURL NVARCHAR(255), 
	LikeCount INT DEFAULT 0,							 -- Số lượt thích bài hát
    ViewCount INT DEFAULT 0,                             -- Số lượt nghe bài hát
    ShareCount INT DEFAULT 0,                            -- Số lượt chia sẻ bài hát
    CreatedAt DATETIME DEFAULT GETDATE()                 -- Ngày tạo bài hát
);
GO

CREATE TABLE SongGenres (
    SongID INT FOREIGN KEY REFERENCES Songs(SongID) ON DELETE CASCADE,   -- ID bài hát
    GenreID INT FOREIGN KEY REFERENCES Genres(GenreID) ON DELETE CASCADE,-- ID thể loại
    PRIMARY KEY (SongID, GenreID)                                        -- Khóa chính là kết hợp
);
GO

CREATE TABLE Playlists (
    PlaylistID INT PRIMARY KEY IDENTITY(1,1),            -- ID danh sách phát, tự động tăng
    UserID INT FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE, -- ID người dùng, liên kết với Users
    PlaylistTitle NVARCHAR(100) NOT NULL,                -- Tiêu đề danh sách phát
    Description NVARCHAR(255),                           -- Mô tả danh sách phát
    CreatedAt DATETIME DEFAULT GETDATE()                 -- Ngày tạo danh sách phát
);
GO

CREATE TABLE PlaylistSongs (
    PlaylistID INT FOREIGN KEY REFERENCES Playlists(PlaylistID) ON DELETE CASCADE, -- ID danh sách phát
    SongID INT FOREIGN KEY REFERENCES Songs(SongID) ON DELETE CASCADE, -- ID bài hát
    AddedAt DATETIME DEFAULT GETDATE(),            -- Ngày thêm bài hát vào danh sách phát
    PRIMARY KEY (PlaylistID, SongID)               -- Khóa chính là sự kết hợp giữa PlaylistID và SongID
);
GO

CREATE TABLE ListeningHistory (
    HistoryID INT PRIMARY KEY IDENTITY(1,1),        -- ID lịch sử nghe nhạc, tự động tăng
    UserID INT FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE, -- ID người dùng, liên kết với Users
    SongID INT FOREIGN KEY REFERENCES Songs(SongID) ON DELETE CASCADE, -- ID bài hát, liên kết với Songs
    PlayedAt DATETIME DEFAULT GETDATE()             -- Thời gian người dùng nghe bài hát
);
GO

CREATE TABLE Lyrics (
    LyricID INT PRIMARY KEY IDENTITY(1,1),                  -- ID lời bài hát, tự động tăng
    SongID INT FOREIGN KEY REFERENCES Songs(SongID) ON DELETE CASCADE, -- Bài hát
    LyricText NVARCHAR(MAX) NOT NULL                        -- Nội dung lời bài hát
);
GO

CREATE TABLE SongLikes (
    LikeID INT PRIMARY KEY IDENTITY(1,1),                   -- ID lượt thích, tự động tăng
    UserID INT FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE, -- Người dùng thích bài hát
    SongID INT FOREIGN KEY REFERENCES Songs(SongID) ON DELETE CASCADE, -- Bài hát được thích
    LikedAt DATETIME DEFAULT GETDATE()                       -- Thời gian thích bài hát
);
GO

CREATE TABLE Comments (
    CommentID INT PRIMARY KEY IDENTITY(1,1),        -- ID bình luận, tự động tăng
    UserID INT FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE, -- ID người dùng, liên kết với Users
    SongID INT FOREIGN KEY REFERENCES Songs(SongID) ON DELETE CASCADE, -- ID bài hát, liên kết với Songs
    CommentText NVARCHAR(255),                      -- Nội dung bình luận
    CommentedAt DATETIME DEFAULT GETDATE()          -- Thời gian bình luận
);
GO

CREATE TABLE Followers (
    FollowerID INT PRIMARY KEY IDENTITY(1,1),     -- ID của mối quan hệ theo dõi (tự động tăng)
    UserID INT NOT NULL,                           -- ID người dùng (khóa ngoại)
    ArtistID INT NOT NULL,                         -- ID nghệ sĩ (khóa ngoại)
    FollowedAt DATETIME DEFAULT GETDATE(),        -- Thời gian theo dõi
    FOREIGN KEY (UserID) REFERENCES Users(UserID), -- Ràng buộc khóa ngoại với bảng Users
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID) -- Ràng buộc khóa ngoại với bảng Artists
);
GO

CREATE TABLE Ratings (
    RatingID INT PRIMARY KEY IDENTITY(1,1),               -- ID đánh giá, tự động tăng
    UserID INT FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE, -- Người đánh giá
    SongID INT FOREIGN KEY REFERENCES Songs(SongID) ON DELETE CASCADE, -- Bài hát được đánh giá
    Rating INT CHECK (Rating BETWEEN 1 AND 5),            -- Đánh giá từ 1 đến 5
    RatedAt DATETIME DEFAULT GETDATE()                    -- Thời gian đánh giá
);
GO

CREATE TABLE Subscriptions (
    SubscriptionID INT PRIMARY KEY IDENTITY(1,1),           -- ID đăng ký
    UserID INT FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE, -- Người dùng
    PlanName NVARCHAR(100) NOT NULL,                        -- Tên gói (Free, Premium...)
    Price DECIMAL(10, 2) NOT NULL,                          -- Giá gói
    StartDate DATETIME DEFAULT GETDATE(),                   -- Ngày bắt đầu
    EndDate DATETIME,                                       -- Ngày kết thúc
    IsActive BIT DEFAULT 1                                  -- Trạng thái kích hoạt (1 là còn hoạt động)
);
GO
