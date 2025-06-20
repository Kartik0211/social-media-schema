-- Create the social media database
CREATE DATABASE IF NOT EXISTS social_media;
USE social_media;

-- USERS TABLE
-- Stores user account information and profile data
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,                           -- Unique user ID
    username VARCHAR(50) NOT NULL UNIQUE,                        -- Unique username
    email VARCHAR(100) NOT NULL UNIQUE,                          -- Unique email address
    password_hash VARCHAR(255) NOT NULL,                         -- Hashed password
    bio TEXT,                                                    -- User bio/about section
    profile_image VARCHAR(255),                                  -- Path or URL to profile picture
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,              -- Time of account creation
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- Last update time
);


-- POSTS TABLE

-- Stores posts made by users (text + optional image)
CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,                           -- Unique post ID
    user_id INT NOT NULL,                                        -- Author of the post
    content TEXT,                                                -- Text content of the post
    image_url VARCHAR(255),                                      -- Image attached to the post
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,              -- Time of post creation
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE -- Delete all posts if user is deleted
);


-- FOLLOWS TABLE

-- Maps followers to the users they follow
CREATE TABLE follows (
    follower_id INT NOT NULL,                                    -- The user who is following
    following_id INT NOT NULL,                                   -- The user being followed
    followed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,             -- When the follow happened
    PRIMARY KEY (follower_id, following_id),                     -- Prevent duplicate follows
    FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (following_id) REFERENCES users(id) ON DELETE CASCADE
);


-- LIKES TABLE

-- Records likes on posts by users
CREATE TABLE likes (
    user_id INT NOT NULL,                                        -- Who liked the post
    post_id INT NOT NULL,                                        -- Post that was liked
    liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                -- When the like happened
    PRIMARY KEY (user_id, post_id),                              -- Only one like per user per post
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
);


-- COMMENTS TABLE

-- Stores comments on posts and threaded replies
CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,                           -- Unique comment ID
    post_id INT NOT NULL,                                        -- The post this comment belongs to
    user_id INT NOT NULL,                                        -- The user who made the comment
    content TEXT NOT NULL,                                       -- Text of the comment
    parent_comment_id INT DEFAULT NULL,                          -- For replies (null = top-level)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,              -- When comment was made
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_comment_id) REFERENCES comments(id) ON DELETE CASCADE
);


-- MESSAGES TABLE

-- Private direct messages between users
CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,                           -- Unique message ID
    sender_id INT NOT NULL,                                      -- User sending the message
    receiver_id INT NOT NULL,                                    -- User receiving the message
    message_text TEXT NOT NULL,                                  -- Content of the message
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                 -- Timestamp of sending
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 
-- NOTIFICATIONS TABLE

-- Stores notification events (likes, follows, messages, comments)
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,                           -- Unique notification ID
    user_id INT NOT NULL,                                        -- The user receiving the notification
    type ENUM('follow', 'like', 'comment', 'message') NOT NULL,  -- Type of event
    related_user_id INT,                                         -- The user who triggered the event
    post_id INT,                                                 -- Post involved (optional)
    message TEXT,                                                -- Notification message
    is_read BOOLEAN DEFAULT FALSE,                               -- Whether the notification has been read
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,              -- When it was created
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (related_user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE SET NULL
);
INSERT INTO users (username, email, password_hash, bio, profile_image)
VALUES
('kartik_01', 'kartik@example.com', 'hashed_pwd1', 'Loves tech and code!', 'profile1.jpg'),
('john_doe', 'john@example.com', 'hashed_pwd2', 'Foodie and traveler', 'profile2.jpg'),
('jane_smith', 'jane@example.com', 'hashed_pwd3', 'Engineer and writer', 'profile3.jpg'),
('rahul_r', 'rahul@example.com', 'hashed_pwd4', 'Gamer. Coder. Dreamer.', 'profile4.jpg'),
('priya_k', 'priya@example.com', 'hashed_pwd5', 'Music is my escape', 'profile5.jpg'),
('ananya_m', 'ananya@example.com', 'hashed_pwd6', 'Photographer in love with nature.', 'profile6.jpg'),
('dev_x', 'dev@example.com', 'hashed_pwd7', 'Full-stack dev & coffee addict.', 'profile7.jpg'),
('megha_r', 'megha@example.com', 'hashed_pwd8', 'Digital artist. Introvert.', 'profile8.jpg'),
('sahil_t', 'sahil@example.com', 'hashed_pwd9', 'I lift. I code. I repeat.', 'profile9.jpg'),
('isha_b', 'isha@example.com', 'hashed_pwd10', 'Bookworm + Movie Buff 📚🎬', 'profile10.jpg');

