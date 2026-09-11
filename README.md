# SkillSwap 🎓

### Learn. Teach. Swap.

**SkillSwap** adalah aplikasi mobile berbasis **peer-to-peer skill exchange** yang dirancang untuk membantu mahasiswa menemukan teman belajar berdasarkan kemampuan yang mereka miliki dan skill yang ingin mereka pelajari.

Berbeda dari platform kursus pada umumnya, SkillSwap tidak berfokus pada transaksi jual beli kursus. Konsep utama aplikasi adalah **pertukaran pengetahuan antar mahasiswa**.

Pengguna dapat menjadi **learner** sekaligus **mentor** bagi pengguna lain.

---

# 📋 Project Scope

## 1. Deskripsi Masalah

Mahasiswa memiliki kemampuan dan kebutuhan belajar yang berbeda-beda. Ada mahasiswa yang menguasai programming, desain, editing, bahasa, public speaking, atau skill lainnya.

Di sisi lain, terdapat mahasiswa yang ingin mempelajari skill tersebut tetapi kesulitan menemukan teman belajar atau mentor yang sesuai.

Masalah yang ingin diselesaikan SkillSwap adalah:

* Mahasiswa kesulitan menemukan teman belajar dengan skill yang sesuai.
* Mahasiswa yang memiliki kemampuan tertentu belum memiliki wadah untuk membagikan ilmunya.
* Proses mencari teman belajar masih dilakukan secara manual melalui lingkungan pertemanan atau komunitas.
* Platform pembelajaran pada umumnya lebih berfokus pada hubungan antara pengajar dan peserta, bukan pertukaran skill dua arah.
* Mahasiswa membutuhkan metode belajar yang lebih sosial dan interaktif.

### Solusi

SkillSwap mempertemukan mahasiswa berdasarkan dua jenis informasi:

**Skill yang dapat diajarkan**
dan
**Skill yang ingin dipelajari**

Contohnya:

```text
Gabriel
Can Teach:
- UI/UX
- HTML/CSS

Want to Learn:
- Python
- Data Science
```

Kemudian sistem dapat menemukan mahasiswa lain:

```text
Andi
Can Teach:
- Python
- Data Science

Want to Learn:
- UI/UX
```

Keduanya dapat melakukan pertukaran skill:

```text
Gabriel → belajar Python dari Andi
Gabriel → mengajarkan UI/UX kepada Andi
```

Dengan demikian, proses belajar menjadi **dua arah dan saling menguntungkan**.

---

# 2. Profil Target Pengguna

Target utama SkillSwap adalah **mahasiswa perguruan tinggi**.

### Target pengguna utama

* Mahasiswa yang ingin mempelajari skill baru.
* Mahasiswa yang memiliki skill tertentu dan ingin mengajarkannya.
* Mahasiswa yang ingin mencari teman belajar.
* Mahasiswa yang ingin mengembangkan skill di luar perkuliahan.
* Mahasiswa yang ingin belajar melalui metode peer-to-peer.

### Target komunitas

SkillSwap dapat dikembangkan untuk:

* Mahasiswa dalam satu universitas.
* Organisasi mahasiswa.
* Komunitas kampus.
* Antaruniversitas.

Namun, untuk versi awal, aplikasi **difokuskan pada mahasiswa** agar ruang lingkup pengembangan tetap realistis untuk diselesaikan dalam **12 pertemuan**.

---

# 3. Manfaat Aplikasi

SkillSwap memberikan beberapa manfaat utama:

### 🎓 Bagi mahasiswa

* Mempermudah menemukan teman belajar.
* Membantu mendapatkan mentor sebaya.
* Mempermudah mencari skill yang ingin dipelajari.
* Memberikan kesempatan untuk mengajarkan skill yang dikuasai.
* Membantu mahasiswa mengembangkan kemampuan di luar perkuliahan.

### 🤝 Bagi komunitas kampus

* Membangun komunitas belajar berbasis peer-to-peer.
* Mendorong mahasiswa untuk saling berbagi pengetahuan.
* Meningkatkan interaksi antar mahasiswa.
* Membentuk lingkungan belajar yang lebih kolaboratif.

### 💡 Konsep utama

SkillSwap tidak hanya menanyakan:

> **"Apa yang ingin kamu pelajari?"**

Tetapi juga:

> **"Apa yang bisa kamu ajarkan?"**

---

# 4. Daftar Fitur Inti

Karena proyek harus diselesaikan dalam **12 pertemuan**, fitur inti dibatasi pada fungsi yang mendukung alur utama pertukaran skill.

## Fitur wajib

### 1. Authentication 🔐

Pengguna dapat:

* Register.
* Login.
* Logout.
* Mengelola akun.

---

### 2. User Profile 👤

Profile pengguna berisi:

