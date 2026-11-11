# MyPortfolio Mobile

Aplikasi Flutter untuk proyek portofolio pribadi pada mata kuliah Pemrograman Berbasis Platform (PBP). Halaman utama menampilkan kartu identitas dan tiga aksi, yaitu **Lihat Proyek**, **Tambah Proyek**, dan **Logout**. Setiap aksi menampilkan pesan `SnackBar` saat ditekan. Tombol **Profil** di AppBar membuka ringkasan nama dan kelas yang bisa disalin.

## Prasyarat

- Git untuk mengambil kode dari GitHub.
- [Flutter SDK](https://docs.flutter.dev/install) yang menyertakan Dart sesuai batasan `^3.13.7` di [pubspec.yaml](pubspec.yaml). Versi yang digunakan saat pengembangan adalah Flutter 3.47.9 dan Dart 3.13.7.
- Chrome atau Edge untuk menjalankan versi web.
- Android SDK dan emulator, atau Android SDK dan perangkat dengan USB debugging, untuk menjalankan versi Android.

## Setup dan cara menjalankan

```sh
git clone https://github.com/jhalimsaputra-cloud/myportofolio_mobile.git
cd myportofolio_mobile
flutter --version
flutter doctor
flutter pub get
flutter devices
```

Periksa daftar dari `flutter devices`, lalu jalankan aplikasi di salah satu target yang tersedia. Untuk Chrome, jalankan `flutter run -d chrome`. Untuk Edge, jalankan `flutter run -d edge`. Untuk Android, nyalakan emulator atau sambungkan perangkat, lalu jalankan `flutter run` dan pilih perangkat jika diminta.

## Analisis dan tes

Jalankan perintah berikut dari folder utama proyek.

```sh
flutter analyze
flutter test
```

Target analisis adalah `No issues found!`. Tes widget memeriksa tiga kartu identitas, teks `SnackBar` untuk setiap aksi, dan perilaku gulir pada layar sempit. Untuk mencoba fitur Profil, buka panel, tekan **Salin profil**, lalu tempel teks ke editor dan cocokkan nama serta kelasnya.

Jika tes gagal membaca aset shader yang dihasilkan Flutter, misalnya `ink_sparkle.frag`, bangun ulang cache lokal dengan `flutter clean`, lalu jalankan `flutter pub get` dan `flutter test` kembali.

## Referensi Flutter

- [Belajar Flutter](https://docs.flutter.dev/learn)
- [Panduan membuat aplikasi Flutter pertama](https://docs.flutter.dev/learn/pathway/tutorial/create-an-app)
- [Kumpulan sumber belajar Flutter](https://docs.flutter.dev/reference/learning-resources)
- [Referensi perintah Flutter](https://docs.flutter.dev/reference/flutter-cli)

## Progres mingguan

| Tahap | Hasil | Commit |
| --- | --- | --- |
| Tutorial 08 · Basic Flutter | Membuat dasar aplikasi, memisahkan `main.dart` dan `menu.dart`, serta menyiapkan kartu identitas dan aksi. | [eb19794](https://github.com/jhalimsaputra-cloud/myportofolio_mobile/commit/eb19794dc62556f9210152096604518734f968ea) |
| Tugas 7 · Menu | Memberi warna berbeda pada kartu aksi dan menyesuaikan susunan kartu dengan lebar layar. | [c2dc807](https://github.com/jhalimsaputra-cloud/myportofolio_mobile/commit/c2dc807ed655dc595163fbe70a4a97bd26261472) |
| Tugas 7 · Tes | Menguji identitas, tiga pesan `SnackBar`, dan tata letak layar sempit. | [183444d](https://github.com/jhalimsaputra-cloud/myportofolio_mobile/commit/183444d4b871f9f5deb6373838b6f4f9df935766) |
| Tugas 7 · Profil | Menambahkan panel ringkasan dan aksi untuk menyalin nama serta kelas. | [e202982](https://github.com/jhalimsaputra-cloud/myportofolio_mobile/commit/e20298281e8e8a823a2de864747e8275e6c790cb) |
