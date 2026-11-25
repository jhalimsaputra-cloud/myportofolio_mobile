# MyPortfolio Mobile

[![CI](https://github.com/jhalimsaputra-cloud/myportofolio_mobile/actions/workflows/main.yaml/badge.svg?branch=main)](https://github.com/jhalimsaputra-cloud/myportofolio_mobile/actions/workflows/main.yaml)

Aplikasi Flutter untuk proyek portofolio pribadi pada mata kuliah Pemrograman Berbasis Platform (PBP). Daftar dan detail Skill bisa dibuka tanpa login. Akun yang berizin dapat menambah atau mengedit Skill melalui Django REST Framework (DRF). Formulir mendukung pratinjau gambar opsional.

[Repositori backend Django](https://github.com/jhalimsaputra-cloud/myportofolio) · [API Skill di PWS](https://justin-evan-myportofolio.pws.cs.ui.ac.id/api/v1/skills/)

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
dart run build_runner build
flutter devices
```

Jalankan ulang `dart run build_runner build` setelah mengubah model JSON. Pada `build_runner` 2.17.1, opsi lama `--delete-conflicting-outputs` sudah dihapus dan diabaikan.

Untuk backend lokal, ikuti setup repositori Django, lalu jalankan `python manage.py migrate` dan `python manage.py runserver` di repo tersebut. Buat akun pengujian lokal melalui `python manage.py createsuperuser` untuk mencoba POST. Editor yang mempunyai izin `main.change_skill` bisa mencoba PATCH. [Setup backend Django](https://github.com/jhalimsaputra-cloud/myportofolio#setup--cara-menjalankan-secara-lokal)

| Target | Perintah dari repo Flutter |
| --- | --- |
| Emulator Android dengan Django lokal | `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000` |
| Chrome dengan Django lokal | `flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000` |
| Android dengan API PWS | `flutter run --dart-define=API_BASE_URL=https://justin-evan-myportofolio.pws.cs.ui.ac.id` |

Untuk memasang versi release, buka run CI yang lulus untuk commit yang ingin diuji, unduh artefak **app-release-apk**, lalu ekstrak dan pasang `app-release.apk` pada Android. APK dari CI sudah diarahkan ke API PWS melalui `API_BASE_URL`. [GitHub Actions](https://github.com/jhalimsaputra-cloud/myportofolio_mobile/actions/workflows/main.yaml)

## Analisis dan tes

Jalankan perintah berikut dari folder utama proyek.

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze lib test
flutter test
```

Suite Flutter mencakup navigasi dan validasi yang sudah ada, request GET tanpa token, serialisasi POST, PATCH yang hanya mengirim field yang berubah, serta pemulihan sesi kedaluwarsa. Tes Django dijalankan dengan `python manage.py test` di repo backend. Suite tersebut menguji token DRF, izin per peran, dan CSRF untuk sesi browser.

Untuk memeriksa alur dengan database lokal, buka **Lihat Skill** dari Home atau **Daftar Skill** dari drawer saat belum login. Ketuk satu entri dan periksa detailnya. Isi form **Tambah Skill**, tekan **Simpan**, dan login dengan superuser pengujian. Periksa entri baru di Flutter dan segarkan halaman **Skills** di situs Django. Buka detail dan gunakan **Edit Skill** untuk mencoba PATCH.

Untuk menguji HTTP 401, login di Flutter lalu hapus token akun pengujian melalui Django Admin atau shell Django lokal. Kirim formulir dan periksa bahwa aplikasi meminta login ulang. Isian harus tetap tersedia untuk dikirim kembali. Ulangi dengan akun yang tidak berizin untuk memeriksa pesan 403, lalu uji menu **Logout**.

Jika tes gagal membaca aset shader yang dihasilkan Flutter, misalnya `ink_sparkle.frag`, bangun ulang cache dengan `flutter clean`, jalankan ulang `flutter pub get` dan generator JSON, lalu coba lagi.

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

### Assignment 9

1. **Model JSON bertipe.** `Skill` memberi widget tipe Dart untuk nama, deskripsi, kategori, dan metadata. `FieldRename.snake` menerjemahkan `skillType` dan `imageFilename` ke `skill_type` dan `image_filename`, sesuai serializer DRF. Contoh bug yang dicegah adalah form mengirim `skillType` secara manual sehingga Django menganggap field wajib `skill_type` belum diisi dan menolak POST dengan HTTP 400. `@JsonKey(includeToJson: false)` memungkinkan model membaca UUID dan metadata bintang dari respons, sekaligus mengeluarkan field yang dikelola server dari payload tulis. Tes memeriksa body POST dan PATCH untuk memastikan aturan ini.
2. **Siklus hidup Future dan error HTTP.** `initState()` membuat satu request awal per instans layar. `build()` dapat berjalan lagi, misalnya setelah perubahan tema atau sesi, sehingga membuat `Future` di sana dapat mengulang GET dan menampilkan loading berkali-kali. Aksi Retry dan pull-to-refresh secara sengaja mengganti Future. `ApiException` membawa status HTTP sehingga layar dapat membedakan sesi invalid (401), akun tanpa izin (403), dan data ditolak (400). `null` akan menghilangkan informasi tersebut dan mudah tercampur dengan respons sukses yang tidak memiliki entri.
3. **Autentikasi dan izin.** `SessionAuthentication` membaca sesi Django dari cookie yang biasa dikirim browser. Mutasi melalui sesi harus memenuhi pemeriksaan CSRF. `TokenAuthentication` membaca `Authorization: Token <key>` yang dikirim Flutter setelah login, dan Django mencocokkannya dengan token yang tersimpan di server. Ini memberi Flutter jalur autentikasi tanpa mengelola cookie sesi dan token CSRF browser. Django tetap menyediakan autentikasi sesi untuk situs dan Browsable API. Kedua mekanisme memakai izin server yang sama. Jika token dicabut, Flutter menghapus token lokal dan meminta login ulang. [Autentikasi DRF](https://www.django-rest-framework.org/api-guide/authentication/)
4. **Job CI dan kode generasi.** Job `build` memakai `very_good_workflows` untuk memasang Flutter dan dependensi, menjalankan setup yang membangkitkan serializer, memeriksa format, menjalankan analyzer, dan menjalankan tes beserta laporan cakupan. Setelah lulus, `build_apk` menyiapkan Flutter dan Java 17 di runner sendiri, memasang dependensi, membangkitkan serializer lagi, membuat APK release dengan URL PWS, dan mengunggahnya. `*.g.dart` diabaikan Git karena bisa dibangkitkan kembali dari model dan versi dependensi. Checkout CI tetap menyediakannya untuk analisis yang membutuhkan deklarasi tersebut, pengujian, dan kompilasi. [Workflow Flutter reusable](https://github.com/VeryGoodOpenSource/very_good_workflows/blob/v2/.github/workflows/flutter_package.yml)

#### 🤖 AI Disclosure

Dalam pengerjaan tugas ini, saya menggunakan bantuan **Gemini Hydrogen** untuk menelaah berkas spesifikasi PDF Tugas 9 terhadap basis kode proyek, merancang struktur model serialisasi JSON (`Skill`), menyusun draf awal integrasi *endpoint* `GET` dan `POST` pada `ApiClient`, menyusun kerangka tampilan daftar (*List Screen*) dan detail (*Detail Screen*), menulis draf pengujian otomatis berbasis `MockClient`, serta menyusun draf `README.md`. Saya menentukan batas arsitektur, menyesuaikan setiap bagian dengan kode aplikasi (`myportofolio_mobile`) dan backend Django (`myportofolio`), serta melakukan verifikasi baik melalui tes otomatis maupun pengujian langsung terhadap backend Django lokal.

Berikut adalah detail penyesuaian dan perbaikan yang saya lakukan terhadap keluaran AI:

1. **Penyesuaian model `Skill` dan penanganan gambar opsional dengan backend Django**
   - **Output AI:** Draf awal menyertakan *field* generik (`category` dan `proficiency`) tanpa URL gambar. Selanjutnya, pada draf integrasi awal, pemetaan URL gambar dari formulir Flutter ke serializer Django belum menangani perbedaan aturan kolom opsional antara sisi Flutter (URL gambar boleh kosong) dan skema/validasi backend Django.
   - **Perbaikan:** Saya menyelaraskan atribut model `lib/models/skill.dart` (`@JsonSerializable(fieldRename: FieldRename.snake)` dan `@JsonKey(includeToJson: false)` pada `id`) agar sesuai dengan `SkillSerializer` pada backend Django serta mempertahankan validasi URL gambar dari Tugas 8 melalui `lib/models/skill_image_url.dart`, sehingga entri tanpa URL gambar tetap dapat dikirim dan diproses dengan bersih.

2. **Alur autentikasi pada formulir serta penempatan tampilan gambar dan navigasi**
   - **Output AI:** Draf awal mengunci pembukaan formulir sejak awal, mengganti formulir Tugas 8 dengan *input* angka kemahiran baru, menampilkan teks datar pada layar detail, dan memasang `LeftDrawer` langsung pada halaman daftar.
   - **Perbaikan:** Saya mempertahankan `SkillFormPage` (`lib/screens/skill_form.dart`) beserta *live preview* dengan *debounce* 350 milidetik, serta menerapkan pemeriksaan login melalui `ensureLoggedIn(context)` saat pengguna menekan tombol **Simpan** dan input dinyatakan valid (sehingga formulir tetap dapat dibuka terlebih dahulu sebelum login). Komponen `SkillImage` (`lib/widgets/skill_image.dart`) ditampilkan pada formulir dan layar detail (`lib/screens/skill_detail_screen.dart`), sedangkan layar daftar (`lib/screens/skill_list_screen.dart`) menampilkan ringkasan teks. Navigasi dihubungkan melalui kartu aksi **Lihat Skill** di halaman utama (`lib/screens/menu.dart`) dan menu **Daftar Skill** di `lib/widgets/left_drawer.dart`.

3. **Penyegaran daftar setelah penyimpanan data (`SkillListScreen`)**
   - **Output AI:** Implementasi awal transisi setelah penyimpanan formulir belum memicu pembaruan `Future` daftar secara konsisten ketika pengguna kembali ke `SkillListScreen`.
   - **Perbaikan:** Melalui pengujian otomatis di `test/widget_test.dart`, saya menemukan bahwa daftar skill tidak otomatis menyegarkan data setelah entri baru berhasil disimpan. Saya memperbaiki nilai kembalian navigasi dari `SkillFormPage` dan pemanggilan ulang `_refreshSkills()` di `SkillListScreen` sehingga entri yang baru dibuat langsung muncul tanpa perlu *pull-to-refresh* manual.

4. **Penambahan `API_BASE_URL` produksi pada pipeline GitHub Actions (`.github/workflows/main.yaml`)**
   - **Output AI:** Workflow bawaan dari Tutorial 10 sudah menggunakan `very_good_workflows` (`flutter_package.yml@v2`), Java 17, versi Flutter `3.47.9`, *concurrency*, *cache*, serta pemeriksaan artefak, tetapi perintah `flutter build apk --release` belum menyertakan alamat backend yang di-deploy.
   - **Perbaikan:** Saya menambahkan variabel lingkungan `API_BASE_URL: https://justin-evan-myportofolio.pws.cs.ui.ac.id` dan meneruskannya melalui flag `--dart-define="API_BASE_URL=$API_BASE_URL"` pada langkah *build* APK *release* agar artefak `app-release-apk` langsung terhubung ke server PWS.

5. **Penambahan pengujian otomatis dengan `MockClient` dan verifikasi end-to-end lokal**
   - **Output AI:** Draf awal tidak menyertakan skenario pengujian terisolasi untuk lapisan jaringan dan penanganan status HTTP `401`.
   - **Perbaikan:** Saya menambahkan pengujian otomatis pada `test/skill_integration_test.dart` dan memperbarui `test/widget_test.dart` menggunakan `MockClient` untuk memverifikasi pembacaan daftar & detail publik, pemeriksaan login saat menekan **Simpan**, pengiriman `POST` dengan *header* `Authorization: Token <key>`, serta penghapusan sesi pada galat `401`. Seluruh rangkaian tes berjalan otomatis di GitHub Actions, dan saya juga memverifikasi penyimpanan data dari antarmuka Flutter hingga basis data melalui server Django lokal.

   Link percakapan:
   https://share.gemini.google/8z7nKgVzLGXD