* Nama.
* Foto profil.
* Universitas.
* Program studi.
* Tahun angkatan.
* Rating.
* Skill yang dapat diajarkan.
* Skill yang ingin dipelajari.
* Availability.
* Mode pembelajaran.

Contoh:

```text
Gabriel
Informatics Student

⭐ 4.8 Rating

CAN TEACH
🎨 UI/UX
💻 HTML/CSS

WANT TO LEARN
🐍 Python
📊 Data Science
```

---

### 3. Skill Management 🧠

Pengguna dapat menentukan:

#### I Can Teach

Skill yang dikuasai dan dapat diajarkan.

Contoh:

* Python
* UI/UX
* Figma
* Photoshop
* Video Editing
* Public Speaking

#### I Want to Learn

Skill yang ingin dipelajari.

Contoh:

* Data Science
* Java
* Photography
* English
* Marketing

---

### 4. Skill Discovery 🔎

Pengguna dapat mencari pengguna berdasarkan skill.

Kategori:

* Programming
* Design
* Business
* Academic
* Language
* Creative
* Marketing
* Productivity

Pengguna dapat melihat pengguna yang memiliki skill yang dibutuhkan.

---

### 5. Skill Matching 🎯

Sistem memberikan rekomendasi pengguna berdasarkan kecocokan skill.

Parameter utama:

* Skill yang ingin dipelajari.
* Skill yang dapat diajarkan.
* Skill yang ingin dipelajari pengguna lain.
* Skill yang dapat diajarkan pengguna lain.
* Availability.
* Mode pembelajaran.

Contoh:

```text
🎯 95% MATCH

Andi Pratama

Can Teach:
🐍 Python
📊 Data Science

Wants to Learn:
🎨 UI/UX
```

Untuk versi awal, sistem matching menggunakan **scoring sederhana**, bukan Artificial Intelligence.

---

### 6. SkillSwap Request 🤝

Pengguna dapat mengirim permintaan pertukaran skill.

Contoh:

```text
SkillSwap Request

I want to learn:
🐍 Python

I can teach:
🎨 UI/UX

Message:

"Hi! I would like to learn Python from you.
In exchange, I can help you learn UI/UX."
```

Penerima dapat:

* Accept.
* Decline.

---

### 7. Chat 💬

Setelah request diterima, pengguna dapat berkomunikasi.

Fitur:

* Text message.
* Timestamp.
* Read status.

Chat digunakan untuk membahas proses dan jadwal belajar.

---

### 8. Session Scheduling 📅

Pengguna dapat membuat sesi belajar.

Informasi session:

* Skill.
* Teacher.
* Learner.
* Date.
* Start time.
* End time.
* Mode.
* Meeting link.
* Status.

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

---

### 9. Rating & Review ⭐

Setelah session selesai, pengguna dapat memberikan rating.

```text
⭐ ⭐ ⭐ ⭐ ⭐
```

Pengguna juga dapat memberikan komentar mengenai pengalaman belajar.

Rating dapat digunakan sebagai salah satu informasi pendukung dalam sistem matching.

---

# 5. User Flow

Alur utama aplikasi:

```text
Splash Screen
      ↓
Login / Register
      ↓
Complete Profile
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
Accept Request
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
```

Alur tersebut merupakan **core workflow** yang menjadi fokus utama pengembangan dalam 12 pertemuan.

---

# 6. Fitur yang Tidak Dikerjakan

Untuk menjaga agar proyek realistis dan dapat diselesaikan dalam **12 pertemuan**, fitur berikut **tidak menjadi bagian dari implementasi utama**.

### ❌ Tidak termasuk dalam MVP

* AI Skill Recommendation.
* Skill Assessment.
* Personalized Learning Roadmap.
* Leaderboard.
* Calendar Integration.
* Sistem pembayaran.
* Marketplace atau jual beli kursus.
* Integrasi video conference langsung.
* Advanced Learning Progress.
* Gamification kompleks.
* Achievement system.
* Sistem subscription.
* Verifikasi sertifikat skill.

Fitur-fitur tersebut dapat menjadi bagian dari **future development** apabila aplikasi dikembangkan lebih lanjut.

---

# 7. Batasan Scope 12 Pertemuan

Agar pengembangan tetap realistis, project dibatasi pada:

```text
Authentication
      ↓
User Profile
      ↓
Skill Management
      ↓
Skill Discovery
      ↓
Skill Matching
      ↓
SkillSwap Request
      ↓
Chat
      ↓
Session Scheduling
      ↓
Rating & Review
```

Fokus utama bukan pada jumlah fitur sebanyak mungkin, tetapi memastikan **core workflow dapat berjalan dari awal hingga akhir**.

---

# 8. Kriteria Aplikasi Dinyatakan Berhasil

