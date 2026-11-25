import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/models/skill.dart';
import 'package:myportofolio_mobile/models/skill_image_url.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

const _baseUrl = 'https://portfolio.example';
const _listPath = '/api/v1/skills/';
const _skill = {
  'id': 'aeb10dc6-28d8-4c50-b9e1-a8bf166350c4',
  'name': 'Flutter',
  'skill_type': 'Software',
  'description': 'Membuat aplikasi portofolio.',
  'image_filename': '',
  'star_count': 2,
  'is_starred': false,
  'starred_by_names': 'ana, rafi',
};
const _createPayload = {
  'name': 'Flutter',
  'skill_type': 'Software',
  'description': 'Membuat aplikasi portofolio.',
  'image_filename': '',
};

ApiClient _api(MockClient client) =>
    ApiClient(baseUrl: '$_baseUrl/', client: client);

http.Response _json(Object body, int statusCode) => http.Response(
  jsonEncode(body),
  statusCode,
  headers: {'Content-Type': 'application/json; charset=utf-8'},
);

Future<void> _login(WidgetTester tester) async {
  expect(find.byType(LoginScreen), findsOneWidget);
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Username'),
    'owner',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Password'),
    'test-password',
  );
  await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
  await tester.pumpAndSettle();
}

Future<void> _save(WidgetTester tester) async {
  final save = find.widgetWithText(FilledButton, 'Simpan');
  await tester.ensureVisible(save);
  await tester.tap(save);
  await tester.pumpAndSettle();
}

