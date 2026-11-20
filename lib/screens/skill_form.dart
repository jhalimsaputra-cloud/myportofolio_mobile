import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/skill_image_url.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/skill_image.dart';

class SkillFormPage extends StatefulWidget {
  const SkillFormPage({super.key});

  @override
  State<SkillFormPage> createState() => _SkillFormPageState();
}

class _SkillFormPageState extends State<SkillFormPage> {
  static const _typeLabels = {
    'Software': 'Software Development',
    'Systems': 'Systems & Architecture',
  };

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _imageUrl = TextEditingController();
  String? _skillType;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  void _showSummary() {
    if (_formKey.currentState?.validate() != true) return;

    FocusScope.of(context).unfocus();
    final name = _name.text.trim();
    final description = _description.text.trim();
    final imageUrl = _imageUrl.text.trim();
    final typeLabel = _typeLabels[_skillType]!;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ringkasan Skill'),
        scrollable: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageUrl.isNotEmpty) ...[
              SkillImage(previewUri: skillImagePreviewUri(imageUrl)),
              const SizedBox(height: 16),
            ],
            SelectableText('Nama Skill: $name'),
            const SizedBox(height: 8),
            Text('Tipe Skill: $typeLabel'),
            const SizedBox(height: 8),
            SelectableText('Deskripsi: $description'),
            const SizedBox(height: 8),
            SelectableText(
              imageUrl.isEmpty
                  ? 'URL Gambar: Tidak diisi'
                  : 'URL Gambar: $imageUrl',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const border = OutlineInputBorder();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Skill'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        leading: const BackButton(),
        actions: [
          Builder(
            builder: (context) => IconButton(
              tooltip: 'Buka menu navigasi',
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
            ),
          ),
        ],
      ),
      drawer: const LeftDrawer(isSkillForm: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        labelText: 'Nama Skill',
                        hintText: 'Contoh: Flutter',
                        border: border,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final name = value?.trim() ?? '';
                        if (name.isEmpty) return 'Nama skill wajib diisi.';
                        if (name.runes.length > 100) {
                          return 'Nama skill maksimal 100 karakter.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Tipe Skill',
                        border: border,
                      ),
                      items: [
                        for (final type in _typeLabels.entries)
                          DropdownMenuItem(
                            value: type.key,
                            child: Text(type.value),
                          ),
                      ],
                      onChanged: (value) => _skillType = value,
                      validator: (value) => _typeLabels.containsKey(value)
                          ? null
                          : 'Pilih tipe skill.',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _description,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi Skill',
                        alignLabelWithHint: true,
                        border: border,
                      ),
                      minLines: 3,
                      maxLines: 5,
                      validator: (value) => value == null || value.trim().isEmpty
                          ? 'Deskripsi skill wajib diisi.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _imageUrl,
                      decoration: const InputDecoration(
                        labelText: 'URL Gambar (opsional)',
                        helperText: 'Tempel URL gambar atau link file Google Drive.',
                        helperMaxLines: 2,
                        errorMaxLines: 2,
                        border: border,
                      ),
                      keyboardType: TextInputType.url,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return null;
                        return skillImagePreviewUri(value) == null
                            ? 'Masukkan URL gambar atau link file Drive yang valid.'
                            : null;
                      },
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _showSummary,
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
