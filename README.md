# SkillSwap

# SkillSwap 🎓

### Learn. Teach. Swap.

**SkillSwap** adalah aplikasi mobile berbasis **peer-to-peer skill exchange** yang dirancang untuk membantu mahasiswa menemukan teman belajar berdasarkan kemampuan yang mereka miliki dan skill yang ingin mereka pelajari.

Berbeda dengan platform kursus pada umumnya, SkillSwap tidak berfokus pada transaksi jual beli kursus. Konsep utama aplikasi adalah **pertukaran pengetahuan antar pengguna**.

Pengguna dapat:

* Mengajarkan skill yang mereka kuasai.
* Mencari skill yang ingin mereka pelajari.
* Menemukan pengguna dengan skill yang sesuai.
* Mengirim permintaan SkillSwap.
* Melakukan komunikasi melalui chat.
* Menjadwalkan sesi belajar.
* Memberikan rating dan review.
* Mendapatkan XP dan achievement.

---

## 📱 Preview

> **SkillSwap**
> *Learn. Teach. Swap.*

Aplikasi dirancang dengan konsep UI modern, clean, minimalis, dan student-oriented.

Halaman utama aplikasi meliputi:

* Splash Screen
* Login
* Register
* Onboarding
* Home
* Discover
* User Profile
* SkillSwap Request
* Chat
* Session
* Learning Progress
* Notification
* Profile

---

# 🎯 Latar Belakang

Mahasiswa memiliki berbagai kemampuan yang berbeda. Ada mahasiswa yang menguasai programming, desain, editing, bahasa, public speaking, atau kemampuan lainnya.

Di sisi lain, mahasiswa lain mungkin membutuhkan kemampuan tersebut tetapi tidak memiliki sumber belajar atau mentor yang mudah dijangkau.

SkillSwap hadir untuk mempertemukan kedua kebutuhan tersebut.

Contohnya:

**Gabriel**

> Can Teach:
>
> * UI/UX
> * HTML/CSS
>
> Want to Learn:
>
> * Python
> * Data Science

**Andi**

> Can Teach:
>
> * Python
> * Data Science
>
> Want to Learn:
>
> * UI/UX

SkillSwap dapat menemukan keduanya sebagai potential match.

### 🎯 98% SkillSwap Match

Gabriel dapat belajar Python dari Andi, sementara Andi dapat belajar UI/UX dari Gabriel.

Dengan konsep tersebut, proses belajar menjadi **dua arah dan saling menguntungkan**.

---

# 🚀 Tujuan Project

Tujuan utama pengembangan SkillSwap adalah:

1. Mempermudah mahasiswa menemukan teman belajar.
2. Memfasilitasi pertukaran skill antar mahasiswa.
3. Membangun komunitas belajar berbasis peer-to-peer.
4. Membantu mahasiswa mengembangkan kemampuan di luar perkuliahan.
5. Memberikan pengalaman belajar yang lebih sosial dan interaktif.
6. Mengurangi ketergantungan terhadap pembelajaran berbayar untuk skill dasar.

---

# ✨ Fitur Utama

## 1. Authentication 🔐

Pengguna dapat:

* Register akun.
* Login.
* Logout.
* Mengelola akun.

Data pengguna disimpan secara aman menggunakan sistem authentication.

---

## 2. User Profile 👤

Setiap pengguna memiliki profile yang berisi:

* Nama
* Foto profil
* Universitas
* Program studi
* Tahun angkatan
* Rating
* Level
* XP
* Jumlah session
* Skill yang dapat diajarkan
* Skill yang ingin dipelajari
* Availability
* Mode pembelajaran

Contoh:

```text
Gabriel
Informatics Student

⭐ 4.8 Rating
🏆 Level 8
🔥 12 Sessions

CAN TEACH
🎨 UI/UX
💻 HTML/CSS

WANT TO LEARN
🐍 Python
📊 Data Science
```

---

# 3. Skill Management 🧠

