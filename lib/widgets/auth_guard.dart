import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;

  final loggedIn = await Navigator.push<bool>(
    context,
    MaterialPageRoute<bool>(builder: (_) => const LoginScreen()),
  );
  return loggedIn ?? false;
}

Future<void> logoutAndNotify(BuildContext context) async {
  await context.read<AuthState>().logout();
  if (!context.mounted) return;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(const SnackBar(content: Text('Kamu sudah logout.')));
}
