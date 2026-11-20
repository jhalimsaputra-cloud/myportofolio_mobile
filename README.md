# MyPortfolio Mobile

Aplikasi Flutter untuk proyek portofolio pribadi pada mata kuliah Pemrograman Berbasis Platform (PBP). Halaman utama menampilkan kartu identitas dan aksi **Lihat Proyek**, **Tambah Proyek**, **Tambah Skill**, serta **Logout**. Kartu **Tambah Skill** dan opsi **Add Skill** di drawer membuka formulir yang menampilkan ringkasan isian dan pratinjau gambar opsional. Tombol **Profil** di AppBar membuka ringkasan nama dan kelas yang bisa disalin.

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

Target analisis adalah `No issues found!`. Tes widget memeriksa tiga kartu identitas, pesan `SnackBar` untuk aksi proyek dan logout, serta gulir halaman utama pada lebar 320 piksel logis. Untuk Tugas 8, tes mencakup pembukaan form dari kartu dan drawer, navigasi kembali lewat Back dan **Home**, penolakan input wajib yang kosong, serta penampilan dan penutupan dialog ringkasan. Untuk mencoba fitur Profil, buka panel, tekan **Salin profil**, lalu tempel teks ke editor dan cocokkan nama serta kelasnya.

Untuk mencoba formulir di Chrome, buka **Tambah Skill** dari kartu dan **Add Skill** dari drawer. Uji tombol **Simpan** dengan kolom wajib kosong, lalu isi nama, tipe, dan deskripsi sampai dialog ringkasan tampil. Coba URL yang tidak valid dan tautan berkas gambar Google Drive yang dapat diakses. Gunakan opsi **Home** di drawer untuk kembali ke halaman utama. Pada viewport sempit, pastikan tombol **Simpan** dapat dijangkau dengan menggulir. Ulangi cek ini di ponsel atau emulator saat papan ketik layar terbuka.

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
| Tutorial 09 · Navigation, Layouts, Forms, and Input Elements | Menambahkan drawer dan formulir Tambah Proyek. | [9ec33bd](https://github.com/jhalimsaputra-cloud/myportofolio_mobile/commit/9ec33bd) |
| Tugas 8 · Formulir skill | Menambahkan input tervalidasi, dialog ringkasan, dan pratinjau gambar opsional. | [6743b86](https://github.com/jhalimsaputra-cloud/myportofolio_mobile/commit/6743b86) |
| Tugas 8 · Navigasi dan tes | Menghubungkan kartu dan drawer ke formulir skill serta menguji navigasi, validasi, dan dialog. | [5037ac5](https://github.com/jhalimsaputra-cloud/myportofolio_mobile/commit/5037ac5) |

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

### Tugas 8

1. **Navigasi antarlayar.** `Navigator.push()` menambahkan rute baru di atas rute aktif sehingga tombol Back bisa kembali ke halaman sebelumnya. Kartu **Tambah Skill** memakai metode ini untuk membuka `SkillFormPage`. `Navigator.pushReplacement()` mengganti rute aktif dengan rute baru. Drawer menggunakannya saat berpindah dari satu formulir ke formulir lain, sehingga hanya satu formulir berada di atas halaman utama. `Navigator.pop()` menutup rute aktif atau menangani riwayat lokal rute, seperti menutup drawer yang terbuka. Saat **Home** dipilih, `pop()` menutup drawer dan `popUntil((route) => route.isFirst)` kembali ke halaman utama.

2. **Struktur dan tema halaman.** `Scaffold` menyediakan kerangka yang sama untuk menempatkan `AppBar`, drawer, dan konten. `AppBar` menampilkan judul dan tombol yang sesuai dengan halaman. Komponen `LeftDrawer` dipakai di halaman utama dan kedua formulir sehingga menu **Home**, **Add Project**, dan **Add Skill** tersedia dari ketiganya. AppBar halaman utama dan formulir skill sama-sama menggunakan `Theme.of(context).colorScheme.primary` untuk latar dan `onPrimary` untuk teks serta ikon.

3. **Tata letak formulir.** `Column` menata nama, tipe, deskripsi, URL gambar, dan tombol **Simpan** secara vertikal. `Padding` menjaga jarak dari tepi, `SizedBox` memberi jarak antarinput, dan `ConstrainedBox` membatasi lebar formulir hingga 560 piksel logis agar nyaman dibaca pada layar lebar. `SafeArea` memberi ruang dari area sistem. `SingleChildScrollView` memungkinkan pengguna menggulir ke input dan tombol Simpan ketika layar sempit atau ruang vertikal berkurang karena papan ketik.

4. **Validasi sebelum menampilkan ringkasan.** `GlobalKey<FormState>` memberi handler tombol **Simpan** akses ke state formulir. `validate()` menjalankan setiap `validator` dan menampilkan pesan kesalahan pada kolom terkait. Dialog ringkasan baru tampil setelah semua input lolos. Contohnya, URL gambar `ftp://example.com/gambar.png` ditolak karena formulir hanya menerima skema HTTP atau HTTPS. `TextInputType.url` menyesuaikan papan ketik untuk pengetikan URL, tetapi pengguna masih bisa menempel nilai yang tidak valid. Karena itu, pemeriksaan format tetap dilakukan oleh `validator`.

#### 🤖 AI Disclosure

Dalam pengerjaan tugas ini, saya menggunakan bantuan **Gemini Hydrogen** untuk menelaah PDF Tugas 8 dan kode proyek, mengusulkan struktur formulir skill, menulis draf awal fungsi normalisasi tautan gambar (*shared link*), membuat *widget* formulir beserta *live preview*, serta menyusun draf dokumentasi. Saya memberikan berkas spesifikasi tugas dan kode proyek sebagai acuan, menetapkan cakupan tiap tahap, serta memeriksa dan menguji hasil keluarannya di terminal lokal.

Berikut adalah detail penyesuaian dan perbaikan yang saya lakukan dengan bantuan AI:

1. **Normalisasi tautan Google Drive dan validasi format URL**
   - **Output AI:** Draf awal AI mengubah tautan Google Drive menjadi format `https://drive.google.com/uc?export=view&id=<FILE_ID>`, mendukung beberapa penyedia lain (GitHub dan Dropbox), dan hanya mengenali pola path `/file/d/<ID>` atau parameter `?id=`. Selain itu, kolom URL gambar diwajibkan diisi dan tidak memeriksa parameter `resourcekey` maupun karakter spasi di dalam URL.
   - **Perbaikan:** Saya memisahkan logika ini ke `lib/models/skill_image_url.dart` melalui fungsi `skillImagePreviewUri()`. Saya menggunakan endpoint `/thumbnail?id=<ID>&sz=w800` untuk pratinjau gambar Google Drive, menambahkan dukungan path `/open`, `/uc`, dan `/thumbnail`, mempertahankan parameter `resourcekey` jika tersedia, menolak spasi atau *userinfo* pada URI, serta menjadikan kolom URL gambar bersifat opsional dan tetap memvalidasi formatnya saat diisi.

2. **Optimasi *live preview* dengan *debouncing* dan pemisahan komponen gambar**
   - **Output AI:** AI merancang kartu pratinjau langsung (*Live Preview Card*) yang memanggil `setState()` setiap kali karakter pada kolom URL berubah (`onChanged`), serta menuliskan pemuatan `Image.network` secara langsung di dalam `skill_form.dart`.
   - **Perbaikan:** Saya mengekstrak tampilan gambar menjadi widget tersendiri di `lib/widgets/skill_image.dart` yang dilengkapi `CircularProgressIndicator` pada `frameBuilder`, `WebHtmlElementStrategy.fallback` untuk kompatibilitas browser, serta `semanticLabel` untuk aksesibilitas. Pada `SkillFormPage`, saya menggunakan `Timer` (*debounce* 350 milidetik) pada `_updateImagePreview()` agar pemuatan gambar menunggu jeda setelah pengguna mengetik URL. Timer dibatalkan saat URL berubah lagi dan di `dispose()`.

3. **Konsistensi akses *drawer* pada formulir**
   - **Output AI:** Pada `SkillFormPage`, AI menggunakan `AppBar` standar tanpa konfigurasi `leading` dan `actions` khusus. Saat `Scaffold` memiliki *drawer*, `AppBar` memprioritaskan tombol *drawer* pada posisi `leading` otomatis, termasuk ketika halaman dibuka melalui `Navigator.push()` dari kartu utama.
   - **Perbaikan:** Saya menyamakan posisi ikon menu di kiri atas pada formulir skill dan proyek melalui tombol *drawer* bawaan `AppBar`. Pengguna dapat membuka `LeftDrawer` untuk kembali ke **Home** atau berpindah ke **Add Project**. Navigasi dari kartu **Tambah Skill** tetap memakai `Navigator.push()` agar tombol kembali perangkat bisa digunakan.

4. **Perilaku navigasi *drawer* dan interaksi dialog ringkasan**
   - **Output AI:** AI menyarankan penggunaan `Navigator.pushReplacement()` secara seragam pada seluruh item di *drawer* dan menggunakan widget `Text` biasa di dalam `AlertDialog` ringkasan.
   - **Perbaikan:** Saya menggunakan parameter `isProjectForm` dan `isSkillForm` pada `lib/widgets/left_drawer.dart` agar perpindahan antarformulir memakai `pushReplacement()`, pembukaan formulir dari halaman utama memakai `push()`, dan pilihan halaman yang sedang aktif cukup menutup *drawer*. Opsi **Home** menutup *drawer* dan memanggil `popUntil((route) => route.isFirst)`. Setelah validasi berhasil, saya menyimpan salinan isian untuk dialog **Skill telah Ditambahkan** dan mengosongkan form. Dialog tetap bisa digulir, dan nama, deskripsi, serta URL gambar bisa disalin melalui `SelectableText`.

5. **Penyederhanaan model, tombol aksi, dan aturan validasi input**
   - **Output AI:** Draf AI menyertakan model `SkillItem` dengan penyimpanan daftar statis sementara, menetapkan nilai awal otomatis pada `DropdownButtonFormField`, memakai `.length` dengan batas 50 karakter untuk nama, serta menempatkan dua tombol berdampingan (**Reset** dan **Simpan**).
   - **Perbaikan:** Saya memilih untuk menghapus penyimpanan daftar sementara dan tombol **Reset** agar sesuai dengan cakupan Tugas 8, serta menggunakan satu tombol `FilledButton` penuh bertuliskan **Simpan**. Saya membiarkan pilihan awal `DropdownButtonFormField` kosong (`null`) dengan opsi *Software Development* dan *Systems & Architecture* disertai `validator` agar pengguna wajib memilih tipe. Saya menggunakan `name.runes.length > 100` untuk membatasi nama hingga 100 Unicode *code points*, serta membungkus formulir dalam `ConstrainedBox` dengan `maxWidth: 560` di dalam `SingleChildScrollView` yang memakai `keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag`.

6. **Penambahan skenario pengujian otomatis (*widget test*)**
   - **Output AI:** Draf awal dari Gemini belum menyertakan kode pengujian otomatis untuk alur navigasi, validasi, maupun pratinjau gambar pada Tugas 8.
   - **Perbaikan:** Saya menambahkan lima skenario pengujian baru di `test/widget_test.dart`. Skenario ini memverifikasi pembukaan formulir dari kartu utama beserta tombol Back, navigasi dari *drawer* kembali ke **Home**, penolakan input wajib kosong dan skema URL `ftp://` serta penampilan dialog ringkasan untuk input yang valid, perilaku *debounce* 350 milidetik dan *fallback* dengan simulasi kegagalan pemuatan gambar Drive, serta keterjangkauan tombol **Simpan** saat papan ketik disimulasikan terbuka pada layar selebar 320 piksel. Saya menjalankan `flutter analyze` dan `flutter test` di terminal lokal. Analisis tidak menemukan masalah dan semua 10 *widget test* lolos.

Link percakapan:
https://share.gemini.google/bJU4orpUzVVn