void main() {
  test('parses public skills and defaults optional metadata', () async {
    final client = _api(
      MockClient((request) async {
        expect(request.url.toString(), '$_baseUrl$_listPath');
        expect(request.method, 'GET');
        expect(request.headers['authorization'], isNull);
        return _json([
          {
            'id': _skill['id'],
            'name': 'Pemrograman dasar',
            'skill_type': 'Systems',
            'description': 'Arsitektur perangkat lunak',
            'image_filename': null,
          },
        ], 200);
      }),
    );

    final skill = (await client.getSkills()).single;
    expect(skill.id, _skill['id']);
    expect(skill.skillType, SkillType.systems);
    expect(skill.imageFilename, isEmpty);
    expect(skill.starCount, 0);
    expect(skill.isStarred, isFalse);
    expect(skill.starredByNames, isEmpty);
  });

  test('serializes write fields and sends only changes in a PATCH', () async {
    final original = Skill.fromJson(_skill);
    final updated = {..._skill, 'description': 'Deskripsi baru'};
    final client = _api(
      MockClient((request) async {
        expect(request.headers['authorization'], 'Token test-key');
        expect(request.headers['content-type'], startsWith('application/json'));
        if (request.method == 'POST') {
          expect(request.url.path, _listPath);
          expect(jsonDecode(request.body), _createPayload);
          return _json(_skill, 201);
        }
        expect(request.method, 'PATCH');
        expect(request.url.path, '$_listPath${original.id}/');
        expect(jsonDecode(request.body), {
          'description': updated['description'],
        });
        return _json(updated, 200);
      }),
    );

    expect(
      (await client.createSkill(original, token: 'test-key')).starCount,
      2,
    );
    final edited = Skill.fromJson(updated);
    final result = await client.updateSkill(
      original,
      edited,
      token: 'test-key',
    );
    expect(result.description, updated['description']);
  });

  test('preserves each non-2xx HTTP status in the API exception', () async {
    final original = Skill.fromJson(_skill);
    for (final status in [400, 401, 403, 404, 500]) {
      final client = _api(
        MockClient((_) async => _json({'detail': 'Request failed'}, status)),
      );
      await expectLater(
        client.createSkill(original, token: 'test-key'),
        throwsA(
          isA<ApiException>().having(
            (error) => error.statusCode,
            'status',
            status,
          ),
        ),
      );
    }
  });

  test('resolves legacy skill filenames and linked images safely', () {
    expect(
      skillImageUri('img/python.png', _baseUrl),
      Uri.parse('$_baseUrl/static/img/python.png'),
    );
    expect(
      skillImageUri('https://img.example/logo.png', _baseUrl),
      Uri.parse('https://img.example/logo.png'),
    );
    expect(skillImageUri('', _baseUrl), isNull);
    expect(skillImageUri('../private.png', _baseUrl), isNull);
    expect(skillImageUri('javascript:alert(1)', _baseUrl), isNull);
  });

  testWidgets('opens public skills, retries, refreshes, and shows detail', (
    tester,
  ) async {
    final first = Completer<http.Response>();
    var reads = 0;
    await tester.pumpWidget(
      MyApp(
        apiClient: _api(
          MockClient((request) async {
            expect(request.url.path, _listPath);
            expect(request.headers['authorization'], isNull);
            return switch (++reads) {
              1 => first.future,
              2 => _json([], 200),
              _ => _json([_skill], 200),
            };
          }),
        ),
      ),
    );
    await tester.tap(find.text('Lihat Skill'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    first.complete(_json({'detail': 'Unavailable'}, 503));
    await tester.pumpAndSettle();
    expect(find.text('Gagal memuat daftar skill.'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada skill.'), findsOneWidget);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 350));
    await tester.pumpAndSettle();
    expect(reads, 3);

    await tester.tap(find.text('Flutter'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Skill'), findsOneWidget);
    expect(find.text('Software Development'), findsOneWidget);
    expect(find.text(_skill['description']! as String), findsOneWidget);
    expect(find.text('ana, rafi'), findsOneWidget);
    expect(find.text(_skill['id']! as String), findsOneWidget);
  });

  testWidgets(
    'keeps draft on token revocation and refreshes on POST and PATCH',
    (tester) async {
      var logins = 0;
      var reads = 0;
      var creates = 0;
      var updates = 0;
      var skills = <Map<String, Object>>[];
      final path = '$_listPath${_skill['id']}/';
      final client = MockClient((request) async {
        if (request.url.path == '/api/v1/auth/token/') {
          expect(request.method, 'POST');
          final token = ++logins == 1 ? 'revoked' : 'fresh';
          return _json({'token': token}, 200);
        }
        if (request.url.path == _listPath && request.method == 'GET') {
          expect(request.headers['authorization'], isNull);
          reads++;
          return _json(skills, 200);
        }
        if (request.url.path == _listPath && request.method == 'POST') {
          expect(jsonDecode(request.body), _createPayload);
          if (++creates == 1) {
            expect(request.headers['authorization'], 'Token revoked');
            return _json({'detail': 'Invalid token.'}, 401);
          }
          expect(request.headers['authorization'], 'Token fresh');
          skills = [_skill];
          return _json(_skill, 201);
        }
        expect(request.url.path, path);
        expect(request.method, 'PATCH');
        expect(request.headers['authorization'], 'Token fresh');
        expect(jsonDecode(request.body), {'name': 'Flutter dan Dart'});
        updates++;
        final updated = {..._skill, 'name': 'Flutter dan Dart'};
        skills = [updated];
        return _json(updated, 200);
      });
      await tester.pumpWidget(MyApp(apiClient: _api(client)));
      tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Daftar Skill'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Tambah Skill'));
      await tester.pumpAndSettle();

      final name = find.widgetWithText(TextFormField, 'Nama Skill');
      final description = find.widgetWithText(TextFormField, 'Deskripsi Skill');
      await tester.enterText(name, 'Flutter');
      await tester.tap(find.byType(DropdownButtonFormField<SkillType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Software Development').last);
      await tester.pumpAndSettle();
      await tester.enterText(description, _skill['description']! as String);
      await _save(tester);
      expect(creates, 0);
      await _login(tester);
      expect(creates, 1);
      await _login(tester);
      expect(creates, 1);
      expect(tester.widget<TextFormField>(name).controller!.text, 'Flutter');
      expect(
        tester.widget<TextFormField>(description).controller!.text,
        _skill['description'],
      );

      await _save(tester);
      expect(creates, 2);
      expect(reads, 2);
      expect(find.text('Skill berhasil ditambahkan.'), findsOneWidget);
      await tester.tap(find.text('Flutter'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Edit Skill'));
      await tester.pumpAndSettle();
      await tester.enterText(name, 'Flutter dan Dart');
      await _save(tester);

      expect(updates, 1);
      expect(reads, 3);
      expect(logins, 2);
      expect(find.text('Flutter dan Dart'), findsOneWidget);
      expect(find.text('Skill berhasil diperbarui.'), findsOneWidget);
    },
  );
}