INSERT INTO posts (user_id, content, image_url)
VALUES
(1, 'Starting my day with some SQL practice!', NULL),
(2, 'Sunset from the hills was just magical.', 'sunset.jpg'),
(3, 'Reading a new book on database design.', NULL),
(4, 'Finally beat the last level of my game!', NULL),
(5, 'Just shared my new music playlist 🎵', 'music.jpg'),
(6, 'Clicked this in the forest today!', 'nature1.jpg'),
(7, 'Dark theme or light theme for coding?', NULL),
(8, 'New digital art: The Lonely Moon.', 'moon_art.jpg'),
(9, 'Post-gym coffee hits different ☕', 'coffee_gym.jpg'),
(10, 'Just finished a Marvel movie marathon!', NULL),

(1, 'Cleaned my GitHub profile. Feels good!', NULL),
(2, 'Traveling to Manali tomorrow!', 'mountains.jpg'),
(3, 'Quick tip: Normalize your database!', NULL),
(4, 'Best gaming headset under 5k?', NULL),
(5, 'Feeling musical today 🎧', NULL),
(6, 'Sunrise was breathtaking.', 'sunrise.jpg'),
(7, 'Trying out new VS Code extensions.', NULL),
(8, 'Character concept: Cyber Elf', 'concept.jpg'),
(9, 'Biceps finally looking decent 💪', NULL),
(10, 'Weekend = movies + popcorn', 'popcorn.jpg'),

(1, 'Working on a new portfolio design.', NULL),
(2, 'Road trip memories!', 'roadtrip.jpg'),
(3, 'Learning about SQL JOINs today.', NULL),
(4, 'Any RPG recommendations?', NULL),
(5, 'Found an old piano tune I made.', NULL),
(6, 'Trekking adventure: Day 2!', 'trek.jpg'),
(7, 'AI is fun to play with!', NULL),
(8, 'Coloring this sketch today.', 'wip_sketch.jpg'),
(9, 'Deadlifts: 110 kg today!', 'weights.jpg'),
(10, 'Spotted a rare bird this morning.', 'bird.jpg');

INSERT INTO follows (follower_id, following_id)
VALUES
(1, 2), (1, 3), (1, 4),
(2, 1), (2, 5),
(3, 2), (3, 6),
(4, 1), (4, 5), (4, 6),
(5, 1), (5, 6),
(6, 3), (6, 7),
(7, 2), (7, 5),
(8, 4),
(9, 1), (9, 2),
(10, 3), (10, 4);

INSERT INTO likes (user_id, post_id)
VALUES
(1, 2), (1, 5), (1, 8),
(2, 1), (2, 3), (2, 9),
(3, 4), (3, 6), (3, 10),
(4, 1), (4, 2),
(5, 2), (5, 3), (5, 6),
(6, 9), (6, 7),
(7, 8), (7, 4),
(8, 2), (8, 10),
(9, 1), (9, 3),
(10, 5), (10, 7);

INSERT INTO comments (post_id, user_id, content, parent_comment_id)
VALUES
(1, 2, 'Nice post!', NULL),
(1, 3, 'Agreed!', 1),
(2, 1, 'Love this!', NULL),
(3, 4, 'Very useful.', NULL),
(3, 5, 'Thanks for sharing!', NULL),
(4, 6, 'Can relate!', NULL),
(5, 2, 'Wow, amazing shot.', NULL),
(5, 3, 'Where did you take it?', 7),
(6, 4, 'Loved the colors!', NULL);

