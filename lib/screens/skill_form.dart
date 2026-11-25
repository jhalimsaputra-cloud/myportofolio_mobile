import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/skill.dart';
import 'package:myportofolio_mobile/models/skill_image_url.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/skill_image.dart';
import 'package:provider/provider.dart';

class SkillFormPage extends StatefulWidget {
  const SkillFormPage({super.key, this.skill, this.showDrawer = true});

  final Skill? skill;
  final bool showDrawer;

  @override
  State<SkillFormPage> createState() => _SkillFormPageState();
}

class _SkillFormPageState extends State<SkillFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _imageUrl = TextEditingController();
  Timer? _previewTimer;
  Uri? _livePreviewUri;
  SkillType? _skillType;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final skill = widget.skill;
    if (skill == null) return;
    _name.text = skill.name;
    _description.text = skill.description;
    _imageUrl.text = skill.imageFilename;
    _skillType = skill.skillType;
    _livePreviewUri = _previewUri(skill.imageFilename);
  }

  @override
  void dispose() {
    _previewTimer?.cancel();
    _name.dispose();
    _description.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  void _updateImagePreview(String value) {
    _previewTimer?.cancel();
    final previewUri = _previewUri(value.trim());
    if (previewUri == _livePreviewUri) return;

    if (previewUri == null) {
      setState(() => _livePreviewUri = null);
      return;
    }

    _previewTimer = Timer(const Duration(milliseconds: 350), () {
      setState(() => _livePreviewUri = previewUri);
    });
  }

  Uri? _previewUri(String value) {
    if (value.isNotEmpty && value == widget.skill?.imageFilename) {
      return skillImageUri(value, context.read<ApiClient>().baseUrl);
    }
    return skillImagePreviewUri(value);
  }

  String? _imageForServer(String value) {
    if (value.isEmpty || value == widget.skill?.imageFilename) return value;
    return skillImagePreviewUri(value)?.toString();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (_isSubmitting || form == null || !form.validate()) return;

    FocusScope.of(context).unfocus();
    final draft = Skill(
      name: _name.text.trim(),
      skillType: _skillType!,
      description: _description.text.trim(),
      imageFilename: _imageForServer(_imageUrl.text.trim())!,
    );
    final auth = context.read<AuthState>();
    final api = context.read<ApiClient>();
    final original = widget.skill;
    setState(() => _isSubmitting = true);
    String? token;
    Skill? saved;

    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      token = auth.token;
      if (token == null) return;
      saved = original == null
          ? await api.createSkill(draft, token: token)
          : await api.updateSkill(original, draft, token: token);
    } on ApiException catch (error) {
      if (error.statusCode == 401 && token != null) {
        auth.clearRejectedToken(token);
      }
      if (!mounted) return;
      if (error.statusCode == 401) {
        _showMessage('Sesi berakhir. Silakan login kembali, lalu simpan lagi.');
        await ensureLoggedIn(context);
      } else {
        _showMessage(switch (error.statusCode) {
          400 => 'Data skill ditolak. Periksa kembali isian.',
          403 => 'Akun ini tidak memiliki izin untuk menyimpan skill.',
          404 => 'Skill ini sudah tidak tersedia.',
          _ => 'Gagal menyimpan skill (${error.statusCode}). Coba lagi.',
        });
      }
    } on FormatException {
      if (mounted) _showUnreadableResponse();
    } on TypeError {
      if (mounted) _showUnreadableResponse();
    } on Exception {
      if (mounted) _showMessage('Gagal terhubung ke server. Coba lagi.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }

    if (!mounted || saved == null) return;
    _showMessage(
      original == null
          ? 'Skill berhasil ditambahkan.'
          : 'Skill berhasil diperbarui.',
    );
    Navigator.of(context).pop(saved);
  }

  void _showUnreadableResponse() {
    _showMessage('Respons server tidak dapat dibaca. Periksa daftar skill.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const border = OutlineInputBorder();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.skill == null ? 'Tambah Skill' : 'Edit Skill'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      drawer: widget.showDrawer && widget.skill == null
          ? const LeftDrawer(isSkillForm: true)
          : null,
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
                      enabled: !_isSubmitting,
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
                    DropdownButtonFormField<SkillType>(
                      initialValue: _skillType,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Tipe Skill',
                        border: border,
                      ),
                      items: [
                        for (final type in SkillType.values)
                          DropdownMenuItem(
                            value: type,
                            child: Text(type.label),
                          ),
                      ],
                      onChanged: _isSubmitting
                          ? null
                          : (value) => _skillType = value,
                      validator: (value) =>
                          value == null ? 'Pilih tipe skill.' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _description,
                      enabled: !_isSubmitting,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi Skill',
                        alignLabelWithHint: true,
                        border: border,
                      ),
                      minLines: 3,
                      maxLines: 5,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Deskripsi skill wajib diisi.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _imageUrl,
                      enabled: !_isSubmitting,
                      decoration: const InputDecoration(
                        labelText: 'URL Gambar (opsional)',
                        helperText:
                            'Tempel URL gambar atau link file Google Drive.',
                        helperMaxLines: 2,
                        errorMaxLines: 2,
                        border: border,
                      ),
                      keyboardType: TextInputType.url,
                      autocorrect: false,
                      onChanged: _updateImagePreview,
                      validator: (value) {
                        final image = _imageForServer(value?.trim() ?? '');
                        if (image == null) {
                          return 'Masukkan URL gambar atau link file Drive yang valid.';
                        }
                        if (image.runes.length > 200) {
                          return 'URL gambar maksimal 200 karakter.';
                        }
                        return null;
                      },
                    ),
                    if (_livePreviewUri != null) ...[
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SkillImage(previewUri: _livePreviewUri),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                semanticsLabel: 'Menyimpan skill',
                              ),
                            )
                          : const Text('Simpan'),
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
