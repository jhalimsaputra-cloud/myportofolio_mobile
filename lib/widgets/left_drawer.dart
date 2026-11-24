import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    super.key,
    this.isProjectForm = false,
    this.isSkillForm = false,
  });

  final bool isProjectForm;
  final bool isSkillForm;

  Future<void> _openForm(
    BuildContext context, {
    required bool isCurrentForm,
    required WidgetBuilder builder,
    bool requiresLogin = false,
  }) async {
    final screenContext = Scaffold.of(context).context;
    final navigator = Navigator.of(screenContext);
    navigator.pop();
    if (isCurrentForm) return;

    if (requiresLogin && !await ensureLoggedIn(screenContext)) return;
    if (!screenContext.mounted) return;

    final route = MaterialPageRoute<void>(builder: builder);
    if (isProjectForm || isSkillForm) {
      navigator.pushReplacement<void, void>(route);
    } else {
      navigator.push<void>(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        children: [
          ColoredBox(
            color: Colors.indigo,
            child: SafeArea(
              bottom: false,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 160),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Portfolio',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Explore personal projects and experiences!',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              navigator.popUntil((route) => route.isFirst);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            onTap: () => _openForm(
              context,
              isCurrentForm: isProjectForm,
              builder: (_) => const ProjectFormPage(),
              requiresLogin: true,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.psychology_outlined),
            title: const Text('Add Skill'),
            onTap: () => _openForm(
              context,
              isCurrentForm: isSkillForm,
              builder: (_) => const SkillFormPage(),
            ),
          ),
          ListTile(
            leading: Icon(isLoggedIn ? Icons.logout : Icons.login),
            title: Text(isLoggedIn ? 'Logout' : 'Login'),
            onTap: () {
              final screenContext = Scaffold.of(context).context;
              Navigator.pop(screenContext);
              if (isLoggedIn) {
                logoutAndNotify(screenContext);
              } else {
                ensureLoggedIn(screenContext);
              }
            },
          ),
        ],
      ),
    );
  }
}
