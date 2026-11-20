import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';
import 'package:myportofolio_mobile/widgets/skill_image.dart';

void main() {
  testWidgets('displays the three portfolio identity cards', (tester) async {
    await tester.pumpWidget(const MyApp());

    const identity = {
      'NPM': '2506549386',
      'Name': 'Justin Evan Halim Saputra',
      'Class': 'PBP B',
    };

    expect(find.byType(InfoCard), findsNWidgets(3));
    for (final entry in identity.entries) {
      final card = find.ancestor(
        of: find.text(entry.key),
        matching: find.byType(InfoCard),
      );
      expect(
        find.descendant(of: card, matching: find.text(entry.value)),
        findsOneWidget,
      );
    }
  });

  for (final label in ['Lihat Proyek', 'Tambah Proyek', 'Logout']) {
    testWidgets('shows the exact SnackBar message for $label', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text('Kamu telah menekan tombol $label!'),
        ),
        findsOneWidget,
      );
    });
  }

  testWidgets('stacks cards and scrolls at a width of 320', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 480);
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const MyApp());

    for (final cardType in [InfoCard, ItemCard]) {
      final cards = find.byType(cardType);
      final cardCount = cardType == InfoCard ? 3 : 4;
      expect(cards, findsNWidgets(cardCount));
      for (var i = 1; i < cardCount; i++) {
        final previous = tester.getRect(cards.at(i - 1));
        final current = tester.getRect(cards.at(i));
        expect(current.left, previous.left);
        expect(current.top, greaterThan(previous.bottom));
        expect(current.right, lessThanOrEqualTo(320));
      }
    }

    final logout = find.text('Logout');
    expect(logout.hitTestable(), findsNothing);
    await tester.ensureVisible(logout);
    await tester.pumpAndSettle();

    expect(logout.hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens the skill form from its card and handles back', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Tambah Skill'));
    await tester.pumpAndSettle();
    expect(find.byType(SkillFormPage), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(SkillFormPage), findsNothing);
    expect(find.text('MyPortfolio'), findsOneWidget);
  });

  testWidgets('opens the skill form from the drawer and returns Home', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Skill'));
    await tester.pumpAndSettle();
    expect(find.byType(SkillFormPage), findsOneWidget);

    await tester.tap(find.byTooltip('Buka menu navigasi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(SkillFormPage), findsNothing);
    expect(find.text('MyPortfolio'), findsOneWidget);
  });

  testWidgets('validates the skill form before showing its summary', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Tambah Skill'));
    await tester.pumpAndSettle();

    final save = find.text('Simpan');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(find.text('Nama skill wajib diisi.'), findsOneWidget);
    expect(find.text('Pilih tipe skill.'), findsOneWidget);
    expect(find.text('Deskripsi skill wajib diisi.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    final fields = find.byType(TextFormField);
    await tester.ensureVisible(fields.at(0));
    await tester.enterText(fields.at(0), 'Flutter');
    final skillType = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(skillType);
    await tester.tap(skillType);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Software Development').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(fields.at(1));
    await tester.enterText(fields.at(1), 'Membuat aplikasi mobile');

    final imageUrl = fields.at(2);
    await tester.ensureVisible(imageUrl);
    await tester.enterText(imageUrl, 'ftp://example.com/flutter.png');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(
      find.text('Masukkan URL gambar atau link file Drive yang valid.'),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);

    await tester.ensureVisible(imageUrl);
    await tester.enterText(imageUrl, '');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();

    expect(find.text('Ringkasan Skill'), findsOneWidget);
    expect(find.text('Nama Skill: Flutter'), findsOneWidget);
    expect(find.text('Tipe Skill: Software Development'), findsOneWidget);
    expect(find.text('Deskripsi: Membuat aplikasi mobile'), findsOneWidget);
    expect(find.text('URL Gambar: Tidak diisi'), findsOneWidget);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(SkillFormPage), findsOneWidget);
  });

  testWidgets('previews a shared Drive URL and handles a failed image load', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SkillFormPage()));
    final imageUrl = find.byType(TextFormField).last;
    await tester.ensureVisible(imageUrl);

    const sharedUrl =
        'https://drive.google.com/file/d/abc_123/view?resourcekey=0-example';
    await tester.enterText(imageUrl, sharedUrl);
    await tester.pump(const Duration(milliseconds: 349));
    final preview = find.byType(SkillImage);
    expect(preview, findsNothing);

    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(
      tester.widget<SkillImage>(preview).previewUri,
      Uri.parse(
        'https://drive.google.com/thumbnail?id=abc_123&sz=w800'
        '&resourcekey=0-example',
      ),
    );
    expect(tester.widget<TextFormField>(imageUrl).controller!.text, sharedUrl);
    // The widget test binding returns a failed response without using the network.
    expect(find.text('Pratinjau gambar tidak tersedia'), findsOneWidget);

    await tester.enterText(imageUrl, '');
    await tester.pump();
    expect(preview, findsNothing);
  });

  testWidgets('keeps Save reachable with the keyboard on a narrow screen', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewInsets);

    await tester.pumpWidget(const MaterialApp(home: SkillFormPage()));
    await tester.showKeyboard(find.byType(TextFormField).first);
    tester.view.viewInsets = const FakeViewPadding(bottom: 220);
    await tester.pumpAndSettle();

    final save = find.text('Simpan');
    expect(save.hitTestable(), findsNothing);
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    expect(save.hitTestable(), findsOneWidget);
    expect(tester.getBottomRight(save).dy, lessThanOrEqualTo(420));
    expect(tester.takeException(), isNull);
  });
}
