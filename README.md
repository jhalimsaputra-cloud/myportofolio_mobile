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

### Tugas 7

1. **Widget tree dan hubungan parent–child.** Widget tree adalah susunan widget yang membentuk antarmuka. Parent menyusun widget anak lewat properti seperti `child` atau `children`. Pada tahap layout, parent memberikan batas ukuran, child memilih ukuran di dalam batas itu, lalu parent menentukan posisi child. Di proyek ini, `runApp` memasang `MyApp` sebagai root. `MyApp` membangun `MaterialApp` yang membuka `MyHomePage`. Di dalam halaman itu, `Column` menyusun grup kartu identitas, teks sambutan, dan grup kartu aksi secara vertikal. [Arsitektur Flutter](https://docs.flutter.dev/resources/architectural-overview)

2. **Widget yang dipakai di kode aplikasi.**

   - **Kerangka aplikasi:** `MyApp` memulai susunan antarmuka. `MaterialApp` menyediakan tema dan navigasi. `MyHomePage` menyusun menu utama. `Scaffold` menyediakan tempat untuk AppBar dan isi halaman. `AppBar` menampilkan judul serta tombol Profil. `SnackBar` menampilkan pesan singkat saat kartu aksi ditekan.
   - **Tata letak:** `SafeArea` memberi ruang dari area sistem. `SingleChildScrollView` membuat isi bisa digulir. `Center` memusatkan konten. `ConstrainedBox` membatasi lebar halaman atau menetapkan tinggi minimum kartu. `Column` menata anak secara vertikal dan `Row` menata anak secara horizontal. `Expanded` memberi judul panel ruang yang tersisa di dalam `Row`. `Padding` menambah ruang di sekeliling anak, sedangkan `SizedBox` menetapkan lebar kartu atau memberi jarak antarbagian.
   - **Susunan kartu:** `_CardGroup` dipakai ulang untuk mengelompokkan kartu identitas dan kartu aksi. `LayoutBuilder` memberi grup batas lebar dari parent. `Wrap` menempatkan kartu berurutan dan memindahkan kartu berikutnya ke baris baru ketika ruang habis.
   - **Isi kartu:** `InfoCard` memasangkan label identitas dengan nilainya dan `Card` menyediakan permukaan dengan elevasi. `ItemCard` menampilkan data dari `ItemHomepage`. `Material` memberi warna latar dan permukaan untuk efek sentuh `InkWell`, yang juga menjalankan aksi saat ditekan. `Icon` menggambar simbol dan `Text` menampilkan judul, label, nilai, atau pesan.
   - **Panel Profil:** `ProfileSheet` menampilkan ringkasan dan menyimpan status penyalinan. `IconButton` digunakan untuk membuka dan menutup panel. `FilledButton.icon` menampilkan aksi **Salin profil** dengan ikon dan label. `Semantics` menandai pesan hasil penyalinan sebagai pembaruan yang dapat diumumkan pembaca layar.

3. **Fungsi `MaterialApp`.** `MaterialApp` menyediakan pengaturan Material Design di tingkat aplikasi, seperti tema bersama, navigasi melalui `Navigator`, dan layanan `ScaffoldMessenger` untuk menampilkan `SnackBar`. Di sini, `MyApp` adalah widget yang diberikan ke `runApp` dan `MaterialApp` menjadi akar konfigurasi Material yang dibangunnya. Properti `theme` mengatur tema Material 3 yang dipakai halaman, sedangkan `home` memilih `MyHomePage` sebagai layar awal. Penempatan ini membuat seluruh halaman bisa memakai konfigurasi yang sama. [API MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp-class.html)

4. **Kapan memilih `StatelessWidget` atau `StatefulWidget`.** Pilih `StatelessWidget` untuk tampilan yang dapat dibangun dari parameter dan nilai yang tersedia di sekitarnya, seperti tema. Widget ini tetap bisa dibangun ulang ketika masukan berubah. Contohnya, `InfoCard` menampilkan `title` dan `content`, sedangkan `MyHomePage` menyusun menu dari data yang sudah ditentukan. Pilih `StatefulWidget` ketika tampilan perlu merespons nilai lokal yang berubah selama widget aktif. Pada `ProfileSheet`, nilai `_copyStatus` berada di objek `State`. Saat penyalinan selesai, `setState` meminta Flutter membangun ulang panel agar pesan berhasil atau gagal tampil. [API StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)

5. **Fungsi `BuildContext`.** `BuildContext` mewakili posisi widget dalam tree. Posisi ini penting karena fungsi seperti `Theme.of(context)` mencari tema yang menaungi widget di posisi tersebut. Di dalam `build` milik `MyHomePage`, hasil pencarian itu dipakai untuk warna AppBar dan gaya teks sambutan. Saat kartu ditekan, `ScaffoldMessenger.of(context)` memakai konteks halaman untuk menemukan pengelola `SnackBar`. Di panel Profil, `Navigator.of(context).pop()` memakai konteks panel untuk menutup rute modalnya. [API BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html)

6. **Hot reload, hot restart, dan full restart.** Dalam mode debug, hot reload memuat perubahan Dart lalu membangun ulang tampilan sambil mempertahankan state yang sedang berjalan. Contohnya, saya bisa mengubah padding di `InfoCard` dan menekan `r` pada terminal `flutter run` untuk melihat jarak baru. Hot restart menjalankan aplikasi Dart lagi dari `main()` dan mengatur ulang state di memori. Gunakan ini jika perubahan perlu menjalankan kembali `main()`, `initState()`, atau nilai awal state yang sudah dibuat, seperti status awal penyalinan pada panel Profil. Full restart berarti menghentikan sesi dan menjalankan aplikasi kembali. Ini diperlukan jika kode native ikut berubah, misalnya kode Kotlin pada proyek Android. [Panduan hot reload Flutter](https://docs.flutter.dev/tools/hot-reload)

#### 🤖 AI Disclosure

Dalam pengerjaan tugas ini, saya menggunakan bantuan **Gemini Pro** untuk menelaah PDF Tugas 7 dan kode Tutorial 08, mengusulkan perubahan, menulis draf kode menu dan panel Profil, membuat tes widget, serta menyusun draf README. Saya memberikan PDF dan kode proyek sebagai acuan, menetapkan cakupan tiap tahap, dan meminta penjelasan perubahan sebelum melanjutkan. 

Berikut adalah detail penyesuaian dan perbaikan yang saya lakukan terhadap output AI:

1. **Tata letak kartu pada layar sempit**
   - **Output AI:** Dari pemeriksaan kode Tutorial 08, AI menemukan bahwa kartu identitas disusun dalam `Row` dan kartu aksi memakai `GridView.count` dengan tiga kolom tetap. Susunan awal ini menyisakan sedikit ruang untuk nama lengkap dan label tombol pada layar sempit.
   - **Perbaikan:** Saya menerapkan `_CardGroup` yang menggunakan `LayoutBuilder` dan `Wrap`. Saya mengatur agar kedua grup kartu memakai satu kolom jika lebar konten setelah *padding* di bawah 600 piksel logis, dan tiga kolom jika ruangnya cukup. Saya juga memverifikasi tampilan satu kolom dan akses ke tombol terakhir pada lebar 320 piksel logis.

2. **Ringkasan Profil dan aksi salin**
   - **Output AI:** AI mengusulkan panel Profil di `AppBar` dengan aksi **Salin profil**. Berdasarkan folder website yang diperiksa, informasi yang dapat dicocokkan terbatas pada data dari README identitas.
   - **Perbaikan:** Setelah menyetujui usulan tersebut, saya menambahkan `IconButton` di `AppBar` dan mengimplementasikan `ProfileSheet` sebagai panel modal. Saya menggunakan `Clipboard.setData` untuk fungsi menyalin **nama dan kelas** dalam dua baris. Saya juga mengatur agar panel menampilkan konfirmasi saat penyalinan berhasil, serta memberi kesempatan mencoba lagi jika gagal.

3. **Pemisahan model, tampilan, dan aksi**
   - **Output AI:** AI mengidentifikasi bahwa `MyHomePage`, `ItemHomepage`, `InfoCard`, dan `ItemCard` tergabung dalam satu file monolitik pada kode Tutorial 08, dan kode tampilan kartu aksi langsung mengeksekusi pesan `SnackBar`.
   - **Perbaikan:** Saya melakukan *refactoring* dengan memindahkan model ke `models/item_homepage.dart` dan komponen tampilan ke folder `widgets/`. Saya memodifikasi logika agar halaman menu yang menentukan pesan untuk ditampilkan, sedangkan `ItemCard` hanya menerima aksi melalui parameter `onTap`. Saya juga memisahkan file tes ke dalam *commit* tersendiri agar perubahan kode dan pengujiannya lebih rapi.

4. **Warna kartu dan konsistensi tema**
   - **Output AI:** AI menemukan bahwa semua kartu aksi pada kode bawaan Tutorial 08 mengambil warna sekunder yang sama (amber), dan mengusulkan penggunaan warna yang berbeda untuk memenuhi syarat tugas.
   - **Perbaikan:** Saya menetapkan warna biru tua, hijau tua, dan merah tua sebagai latar masing-masing kartu, lengkap dengan teks dan ikon berwarna putih agar kontras dan mudah dibaca. Saya merombak model agar setiap warna disimpan di `ItemHomepage` dan diaplikasikan melalui `item.color`. Selain itu, saya menghubungkan warna `AppBar` dengan `colorScheme` dari tema utama dan memastikan gaya teks menggunakan `textTheme` bawaan Material 3.

Link percakapan:
https://share.gemini.google/wI7afNYNyjDF