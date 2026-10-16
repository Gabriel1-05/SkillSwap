# Demo Local Data & Persistence — SkillSwap

Dokumen ini menjelaskan fitur penyimpanan lokal di SkillSwap, lokasi implementasinya, dan langkah demo yang bisa diikuti reviewer. Fitur ini menggunakan **Flutter `shared_preferences`** untuk menyimpan request SkillSwap dan booking sesi di perangkat/browser. Data untuk fitur ini **tidak disimpan ke Firebase**.

## Tujuan dan cakupan

Alur vertikal yang didemonstrasikan:

```text
Form di UI
  → Provider
  → SkillSwapRepository
  → LocalSkillSwapRepository
  → LocalStorageService
  → SharedPreferences perangkat/browser
```

Data request dan booking tetap tersedia setelah aplikasi ditutup lalu dibuka kembali atau setelah halaman web di-refresh, selama data situs/aplikasi tidak dihapus dan aplikasi dijalankan pada perangkat/browser serta origin yang sama.

## Lokasi implementasi

| Bagian | File | Tanggung jawab |
|---|---|---|
| Inisialisasi | [`lib/main.dart`](../lib/main.dart) | Menyiapkan Flutter, locale tanggal, `SharedPreferences`, repository, dan Provider sebelum `runApp`. |
| Model/entity | [`lib/models/workflow_models.dart`](../lib/models/workflow_models.dart) | Mendefinisikan `SkillSwapRequestDraft` dan `SessionBookingDraft`, termasuk konversi `toJson`/`fromJson`. |
| Kontrak repository | [`lib/services/skill_swap_repository.dart`](../lib/services/skill_swap_repository.dart) | Menetapkan operasi baca dan CRUD yang dipakai provider. Implementasi in-memory digunakan untuk tes workflow UI. |
| Repository persisten | [`lib/services/local_skill_swap_repository.dart`](../lib/services/local_skill_swap_repository.dart) | Memetakan model ke/dari penyimpanan lokal, menyediakan seed data awal, dan memvalidasi booking. |
| Akses storage | [`lib/services/local_storage_service.dart`](../lib/services/local_storage_service.dart) | Menyimpan dan membaca collection sebagai daftar string JSON di `SharedPreferences`. |
| Provider data lokal | [`lib/providers/local_data_provider.dart`](../lib/providers/local_data_provider.dart) | Memuat data dan menjalankan update/delete, lalu memberi notifikasi UI serta menampilkan error jika operasi gagal. |
| Form request | [`lib/screens/request_screen.dart`](../lib/screens/request_screen.dart) | Mengumpulkan input dan membuat request baru melalui `RequestProvider`. |
| Form booking | [`lib/screens/booking_screen.dart`](../lib/screens/booking_screen.dart) | Mengumpulkan input dan membuat booking baru melalui `BookingProvider`. |
| Daftar dan CRUD | [`lib/screens/local_data_screen.dart`](../lib/screens/local_data_screen.dart) | Menampilkan daftar request/booking, mengedit, mengonfirmasi penghapusan, dan memuat ulang data. |
| Tes persistence | [`test/services/local_skill_swap_repository_test.dart`](../test/services/local_skill_swap_repository_test.dart) | Menguji CRUD dan membaca ulang data setelah repository dibuat ulang menggunakan preferences yang sama. |
| Tes UI CRUD | [`test/screens/local_data_screen_test.dart`](../test/screens/local_data_screen_test.dart) | Menguji edit dan hapus request maupun booking melalui UI. |

## Data model

### Request — `SkillSwapRequestDraft`

| Field | Tipe | Keterangan |
|---|---|---|
| `receiverId` | `String` | ID pengguna penerima request. |
| `teachSkill` | `String` | Skill yang ditawarkan pembuat request. |
| `learnSkill` | `String` | Skill yang ingin dipelajari. |
| `message` | `String` | Pesan untuk calon partner. |

### Booking — `SessionBookingDraft`

| Field | Tipe | Keterangan |
|---|---|---|
| `requestId` | `String` | ID permintaan/pertukaran skill terkait. |
| `skillId` | `String` | ID skill untuk sesi. |
| `teacherId` | `String` | ID pengajar. |
| `learnerId` | `String` | ID pelajar. |
| `date` | `DateTime` | Tanggal sesi. |
| `startTime` | `DateTime` | Waktu mulai. |
| `endTime` | `DateTime` | Waktu selesai. |
| `mode` | `String` | Mode sesi: online atau offline. |
| `meetingLink` | `String` | Tautan sesi online; kosong untuk sesi offline. |

## Bentuk penyimpanan

`LocalStorageService` mengubah data model menjadi JSON, lalu menyimpan tiap collection sebagai `List<String>` di `SharedPreferences`.

| Key | Isi |
|---|---|
| `local_created_requests` | Request yang dibuat pengguna. |
| `local_created_bookings` | Booking sesi yang dibuat pengguna. |
| `local_candidates` | Data kandidat demo untuk form request. |
| `local_accepted_swaps` | Data pertukaran yang diterima untuk form booking. |

Kandidat dan accepted swap diinisialisasi sebagai seed data **hanya jika key collection belum pernah ada**. Menghapus semua record tidak menyebabkan data pengguna dibuat ulang sebagai record baru; penghapusan collection seed melalui fungsi reset berarti seed bisa dibuat kembali pada inisialisasi berikutnya.

## Demo langkah demi langkah

### 1. Menjalankan aplikasi

Dari root project:

```powershell
flutter pub get
flutter run -d chrome
```

Alternatif, jalankan aplikasi di emulator/perangkat Flutter yang tersedia. Jangan hapus data situs/browser selama demo persistence.

