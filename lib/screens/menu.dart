import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/profile_sheet.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  static const _npm = '2506549386';
  static const _name = 'Justin Evan Halim Saputra';
  static const _className = 'PBP B';

  // Dark backgrounds keep the white icon and label readable on every card.
  static const _viewProjects = ItemHomepage(
    'Lihat Proyek',
    Icons.folder,
    Color(0xFF1E40AF),
  );
  static const _addProject = ItemHomepage(
    'Tambah Proyek',
    Icons.add_circle,
    Color(0xFF166534),
  );
  static const _addSkill = ItemHomepage(
    'Tambah Skill',
    Icons.psychology_outlined,
    Color(0xFF5B21B6),
  );
  static const _logout = ItemHomepage(
    'Logout',
    Icons.logout,
    Color(0xFF991B1B),
  );
  static const _login = ItemHomepage('Login', Icons.login, Color(0xFF374151));

  Future<void> _openProjectForm(BuildContext context) async {
    if (!await ensureLoggedIn(context) || !context.mounted) return;
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const ProjectFormPage()),
    );
  }

  void _openSkillForm(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const SkillFormPage()),
    );
  }

  void _showProfile(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          const ProfileSheet(name: _name, className: _className),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        actions: [
          IconButton(
            tooltip: 'Profil',
            onPressed: () => _showProfile(context),
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      drawer: const LeftDrawer(),
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
                      ItemCard(
                        item: _viewProjects,
                        onTap: () => Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const ProjectListScreen(),
                          ),
                        ),
                      ),
                      ItemCard(
                        item: _addProject,
                        onTap: () => _openProjectForm(context),
                      ),
                      ItemCard(
                        item: _addSkill,
                        onTap: () => _openSkillForm(context),
                      ),
                      ItemCard(
                        item: isLoggedIn ? _logout : _login,
                        onTap: () {
                          if (isLoggedIn) {
                            logoutAndNotify(context);
                          } else {
                            ensureLoggedIn(context);
                          }
                        },
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