Pengguna dapat menentukan dua jenis skill:

### I Can Teach

Skill yang dikuasai dan dapat diajarkan.

Contoh:

* Python
* UI/UX
* Figma
* Photoshop
* Video Editing
* Public Speaking

### I Want to Learn

Skill yang ingin dipelajari.

Contoh:

* Data Science
* Java
* Photography
* English
* Marketing

---

# 4. Skill Discovery 🔎

Pengguna dapat mencari skill yang tersedia di dalam komunitas.

Kategori skill:

* Programming
* Design
* Business
* Academic
* Language
* Creative
* Marketing
* Productivity

Pengguna juga dapat menggunakan filter:

* Skill level
* Rating
* Online / Offline
* Availability
* University

---

# 5. Smart Matching 🎯

Salah satu fitur utama SkillSwap adalah sistem pencocokan pengguna.

Sistem menghitung tingkat kecocokan berdasarkan:

* Skill yang ingin dipelajari.
* Skill yang dapat diajarkan.
* Skill yang ingin dipelajari oleh pengguna lain.
* Skill yang dapat diajarkan oleh pengguna lain.
* Kesamaan jadwal.
* Mode pembelajaran.
* Rating.
* Komunitas/universitas.

Contoh:

```text
Skill Match          50%
Reverse Skill Match 20%
Schedule Match      15%
Learning Mode       10%
Rating               5%
-------------------------
Total               100%
```

Hasil ditampilkan sebagai:

```text
🎯 98% MATCH
```

---

# 6. SkillSwap Request 🤝

Pengguna dapat mengirim permintaan pertukaran skill.

Contoh:

```text
SkillSwap Request

I want to learn:
🐍 Python

I can teach:
🎨 UI/UX

Message:

"Hi! I would like to learn Python
from you. In exchange, I can help
you learn UI/UX."
```

Penerima dapat:

* Accept
* Decline

---

# 7. Chat 💬

Setelah request diterima, kedua pengguna dapat berkomunikasi melalui chat.

Fitur:

* Text message
* Timestamp
* Read status
* Session scheduling

Chat digunakan untuk menentukan waktu dan metode belajar.

---

# 8. Session Scheduling 📅

Pengguna dapat membuat sesi belajar.

Informasi session:

* Skill
* Teacher
* Learner
* Date
* Start time
* End time
* Mode
* Meeting link
* Status

Contoh:

```text
Python Basic

Teacher:
Andi Pratama

Learner:
Gabriel

Date:
19 September 2026

Time:
14:00 - 15:30

Mode:
Online

Status:
Upcoming
```

Status session:

```text
Upcoming
    ↓
Ongoing
    ↓
Completed
```

---

# 9. Learning Progress 📚

Pengguna dapat melihat progress skill yang sedang dipelajari.

Contoh:

```text
Python

Beginner

████████████░░░░░░ 60%

✓ Variables
✓ Data Types
✓ Operators
✓ Conditional
○ Loops
○ Functions
○ OOP
```

Progress dapat diperbarui berdasarkan session dan aktivitas belajar.

---

# 10. Rating & Review ⭐

Setelah session selesai, pengguna dapat memberikan rating.

Rating:

```text
⭐ ⭐ ⭐ ⭐ ⭐
```

Kategori review:

* Good explanation
* Friendly
* On time
* Helpful
* Easy to understand

Pengguna juga dapat menulis komentar.

Rating akan digunakan sebagai salah satu parameter dalam sistem matching.

---

# 11. Gamification 🎮

Untuk meningkatkan engagement, SkillSwap menggunakan sistem XP.

Contoh:

| Aktivitas                 |  XP |
| ------------------------- | --: |
| Complete Profile          | +20 |
| Complete Learning Session | +50 |
| Teach Someone             | +50 |
| Give Review               | +10 |
| Receive 5-Star Rating     | +20 |

Level:

```text
Level 1  → Beginner
Level 5  → Contributor
Level 10 → Skill Mentor
Level 20 → Skill Master
```

