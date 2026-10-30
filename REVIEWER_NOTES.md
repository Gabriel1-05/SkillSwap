# Catatan Reviewer — SkillSwap P7

Dokumen ini merangkum alur demo, lokasi implementasi, dan pengujian untuk update MVP P7.

## Alur demo

1. Jalankan aplikasi web menggunakan konfigurasi Firebase lokal:

   ```powershell
   flutter run -d chrome --dart-define-from-file=firebase.local.json
   ```

2. Masuk atau daftar melalui tab **Profil**.
3. Buka **Temukan**, kirim request, lalu lihat request dari backend. Refresh browser dan muat kembali daftar untuk memeriksa persistensi Firestore.
4. Buka tab **Sesi** untuk membuat booking. Gunakan **Data Lokal** untuk membaca, mengedit, dan menghapus booking.
5. Di tab **Profil**, coba ambil atau hapus foto profil. Foto disimpan di perangkat/browser, tidak diunggah ke Firebase Storage.
6. Untuk booking tatap muka, lokasi bersifat opsional dan baru diminta setelah pengguna menekan tombol lokasi.

## Peta implementasi

| Bagian | Lokasi kode |
|---|---|
| Model booking dan koordinat opsional | `lib/models/workflow_models.dart` |
| Penyimpanan lokal dan repository booking | `lib/services/local_storage_service.dart`, `lib/services/local_skill_swap_repository.dart` |
| Abstraksi repository | `lib/services/skill_swap_repository.dart` |
| Pembuatan, validasi, dan state booking/lokasi | `lib/providers/booking_provider.dart`, `lib/screens/booking_screen.dart` |
| Daftar booking lokal: baca, edit, hapus | `lib/screens/local_data_screen.dart` |
| Pemilihan kamera | `lib/services/profile_photo_service.dart` |
| Persistensi foto profil lokal | `lib/providers/profile_photo_provider.dart` |
| UI foto profil | `lib/screens/app_shell.dart` |
| Permintaan izin dan pengambilan lokasi | `lib/services/location_capture_service.dart` |
| Izin lokasi Android foreground | `android/app/src/main/AndroidManifest.xml` |
| Konfigurasi Firebase client | `lib/firebase_options.dart`, `firebase.local.json.example` |

Authentication Firebase dan request Firestore merupakan alur backend yang sudah ada sebelumnya; perubahan P7 menambahkan kamera dan lokasi sebagai fitur opsional yang memakai penyimpanan lokal.

## State, izin, dan privasi

- Form booking memvalidasi input dan menampilkan loading, error, empty, serta retry pada alur terkait.
- Penolakan izin lokasi, layanan lokasi yang mati, timeout, atau pembatalan kamera ditangani tanpa memaksa pengguna memakai fitur tersebut.
- Lokasi tidak diminta di latar belakang. Lokasi booking dan foto profil tidak dikirim ke Firebase.
- Penyimpanan lokal tidak terenkripsi. Hindari foto atau koordinat sensitif pada perangkat/browser bersama.
- `firebase.local.json` berisi konfigurasi client lokal dan diabaikan Git. Firebase Web API key tetap dapat terlihat di hasil build client; gunakan API/referrer restrictions serta Firebase Authentication dan Firestore Rules. Jangan menaruh service-account key di aplikasi.

## Pengujian

```powershell
flutter test
flutter build web --dart-define-from-file=firebase.local.json
flutter build apk --debug --dart-define-from-file=firebase.local.json --android-project-arg=kotlin.incremental=false --android-project-arg=kotlin.compiler.execution.strategy=in-process
```

Test fitur lanjutan: `test/providers/advanced_features_test.dart`. Test repository booking lokal: `test/services/local_skill_swap_repository_test.dart`.

Build Android menggunakan opsi Gradle di atas untuk menghindari kegagalan penutupan cache incremental Kotlin pada lingkungan pengembangan; opsi tersebut tidak mengubah perilaku aplikasi.
