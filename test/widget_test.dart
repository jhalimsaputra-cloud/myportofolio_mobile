import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';
import 'package:myportofolio_mobile/widgets/skill_image.dart';

Widget _testApp([MockClient? client]) => MyApp(
  apiClient: ApiClient(
    baseUrl: 'http://example.test',
    client: client ?? MockClient((_) async => http.Response('[]', 200)),
  ),
);

Future<void> _submitLogin(WidgetTester tester) async {
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Username'),
    'owner',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Password'),
    'password',
  );
  await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('displays the three portfolio identity cards', (tester) async {
    await tester.pumpWidget(_testApp());

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

  testWidgets('retries a public request and refreshes an empty project list', (
    tester,
  ) async {
    var requests = 0;
    final client = MockClient((request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/api/v1/projects/');
      expect(request.headers, isNot(contains('authorization')));
      return switch (++requests) {
        1 => http.Response('unavailable', 503),
        2 => http.Response('[]', 200),
        _ => http.Response(
          '[{"id":"project-id","title":"Sample project","description":"Description from Django",'
          '"tech_stack":"Flutter","project_url":"https://example.com/","project_image_url":null}]',
          200,
        ),
      };
    });
    await tester.pumpWidget(_testApp(client));

    await tester.tap(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('No projects found.'), findsOneWidget);

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 350));
    await tester.pumpAndSettle();
    expect(requests, 3);
    await tester.tap(find.text('Sample project'));
    await tester.pumpAndSettle();

    expect(find.text('Description from Django'), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('https://example.com/'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('guards the form, creates a project with a token and logs out', (
    tester,
  ) async {
    var projectPosts = 0;
    var logoutPosts = 0;
    final client = MockClient((request) async {
      expect(request.method, 'POST');
      switch (request.url.path) {
        case '/api/v1/auth/token/':
          expect(jsonDecode(request.body), {
            'username': 'owner',
            'password': 'password',
          });
          return http.Response('{"token":"test-token"}', 200);
        case '/api/v1/projects/':
          expect(request.headers['authorization'], 'Token test-token');
          final project = jsonDecode(request.body) as Map<String, dynamic>;
          expect(project, {
            'title': 'New project',
            'description': 'Description',
            'tech_stack': 'Flutter',
            'project_url': 'https://example.com/',
            'project_image_url': '',
          });
          projectPosts++;
          return http.Response(
            jsonEncode({'id': 'server-id', ...project}),
            201,
          );
        case '/api/v1/auth/logout/':
          expect(request.headers['authorization'], 'Token test-token');
          logoutPosts++;
          return http.Response('', 204);
        default:
          fail('Unexpected request: ${request.url}');
      }
    });

    await tester.pumpWidget(_testApp(client));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsNothing);

    await tester.tap(find.byType(DrawerButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await _submitLogin(tester);
    expect(find.byType(ProjectFormPage), findsOneWidget);

    final title = find.widgetWithText(TextFormField, 'Title');
    final description = find.widgetWithText(TextFormField, 'Description');
    final techStack = find.widgetWithText(TextFormField, 'Tech Stack');
    final url = find.widgetWithText(TextFormField, 'Project URL');
    final save = find.text('Save');
    final formScroll = find.byType(Scrollable).first;
    await tester.enterText(title, 'New project');
    await tester.enterText(description, 'Description');
    await tester.enterText(techStack, 'Flutter');
    await tester.enterText(url, 'example.com');
    await tester.scrollUntilVisible(save, 100, scrollable: formScroll);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(
      find.text('Masukkan URL yang dimulai dengan http:// atau https://.'),
      findsOneWidget,
    );
    expect(projectPosts, 0);

    await tester.enterText(url, 'https://example.com/');
    await tester.scrollUntilVisible(save, 100, scrollable: formScroll);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(projectPosts, 1);
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsNothing);
    expect(find.byType(ProjectFormPage), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(logoutPosts, 1);
    expect(find.text('Kamu sudah logout.'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('stacks cards and scrolls at a width of 320', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 480);
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(_testApp());

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

    final login = find.text('Login');
    expect(login.hitTestable(), findsNothing);
    await tester.ensureVisible(login);
    await tester.pumpAndSettle();

    expect(login.hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens the skill form from its card and handles back', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());
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
    await tester.pumpWidget(_testApp());
    tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Skill'));
    await tester.pumpAndSettle();
    expect(find.byType(SkillFormPage), findsOneWidget);

    await tester.tap(find.byType(DrawerButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(SkillFormPage), findsNothing);
    expect(find.text('MyPortfolio'), findsOneWidget);
  });

  testWidgets('validates the skill form before showing its summary', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());
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
    expect(
      tester.widget<TextFormField>(imageUrl).controller!.text,
      'ftp://example.com/flutter.png',
    );

    await tester.ensureVisible(imageUrl);
    const validImageUrl = 'https://example.com/flutter.png';
    await tester.enterText(imageUrl, validImageUrl);
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();

    expect(find.text('Skill telah Ditambahkan'), findsOneWidget);
    expect(find.text('Nama Skill: Flutter'), findsOneWidget);
    expect(find.text('Tipe Skill: Software Development'), findsOneWidget);
    expect(find.text('Deskripsi: Membuat aplikasi mobile'), findsOneWidget);
    expect(find.text('URL Gambar: $validImageUrl'), findsOneWidget);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(SkillFormPage), findsOneWidget);
    for (final field in tester.widgetList<TextFormField>(fields)) {
      expect(field.controller!.text, isEmpty);
    }
    expect(tester.state<FormFieldState<String>>(skillType).value, isNull);
    expect(find.byType(SkillImage), findsNothing);
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
