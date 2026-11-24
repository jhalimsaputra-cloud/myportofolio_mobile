import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _techStack = TextEditingController();
  final _projectUrl = TextEditingController();
  final _projectImageUrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _techStack.dispose();
    _projectUrl.dispose();
    _projectImageUrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    final auth = context.read<AuthState>();
    final api = context.read<ApiClient>();
    Project? created;

    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final token = auth.token;
      if (token == null) return;

      created = await api.createProject(
        Project(
          title: _title.text.trim(),
          description: _description.text.trim(),
          techStack: _techStack.text.trim(),
          projectUrl: _projectUrl.text.trim(),
          projectImageUrl: _projectImageUrl.text.trim(),
        ),
        token: token,
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        await auth.logout();
        if (!mounted) return;
        _showMessage('Sesi berakhir. Silakan login kembali untuk menyimpan.');
        await ensureLoggedIn(context);
      } else {
        final message = switch (error.statusCode) {
          400 => 'Periksa kembali data proyek.',
          403 => 'Akun ini tidak memiliki izin untuk menambahkan proyek.',
          _ => 'Coba lagi dalam beberapa saat.',
        };
        _showMessage('Gagal menyimpan proyek (${error.statusCode}). $message');
      }
    } on Exception {
      if (mounted) _showMessage('Gagal terhubung ke server. Coba lagi.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }

    final savedProject = created;
    if (!mounted || savedProject == null) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Proyek berhasil ditambahkan!'),
        content: Text(savedProject.title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    _title.clear();
    _description.clear();
    _techStack.clear();
    _projectUrl.clear();
    _projectImageUrl.clear();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String? _requiredText(String? value) =>
      value == null || value.trim().isEmpty ? 'Kolom ini wajib diisi.' : null;

  String? _validateUrl(String? value, {bool optional = false}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return optional ? null : 'URL proyek wajib diisi.';

    final url = Uri.tryParse(text);
    if (url == null ||
        (url.scheme != 'https' && url.scheme != 'http') ||
        url.host.isEmpty ||
        url.userInfo.isNotEmpty ||
        RegExp(r'\s').hasMatch(text)) {
      return 'Masukkan URL yang dimulai dengan http:// atau https://.';
    }
    return null;
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required FormFieldValidator<String> validator,
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        enabled: !_isSubmitting,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project Form'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(isProjectForm: true),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _field(
                  controller: _title,
                  label: 'Title',
                  maxLength: 255,
                  validator: _requiredText,
                ),
                _field(
                  controller: _description,
                  label: 'Description',
                  maxLines: 5,
                  validator: _requiredText,
                ),
                _field(
                  controller: _techStack,
                  label: 'Tech Stack',
                  maxLength: 255,
                  validator: _requiredText,
                ),
                _field(
                  controller: _projectUrl,
                  label: 'Project URL',
                  maxLength: 200,
                  keyboardType: TextInputType.url,
                  validator: _validateUrl,
                ),
                _field(
                  controller: _projectImageUrl,
                  label: 'Project Image URL (Optional)',
                  maxLength: 500,
                  keyboardType: TextInputType.url,
                  validator: (value) => _validateUrl(value, optional: true),
                ),
                FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