### 2. Create dan Read request

1. Buka tab **Temukan**.
2. Pilih **Kirim permintaan** pada kartu partner.
3. Isi pesan, lalu kirim request.
4. Buka tab **Data Lokal**.
5. Di tab **Permintaan**, pastikan request yang baru dikirim tampil bersama penerima, skill, dan pesan.

**Yang ditunjukkan:** alur form → provider → repository → local storage untuk Create; daftar Data Lokal membaca kembali record untuk Read.

### 3. Update dan Delete request

1. Pada kartu request, tekan ikon edit.
2. Ubah pesan, lalu tekan **Simpan**.
3. Pastikan nilai pesan pada kartu berubah.
4. Tekan ikon hapus, lalu konfirmasi **Hapus**.
5. Pastikan kartu request tidak lagi tampil.

Untuk demonstrasi persistence yang mudah dilihat, buat satu request baru lagi sebelum melanjutkan atau sebelum refresh.

### 4. Create dan Read booking

1. Buka tab **Sesi**.
2. Pilih permintaan yang diterima (data demo awal menyediakan satu permintaan).
3. Isi tanggal, waktu mulai dan selesai, mode belajar, serta tautan meeting jika mode online.
4. Tekan **Buat jadwal sesi**.
5. Buka tab **Data Lokal**, lalu pilih tab **Booking**.
6. Pastikan booking muncul dengan detail tanggal, waktu, mode, dan tautan (jika online).

### 5. Update dan Delete booking

1. Pada kartu booking, tekan ikon edit.
2. Ubah tanggal/waktu, mode, atau tautan meeting.
3. Tekan **Simpan** dan pastikan perubahan tampil pada kartu.
4. Tekan ikon hapus, lalu konfirmasi **Hapus**.
5. Pastikan booking tidak lagi tampil.

Validasi menolak waktu selesai yang tidak setelah waktu mulai serta tautan online yang bukan URL `http`/`https` dengan authority yang valid.

### 6. Membuktikan persistence setelah aplikasi dibuka kembali

1. Buat setidaknya satu request dan satu booking.
2. Pastikan keduanya terlihat pada halaman **Data Lokal**.
3. **Flutter web:** refresh halaman dengan `Ctrl+R`/`F5`. **Emulator/perangkat:** tutup aplikasi lalu jalankan kembali.
4. Buka lagi **Data Lokal** dan pastikan record yang belum dihapus tetap muncul dengan nilai hasil edit terakhir.

Data hanya berlaku untuk penyimpanan lokal yang sama. Origin berbeda (misalnya port/host berbeda), browser berbeda, perangkat berbeda, atau penghapusan data situs/aplikasi dapat menghasilkan penyimpanan terpisah atau menghapus record.

## Cara reviewer memeriksa implementasi

Urutan inspeksi kode yang disarankan:

1. Baca entity dan serialisasi di `lib/models/workflow_models.dart`.
2. Ikuti proses submit dari form di `lib/screens/request_screen.dart` atau `lib/screens/booking_screen.dart`.
3. Lihat state dan pemanggilan repository pada provider request/booking.
4. Periksa operasi Create, Read, Update, Delete di `lib/services/local_skill_swap_repository.dart`.
5. Periksa JSON dan `SharedPreferences` di `lib/services/local_storage_service.dart`.
6. Periksa tampilan baca/edit/hapus pada `lib/screens/local_data_screen.dart`.
7. Jalankan tes persistence dan tes CRUD UI di bawah ini.

Untuk mendemonstrasikan langsung ke reviewer, tunjukkan satu record yang dibuat, ubah nilainya, hapus satu record, lalu refresh aplikasi dengan record lainnya masih tersimpan.

## Tes otomatis

Jalankan dari root project:

```powershell
flutter test test/services/local_skill_swap_repository_test.dart
flutter test test/screens/local_data_screen_test.dart
flutter test
```

Tes repository menyimpan request dan booking, memperbaruinya, membuat repository baru dengan preferences yang sama, lalu membaca kembali record tersebut dan menguji penghapusan. Karena menggunakan mocked `SharedPreferences`, tes ini memverifikasi serialisasi/CRUD dan pembukaan ulang repository secara deterministik; tes ini **bukan pengganti demo refresh browser nyata** pada langkah 6.

Analisis statis project:

```powershell
flutter analyze
```

## Bukti demo yang bisa disiapkan

Jika reviewer meminta screenshot/video, rekam atau ambil bukti nyata dari aplikasi berjalan:

1. Form request sebelum disimpan.
2. Request yang tampil di **Data Lokal → Permintaan**.
3. Request sesudah diedit.
4. Booking yang tampil di **Data Lokal → Booking**.
5. Booking sesudah diedit.
6. Aplikasi setelah refresh/restart yang masih menampilkan record tersimpan.
7. Opsional: dialog konfirmasi hapus dan tampilan setelah record dihapus.

Jangan menaruh screenshot placeholder seolah-olah hasil aplikasi berjalan.

## Batasan yang perlu dijelaskan

- Penyimpanan yang didemonstrasikan adalah lokal dengan `SharedPreferences`, sesuai pilihan storage untuk project Flutter.
- Request dan booking pada fitur ini tidak dikirim ke Firebase, tidak disinkronkan ke cloud, dan tidak otomatis dibagikan ke pengguna/perangkat lain.
- `SharedPreferences` sesuai untuk data sederhana berukuran kecil; untuk data kompleks atau besar, pertimbangkan SQLite/Isar.
- `InMemorySkillSwapRepository` dipertahankan untuk fake/test workflow dan bukan storage persistence aplikasi utama.
