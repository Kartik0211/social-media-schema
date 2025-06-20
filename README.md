# social-media-schema
This project implements the backend schema for a social media platform using **MySQL 8.0+**. It covers all core features (users, posts, likes, follows, messaging) and bonus features like hashtags, blocking, group chats, and audit logs.

## 🔧 Features Implemented

### ✅ Core Features
- **User Management**: usernames, email, password hash, bio, profile picture
- **Posts**: text, image support, timestamps
- **Follows**: follow/unfollow other users
- **Likes**: like/unlike posts
- **Comments**: nested/threaded comments
- **Messages**: private direct messages
- **Notifications**: follow, like, comment, message notifications

### ⭐ Bonus Features
- **Hashtags**: tag and filter posts by hashtags
- **User Blocking**: prevent interaction between blocked users
- **Post Privacy**: support for `public` / `private` posts
- **Group Chats**: group messages, group members
- **Audit Logs**: track INSERT / UPDATE / DELETE actions

---

## 📂 Files Included

- `social_media.sql` – Full SQL schema, sample data, and demo queries
