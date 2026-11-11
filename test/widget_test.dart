import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/item_card.dart';

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
      expect(cards, findsNWidgets(3));
      for (var i = 1; i < 3; i++) {
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
}