INSERT INTO messages (sender_id, receiver_id, message_text)
VALUES
(1, 2, 'Hey, what’s up?'),
(2, 1, 'All good! You?'),
(3, 4, 'Can you review my post?'),
(4, 3, 'Sure! Send me the link.'),
(5, 6, 'Let’s collaborate on a post.'),
(6, 5, 'Yes! Let’s do it.'),
(7, 8, 'Your artwork is inspiring.'),
(8, 7, 'Thanks so much!'),
(9, 10, 'Movie recommendations?'),
(10, 9, 'Try Dune!');
INSERT INTO notifications (user_id, type, related_user_id, post_id, message)
VALUES
(2, 'follow', 1, NULL, 'kartik_01 started following you'),
(3, 'like', 1, 2, 'kartik_01 liked your post'),
(4, 'comment', 2, 1, 'john_doe commented on your post'),
(5, 'message', 1, NULL, 'You received a message from kartik_01'),
(6, 'like', 3, 6, 'jane_smith liked your post'),
(1, 'follow', 4, NULL, 'rahul_r followed you'),
(7, 'message', 8, NULL, 'megha_r sent you a message'),
(10, 'comment', 9, 3, 'sahil_t replied to your comment');

-- User Feed: Posts by followed users
SELECT 
    posts.id AS post_id,
    posts.content,
    posts.image_url,
    posts.created_at,
    users.username AS author
FROM posts
JOIN users ON posts.user_id = users.id
JOIN follows ON follows.following_id = users.id
WHERE follows.follower_id = 1
ORDER BY posts.created_at DESC;

-- Direct message history between two users
SELECT 
    m.id,
    sender.username AS sender,
    receiver.username AS receiver,
    m.message_text,
    m.sent_at
FROM messages m
JOIN users sender ON m.sender_id = sender.id
JOIN users receiver ON m.receiver_id = receiver.id
WHERE (m.sender_id = 1 AND m.receiver_id = 2)
   OR (m.sender_id = 2 AND m.receiver_id = 1)
ORDER BY m.sent_at ASC;

-- List followers of a specific user
SELECT 
    u.username AS follower_name,
    f.followed_at
FROM follows f
JOIN users u ON f.follower_id = u.id
WHERE f.following_id = 3;

-- List users followed by a specific user
SELECT 
    u.username AS following_name,
    f.followed_at
FROM follows f
JOIN users u ON f.following_id = u.id
WHERE f.follower_id = 3;

-- List of users who liked a specific post
SELECT 
    u.username,
    l.liked_at
FROM likes l
JOIN users u ON l.user_id = u.id
WHERE l.post_id = 5;

-- Comments and threaded replies on a post
SELECT 
    c.id,
    u.username AS commenter,
    c.content,
    c.parent_comment_id,
    c.created_at
FROM comments c
JOIN users u ON c.user_id = u.id
WHERE c.post_id = 6
ORDER BY c.created_at;

-- Unread notifications
SELECT 
    n.type,
    ru.username AS triggered_by,
    n.message,
    n.post_id,
    n.created_at
FROM notifications n
LEFT JOIN users ru ON n.related_user_id = ru.id
WHERE n.user_id = 1 AND n.is_read = FALSE
ORDER BY n.created_at DESC;

-- User statistics: posts, followers, likes

SELECT 
    u.username,
    COUNT(DISTINCT p.id) AS total_posts,
    COUNT(DISTINCT f1.follower_id) AS total_followers,
    COUNT(DISTINCT l.user_id) AS total_likes_received
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN follows f1 ON u.id = f1.following_id
LEFT JOIN likes l ON p.id = l.post_id
GROUP BY u.id;

-- Table to store unique hashtags
CREATE TABLE hashtags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tag VARCHAR(50) NOT NULL UNIQUE
);

-- Junction table to link hashtags with posts (many-to-many)
CREATE TABLE post_hashtags (
    post_id INT NOT NULL,
    hashtag_id INT NOT NULL,
    PRIMARY KEY (post_id, hashtag_id),
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (hashtag_id) REFERENCES hashtags(id) ON DELETE CASCADE
);


-- Get all posts tagged with '#coding'
SELECT p.*
FROM posts p
JOIN post_hashtags ph ON p.id = ph.post_id
JOIN hashtags h ON ph.hashtag_id = h.id
WHERE h.tag = 'coding';