Aplikasi dinyatakan berhasil apabila pengguna dapat menyelesaikan proses utama SkillSwap tanpa mengalami kegagalan fungsi.

### Functional Criteria

Pengguna harus dapat:

* Membuat akun.
* Login ke aplikasi.
* Melengkapi profile.
* Menentukan skill yang dapat diajarkan.
* Menentukan skill yang ingin dipelajari.
* Menemukan pengguna lain.
* Mendapatkan hasil matching.
* Mengirim SkillSwap Request.
* Menerima atau menolak request.
* Melakukan chat setelah request diterima.
* Membuat jadwal session.
* Menyelesaikan session.
* Memberikan rating dan review.

### Technical Criteria

Aplikasi harus:

* Dapat dijalankan pada perangkat Android.
* Memiliki interface yang dapat digunakan dengan baik.
* Dapat menyimpan data pengguna.
* Dapat menyimpan data skill.
* Dapat menyimpan request.
* Dapat menyimpan data session.
* Dapat menyimpan chat.
* Dapat menyimpan rating dan review.
* Memiliki alur navigasi yang jelas.
* Tidak mengalami error pada core workflow.

### Project Success Criteria

Secara keseluruhan, MVP dianggap berhasil apabila:

> **Seorang mahasiswa dapat mendaftar, menentukan skill yang ingin dipelajari dan diajarkan, menemukan mahasiswa yang sesuai, melakukan SkillSwap, berkomunikasi, menjadwalkan sesi belajar, menyelesaikan sesi, dan memberikan rating.**

---

# 9. MVP Scope

## Core Features

| Feature             | Status | Prioritas |
| ------------------- | ------ | --------- |
| Authentication      | ✅      | High      |
| User Profile        | ✅      | High      |
| Skill Selection     | ✅      | High      |
| Teach / Learn Skill | ✅      | High      |
| Skill Discovery     | ✅      | High      |
| Skill Matching      | ✅      | High      |
| SkillSwap Request   | ✅      | High      |
| Chat                | ✅      | High      |
| Session Scheduling  | ✅      | High      |
| Rating & Review     | ✅      | High      |

## Future Features

| Feature              | Status |
| -------------------- | ------ |
| XP                   | Future |
| Achievement          | Future |
| Learning Progress    | Future |
| Notification         | Future |
| Leaderboard          | Future |
| AI Recommendation    | Future |
| Calendar Integration | Future |
| Skill Assessment     | Future |
| Learning Roadmap     | Future |

---

# 10. Smart Matching Algorithm

Versi awal SkillSwap menggunakan sistem **scoring sederhana**.

Parameter:

```text
Skill Match          50%
Reverse Skill Match  20%
Schedule Match       15%
Learning Mode        10%
Rating                5%
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

Contoh:

```text
Skill Match:       100
Reverse Match:     100
Schedule Match:     80
Mode Match:        100
Rating:             90
```

Hasil:

```text
Final Score = 95.5%
```

Kemudian ditampilkan kepada pengguna:

```text
🎯 96% Match
```

> **Catatan:** Matching pada MVP tidak menggunakan AI. Sistem menggunakan rule-based scoring agar realistis untuk pengembangan dalam 12 pertemuan.

---

# 11. Application Architecture

SkillSwap dirancang menggunakan arsitektur sederhana:

```text
┌─────────────────────┐
│      Mobile App     │
│       Flutter       │
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│   Firebase Auth     │
│   Authentication    │
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│   Cloud Firestore   │
│      Database       │
└──────────┬──────────┘
           │
      ┌────┴─────┐
      ↓          ↓
┌───────────┐ ┌────────────────┐
│ Firebase  │ │ Firebase Cloud │
│ Storage   │ │ Messaging      │
│           │ │                │
│ Profile   │ │ Notification   │
│ Image     │ │                │
└───────────┘ └────────────────┘
```

---

# 12. Database Structure

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

Type:

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

# 13. Technology Stack

## Frontend

**Flutter**

* Dart
* Material Design
* Responsive UI

## Backend

**Firebase**

* Firebase Authentication
* Cloud Firestore
* Firebase Storage

## Development Tools

* Android Studio
* Visual Studio Code
* Git
* GitHub

---

# 14. UI/UX Guidelines

SkillSwap menggunakan konsep desain:

* Modern.
* Clean.
* Minimal.
* Friendly.
* Student-oriented.
* Easy to navigate.

Komponen UI:

* Rounded cards.
* Skill chips.
* Progress indicators jika diperlukan.
* Rating stars.
* Bottom navigation.
* Clear typography.
* Empty states.
* Loading states.
* Error states.

Desain dibuat sederhana agar pengguna dapat memahami fungsi aplikasi tanpa membutuhkan banyak langkah.

---

# 15. Privacy & Safety

Karena SkillSwap mempertemukan pengguna secara langsung, aspek keamanan menjadi perhatian.

Fitur yang dapat digunakan:

* Block user.
* Report user.
* Cancel session.
* Rating system.
* Community guidelines.

Untuk pertemuan offline:

> Pengguna disarankan melakukan pertemuan di tempat umum seperti kampus, perpustakaan, cafe, atau study space.

Aplikasi tidak menampilkan alamat pribadi pengguna.

---

# 16. Contoh Use Case

## Case 1 — Programming

Gabriel ingin belajar Python.

Gabriel dapat mengajarkan UI/UX.

Sistem menemukan Andi:

```text
Gabriel
Want to Learn:
Python