---

# 12. Achievement 🏆

Pengguna dapat memperoleh achievement.

Contoh:

### 🏆 First Swap

Melakukan SkillSwap pertama.

### 🎓 Skill Mentor

Mengajar 10 session.

### 🔥 Learning Streak

Belajar selama 7 hari berturut-turut.

### ⭐ Top Mentor

Mendapatkan rating tinggi.

### 🤝 Community Helper

Membantu 25 mahasiswa.

Achievement yang belum diperoleh ditampilkan dalam kondisi locked.

---

# 13. Notification 🔔

Aplikasi memberikan notifikasi untuk aktivitas penting.

Contoh:

```text
🔔 New Match

You have a 95% SkillSwap match with Kevin.
```

```text
🔔 New Request

Sarah wants to SkillSwap with you.
```

```text
🔔 Session Reminder

Your Python session starts in 30 minutes.
```

```text
🔔 Review Reminder

Don't forget to review your last session.
```

---

# 14. Online & Offline Learning 🌐

SkillSwap mendukung dua metode pembelajaran.

### Online

Contoh:

* Google Meet
* Zoom
* Discord

### Offline

Pertemuan dilakukan di tempat umum seperti:

* Kampus
* Perpustakaan
* Cafe
* Study space

Pengguna dapat memilih:

```text
Online
Offline
Both
```

---

# 🧭 User Flow

Alur utama aplikasi:

```text
Splash Screen
      ↓
Login / Register
      ↓
Onboarding
      ↓
Select Skills
      ↓
Set Availability
      ↓
Home
      ↓
Discover
      ↓
Find Match
      ↓
View Profile
      ↓
SkillSwap Request
      ↓
Accept
      ↓
Chat
      ↓
Schedule Session
      ↓
Learning Session
      ↓
Complete Session
      ↓
Rating & Review
      ↓
XP & Progress
```

---

# 🏗️ Application Architecture

Secara umum aplikasi memiliki beberapa komponen:

```text
┌─────────────────────┐
│      Mobile App     │
│       Flutter       │
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│   Firebase Auth     │
│ Authentication      │
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│   Cloud Firestore   │
│      Database       │
└──────────┬──────────┘
           │
           ├───────────────┐
           ↓               ↓
┌────────────────┐ ┌─────────────────┐
│ Firebase       │ │ Firebase Cloud  │
│ Storage        │ │ Messaging       │
│ Profile Image  │ │ Notifications   │
└────────────────┘ └─────────────────┘
```

---

# 🗄️ Database Structure

## Users

```text
users
├── id
├── name
├── email
├── university
├── major
├── year
├── profile_picture
├── level
├── xp
├── rating
├── total_sessions
└── created_at
```

---

## Skills

```text
skills
├── id
├── name
├── category
└── description
```

---

## User Skills

```text
user_skills
├── id
├── user_id
├── skill_id
├── type
└── level
```

`type`:

```text
teach
learn
```

---

## SkillSwap Requests

```text
requests
├── id
├── sender_id
├── receiver_id
├── teach_skill
├── learn_skill
├── message
├── status
└── created_at
```

Status:

```text
pending
accepted
declined
cancelled
```

---

## Sessions

```text
sessions
├── id
├── teacher_id
├── learner_id
├── skill_id
├── date
├── start_time
├── end_time
├── mode
├── meeting_link
├── status
└── created_at
```

Status:

```text
upcoming
ongoing
completed
cancelled
```

---

## Messages

```text
messages
├── id
├── sender_id
├── receiver_id
├── message
├── timestamp
└── read_status
```

---

## Reviews

```text
reviews
├── id
├── reviewer_id
├── reviewed_user_id
├── session_id
├── rating
├── comment
└── created_at
```

---

## Notifications

```text
notifications
├── id
├── user_id
├── title
├── message
├── type
├── read_status
└── created_at
```

---

# 🛠️ Technology Stack

Project ini dapat dikembangkan menggunakan:

### Frontend

