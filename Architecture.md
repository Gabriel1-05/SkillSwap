# SkillSwap Architecture

Dokumen ini mencatat fondasi yang sudah ada dan batas integrasi saat ini. Target arsitektur produk tetap mengikuti pemisahan **Screens/Widgets → Providers → Services → Firebase** dari spesifikasi proyek.

## Kondisi implementasi

| Layer | Status |
|---|---|
| Presentation | Shell Material 3, Beranda, Temukan, Chat/Sesi placeholder, Profil demo, auth screen |
| State | `DiscoverProvider` dan `AuthProvider` dengan `ViewState` |
| Service | `MatchingService` murni dan `AuthService` Firebase Auth |
| Data | Data contoh lokal; belum ada Firebase initialization atau operasi jaringan |
| Security | Rules awal mengizinkan baca profil/skill setelah login serta request terbatas; fitur yang belum tersedia ditolak |

## Matching service

`MatchingService` tidak bergantung pada Firebase. Ia menghitung komponen skor dari `UserModel`, hanya mengembalikan kandidat dengan `Skill Match = 100`, mengecualikan pengguna aktif, dan mengurutkan hasil secara menurun. Detail skor tersedia di `MatchResult`.

Availability dihitung dari banyaknya slot bersama dibagi jumlah slot terkecil dari kedua pengguna. Mode yang sama bernilai 100; mode fleksibel bernilai 50 jika tidak sama; online dan offline bernilai 0. Kandidat tanpa review memperoleh skor rating 0.

## Firebase dan batas keamanan

`firestore.rules` adalah baseline, bukan rules produksi lengkap. Requests dapat dibuat oleh pengirim dengan validasi pihak dan pesan; perubahan status pending dibatasi ke aksi penerima atau pengirim. Writes untuk messages, sessions, dan reviews ditolak sampai kontrak service dan tes security rules untuk fitur tersebut diselesaikan. Jalankan rules pada Firebase Emulator sebelum deploy ke project yang berisi data.

Konfigurasi native Firebase dibuat untuk project pemilik melalui `flutterfire configure`; tidak ada kredensial yang disimpan dalam repository.

## Langkah implementasi berikutnya

1. Tambahkan Firebase initialization dan auth guard; auth provider/service sudah tersedia untuk register, login, logout, dan password reset.
2. Implementasikan model serialization dan onboarding dengan validasi bisnis profil serta skill.
3. Ganti data demo discover dengan query Firestore dan pertahankan matching sebagai service pure.
4. Implementasikan request, sesi, review, lalu chat stream; uji setiap rules dengan Emulator.