Can Teach:
UI/UX
```

```text
Andi
Can Teach:
Python

Want to Learn:
UI/UX
```

Mereka memiliki kecocokan dua arah.

```text
Gabriel ←──── Python ──── Andi
Gabriel ───── UI/UX ────→ Andi
```

Kemudian mereka dapat:

```text
Match
 ↓
Request
 ↓
Accept
 ↓
Chat
 ↓
Schedule
 ↓
Learning Session
 ↓
Rating
```

---

## Case 2 — Design

Sarah ingin belajar Photoshop.

Kevin dapat mengajarkan Photoshop tetapi ingin belajar Public Speaking.

Sarah dapat mengajarkan Public Speaking.

Sistem dapat mempertemukan Sarah dan Kevin berdasarkan kecocokan tersebut.

---

# 17. Future Development

Apabila SkillSwap dikembangkan lebih lanjut, beberapa fitur dapat ditambahkan.

### AI Skill Recommendation

Sistem dapat menganalisis:

* Skill.
* Riwayat belajar.
* Session.
* Rating.
* Preferensi pengguna.

Kemudian memberikan rekomendasi skill dan pengguna yang lebih personal.

---

### Skill Assessment

Pengguna dapat mengikuti quiz untuk mengetahui level skill.

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

* XP.
* Jumlah session.
* Teaching.
* Rating.
* Contribution.

---

# 18. Unique Selling Point

SkillSwap memiliki konsep yang berbeda dari aplikasi pembelajaran biasa.

Aplikasi tidak hanya berfokus pada:

> **Learn**

tetapi juga:

> **Teach**

Konsep:

```text
           TEACH
             ↓
      ┌──────────────┐
      │  SkillSwap   │
      └──────────────┘
             ↓
           LEARN
```

Setiap pengguna memiliki kesempatan untuk menjadi **learner sekaligus mentor**.

Hal tersebut membuat proses pembelajaran bersifat:

**Two-way learning.**

---

# 19. Project Goals

Tujuan utama SkillSwap:

1. Mempermudah mahasiswa menemukan teman belajar.
2. Memfasilitasi pertukaran skill antar mahasiswa.
3. Membangun komunitas belajar berbasis peer-to-peer.
4. Membantu mahasiswa mengembangkan kemampuan di luar perkuliahan.
5. Memberikan pengalaman belajar yang lebih sosial dan interaktif.
6. Membuat proses berbagi pengetahuan menjadi lebih mudah.

---

# 20. Development Status

**Status:** `In Development`

**Version:** `v1.0.0`

### Development Focus

* Authentication.
* User Profile.
* Skill Management.
* Skill Discovery.
* Matching System.
* SkillSwap Request.
* Chat.
* Session Management.
* Rating System.

---

# 21. Installation

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

Buat project baru pada Firebase kemudian aktifkan:

* Authentication.
* Cloud Firestore.
* Firebase Storage.

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

# 22. Project Structure

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

# 23. Academic Project

**Project:** SkillSwap
**Category:** Mobile Programming
**Platform:** Android / Mobile
**Target User:** University Students
**Concept:** Peer-to-Peer Skill Exchange

Project ini dibuat untuk tujuan **pembelajaran dan tugas akademik**.

---

# 📌 Project Summary

SkillSwap adalah aplikasi mobile yang mempertemukan mahasiswa berdasarkan skill yang dapat mereka ajarkan dan skill yang ingin mereka pelajari.

Masalah utama yang diselesaikan adalah kesulitan mahasiswa dalam menemukan teman belajar yang sesuai.

Core workflow aplikasi:

```text
Register
   ↓
Profile
   ↓
Select Skills
   ↓
Discover
   ↓
Match
   ↓
SkillSwap Request
   ↓
Chat
   ↓
Schedule
   ↓
Learning Session
   ↓
Rating & Review
```

Dengan scope yang dibatasi pada fitur inti tersebut, **SkillSwap dirancang agar MVP dapat dikembangkan secara realistis dalam 12 pertemuan**.

---

# 💡 Tagline

> **Learn something new. Teach what you know. Swap your skills.**

### SkillSwap — Learn. Teach. Swap.