-- Store blocked relationships
CREATE TABLE blocked_users (
    blocker_id INT NOT NULL,
    blocked_id INT NOT NULL,
    blocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (blocker_id, blocked_id),
    FOREIGN KEY (blocker_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (blocked_id) REFERENCES users(id) ON DELETE CASCADE
);
SELECT * FROM blocked_users
WHERE blocker_id = 1 AND blocked_id = 2;

-- Table to define chat groups
CREATE TABLE chat_groups (
    id INT AUTO_INCREMENT PRIMARY KEY,
    group_name VARCHAR(100),
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE
);

-- Junction table to add users to groups
CREATE TABLE group_members (
    group_id INT NOT NULL,
    user_id INT NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (group_id, user_id),
    FOREIGN KEY (group_id) REFERENCES chat_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Messages sent within a group
CREATE TABLE group_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    group_id INT NOT NULL,
    sender_id INT NOT NULL,
    message_text TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (group_id) REFERENCES chat_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE
);

-- General audit table to log key actions
CREATE TABLE audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,                        -- Who performed the action
    table_name VARCHAR(50),            -- Which table was affected
    action ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    record_id INT,                     -- Affected row ID (optional)
    details TEXT,                      -- JSON/text of changes
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

INSERT INTO hashtags (tag)
VALUES ('coding'), ('fitness'), ('art'), ('nature'), ('travel');

INSERT INTO post_hashtags (post_id, hashtag_id)
VALUES
(1, 1),   -- Post 1 tagged with #coding
(2, 5),   -- Post 2 tagged with #travel
(3, 1),   -- Post 3 tagged with #coding
(6, 4),   -- Post 6 tagged with #nature
(8, 3),   -- Post 8 tagged with #art
(9, 2),   -- Post 9 tagged with #fitness
(22, 5);  -- Post 22 tagged with #travel

INSERT INTO blocked_users (blocker_id, blocked_id)
VALUES
(1, 2),   -- User 1 blocked user 2
(3, 4),   -- User 3 blocked user 4
(5, 6);   -- User 5 blocked user 6

INSERT INTO chat_groups (group_name, created_by)
VALUES 
('Dev Talk', 1),
('Art Squad', 3),
('Fitness Crew', 5);

INSERT INTO group_members (group_id, user_id)
VALUES
(1, 1), (1, 2), (1, 3),  -- Dev Talk: users 1,2,3
(2, 3), (2, 8), (2, 10), -- Art Squad: users 3,8,10
(3, 5), (3, 9), (3, 6);  -- Fitness Crew: users 5,6,9

INSERT INTO group_messages (group_id, sender_id, message_text)
VALUES
(1, 1, 'Welcome to the Dev Talk group!'),
(1, 2, 'Thanks! Excited to join.'),
(2, 3, 'Just posted new artwork.'),
(3, 5, 'Workout challenge starts today 💪'),
(3, 9, 'I’m in! Let’s do it.');

INSERT INTO audit_logs (user_id, table_name, action, record_id, details)
VALUES
(1, 'posts', 'INSERT', 31, 'User 1 added a new post'),
(2, 'likes', 'DELETE', NULL, 'User 2 unliked post 3'),
(3, 'comments', 'UPDATE', 5, 'User 3 edited their comment'),
(5, 'users', 'UPDATE', 5, 'User 5 changed profile picture');

-- queries
-- Show all posts tagged with #coding
SELECT 
    p.id AS post_id,
    p.content,
    u.username AS author,
    h.tag
FROM posts p
JOIN post_hashtags ph ON p.id = ph.post_id
JOIN hashtags h ON ph.hashtag_id = h.id
JOIN users u ON p.user_id = u.id
WHERE h.tag = 'coding';

SELECT * FROM blocked_users
WHERE blocker_id = 1 AND blocked_id = 2;
-- If this returns a row, block communication.


-- Show all messages in group id = 1 ("Dev Talk")
SELECT 
    gm.id,
    cg.group_name,
    u.username AS sender,
    gm.message_text,
    gm.sent_at
FROM group_messages gm
JOIN users u ON gm.sender_id = u.id
JOIN chat_groups cg ON gm.group_id = cg.id
WHERE gm.group_id = 1
ORDER BY gm.sent_at ASC;

 -- Admin Query to Review All Recent Activity
SELECT 'post' AS type, id, user_id, created_at AS activity_time FROM posts
UNION
SELECT 'comment', id, user_id, created_at FROM comments
UNION
SELECT 'message', id, sender_id, sent_at FROM messages
ORDER BY activity_time DESC
LIMIT 20;

