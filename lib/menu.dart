import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/item_card.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  static const _npm = '2506549386';
  static const _name = 'Justin Evan Halim Saputra';
  static const _className = 'PBP B';

  // Dark backgrounds keep the white icon and label readable on every card.
  static const _items = [
    ItemHomepage('Lihat Proyek', Icons.folder, Color(0xFF1E40AF)),
    ItemHomepage('Tambah Proyek', Icons.add_circle, Color(0xFF166534)),
    ItemHomepage('Logout', Icons.logout, Color(0xFF991B1B)),
  ];

  void _showItemMessage(BuildContext context, ItemHomepage item) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Kamu telah menekan tombol ${item.name}!')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _CardGroup(
                    children: [
                      InfoCard(title: 'NPM', content: _npm),
                      InfoCard(title: 'Name', content: _name),
                      InfoCard(title: 'Class', content: _className),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Selamat datang di MyPortfolio Mobile!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _CardGroup(
                    children: [
                      for (final item in _items)
                        ItemCard(
                          item: item,
                          onTap: () => _showItemMessage(context, item),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardGroup extends StatelessWidget {
  const _CardGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    const gap = 12.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use the available content width so long names and labels have room
        // to wrap. Both groups share the page's vertical scroll.
        final width = constraints.maxWidth;
        final columns = width < 600 ? 1 : 3;
        final cardWidth = (width - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final card in children)
              SizedBox(width: cardWidth, child: card),
          ],
        );
      },
    );
  }
}