**Flutter**

* Dart
* Material Design
* Responsive UI

### Backend

**Firebase**

* Firebase Authentication
* Cloud Firestore
* Firebase Storage
* Firebase Cloud Messaging

### Development Tools

* Android Studio
* Visual Studio Code
* Git
* GitHub

---

# 📦 Installation

## 1. Clone Repository

```bash
git clone https://github.com/username/skillswap.git
```

Masuk ke folder project:

```bash
cd skillswap
```

---

## 2. Install Dependencies

```bash
flutter pub get
```

---

## 3. Firebase Configuration

Buat project baru pada Firebase Console.

Aktifkan:

* Authentication
* Cloud Firestore
* Firebase Storage
* Firebase Cloud Messaging

Kemudian hubungkan Firebase dengan aplikasi Flutter.

Jika menggunakan FlutterFire CLI:

```bash
flutterfire configure
```

---

## 4. Run Application

Jalankan emulator atau sambungkan perangkat Android.

Kemudian:

```bash
flutter run
```

---

# 📁 Project Structure

Contoh struktur project:

```text
lib/
│
├── main.dart
│
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
│
├── models/
│   ├── user_model.dart
│   ├── skill_model.dart
│   ├── session_model.dart
│   ├── request_model.dart
│   └── review_model.dart
│
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   ├── matching_service.dart
│   ├── notification_service.dart
│   └── storage_service.dart
│
├── screens/
│   ├── auth/
│   ├── onboarding/
│   ├── home/
│   ├── discover/
│   ├── chat/
│   ├── session/
│   └── profile/
│
├── widgets/
│   ├── skill_card.dart
│   ├── match_card.dart
│   ├── session_card.dart
│   ├── rating_widget.dart
│   └── custom_button.dart
│
└── routes/
    └── app_routes.dart
```

---

# 🎨 UI/UX Guidelines

SkillSwap menggunakan prinsip desain:

* Modern
* Clean
* Minimal
* Friendly
* Student-oriented
* Easy to navigate

Komponen yang digunakan:

* Rounded cards
* Skill chips
* Progress bars
* Rating stars
* Bottom navigation
* Floating action button jika diperlukan
* Consistent spacing
* Clear typography
* Empty states
* Loading states
* Error states

Hindari penggunaan terlalu banyak warna dan elemen dekoratif yang tidak memiliki fungsi.

---

# 🔐 Privacy & Safety

Karena SkillSwap mempertemukan pengguna, aspek keamanan perlu diperhatikan.

Fitur keamanan:

* Block user
* Report user
* Report inappropriate content
* Cancel session
* Rating system
* Community guidelines

Untuk pertemuan offline, pengguna disarankan bertemu di **tempat umum**.

Aplikasi tidak menampilkan alamat pribadi pengguna.

---

# 📊 Matching Algorithm

Versi awal menggunakan sistem scoring sederhana.

Contoh:

```text
Skill Match          50%
Reverse Skill Match 20%
Schedule Match      15%
Learning Mode       10%
Rating               5%
```

Formula:

```text
Match Score =
(Skill Match × 0.50)
+
(Reverse Match × 0.20)
+
(Schedule Match × 0.15)
+
(Mode Match × 0.10)
+
(Rating × 0.05)
```

Hasil akhir dikonversi menjadi persentase.

Contoh:

```text
Skill Match: 100
Reverse Match: 100
Schedule Match: 80
Mode Match: 100
Rating: 90

Final Score = 95.5%
```

Kemudian ditampilkan:

```text
🎯 96% Match
```

---

# 🎯 MVP Scope

Untuk versi pertama, fitur yang wajib dibuat adalah:

* [x] Authentication
* [x] User Profile
* [x] Skill Selection
* [x] Teach / Learn Skill
* [x] Skill Discovery
* [x] Matching
* [x] SkillSwap Request
* [x] Chat
* [x] Session Scheduling
* [x] Rating & Review

Fitur tambahan:

* [ ] XP
* [ ] Achievement
* [ ] Learning Progress
* [ ] Notification
* [ ] Leaderboard
* [ ] AI Recommendation
* [ ] Calendar Integration

---

# 🚀 Future Development

Pengembangan selanjutnya dapat mencakup:

### AI Skill Recommendation

AI menganalisis:

* Skill
* Riwayat belajar
* Session
* Rating
* Preferensi pengguna

Kemudian memberikan rekomendasi skill.

---

### Skill Assessment

Pengguna dapat mengikuti quiz untuk menentukan level skill.

Contoh:

```text
Python Assessment

Score: 78/100

Level:
Intermediate
```

---

### Personalized Learning Roadmap

Contoh:

```text
Python Learning Roadmap

1. Python Basic       ✓
2. Control Flow       ✓
3. Functions          →
4. OOP                ○
5. Data Processing    ○
6. Data Science       ○
```

---

### Leaderboard

Ranking berdasarkan:

* XP
* Session
* Teaching
* Rating
* Contribution

Contoh:

```text
🏆 SkillSwap Leaderboard

1. Andi       2,450 XP
2. Sarah      2,210 XP
3. Gabriel    1,980 XP
```

---

# 🌟 Unique Selling Point

SkillSwap memiliki konsep yang berbeda dari aplikasi belajar biasa.

Aplikasi tidak hanya bertanya:

> **"Apa yang ingin kamu pelajari?"**

Tetapi juga:

> **"Apa yang bisa kamu ajarkan?"**

Konsep utama:

```text
           TEACH
             ↓
        ┌──────────┐
        │ SkillSwap│
        └──────────┘
             ↓
           LEARN
```

Pengguna bukan hanya menjadi **learner**, tetapi juga dapat menjadi **mentor** bagi orang lain.

---

# 📚 Example Use Case

### Case 1 — Programming

Gabriel ingin belajar Python.

Gabriel dapat mengajarkan UI/UX.

Sistem menemukan Andi.

Andi dapat mengajarkan Python dan ingin belajar UI/UX.

**Result: 100% SkillSwap Match**

---

### Case 2 — Design

Sarah ingin belajar Photoshop.

Kevin dapat mengajarkan Photoshop tetapi ingin belajar Public Speaking.

Sarah dapat mengajarkan Public Speaking.

Sistem mempertemukan Sarah dan Kevin.

---

# 👥 Target Community

SkillSwap dapat digunakan oleh:

* Mahasiswa dalam satu universitas.
* Organisasi mahasiswa.
* Komunitas kampus.
* Antaruniversitas.
* Komunitas profesional pemula.

Versi awal project difokuskan pada **mahasiswa** agar scope tetap terkontrol.

---

# 📈 Project Goals

Keberhasilan aplikasi dapat diukur melalui:

* Jumlah pengguna aktif.
* Jumlah SkillSwap request.
* Jumlah session yang selesai.
* Jumlah skill yang dipertukarkan.
* Rating pengguna.
* Jumlah skill yang berhasil dipelajari.

Contoh target MVP:

```text
100 Users
50 SkillSwap Matches
30 Completed Sessions
20 Different Skills
4.5+ Average Rating
```

---

# 👨‍💻 Development Status

**Status:** `In Development`

### Current Version

`v1.0.0`

### Development Focus

* UI/UX
* Authentication
* Skill Management
* Matching System
* SkillSwap Request
* Chat
* Session Management
* Rating System

---

# 📄 License

Project ini dibuat untuk tujuan **pembelajaran dan tugas akademik**.

© 2026 SkillSwap Team. All Rights Reserved.

---

# 👨‍🎓 Academic Project

**Project:** SkillSwap
**Category:** Mobile Programming
**Platform:** Android / Mobile
**Target User:** University Students
**Concept:** Peer-to-Peer Skill Exchange

---

## 💡 Tagline

> **Learn something new. Teach what you know. Swap your skills.**

**SkillSwap — Learn. Teach. Swap.**
