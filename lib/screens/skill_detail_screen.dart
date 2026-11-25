import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/skill.dart';
import 'package:myportofolio_mobile/models/skill_image_url.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/skill_image.dart';
import 'package:provider/provider.dart';

class SkillDetailScreen extends StatelessWidget {
  const SkillDetailScreen({super.key, required this.skill});

  final Skill skill;

  Future<void> _edit(BuildContext context) async {
    final updated = await Navigator.of(context).push<Skill>(
      MaterialPageRoute<Skill>(builder: (_) => SkillFormPage(skill: skill)),
    );
    if (updated != null && context.mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final imageUri = skillImageUri(
      skill.imageFilename,
      context.read<ApiClient>().baseUrl,
    );
    final fields = {
      'Nama': skill.name,
      'Tipe': skill.skillType.label,
      'Deskripsi': skill.description,
      'Gambar': skill.imageFilename.isEmpty ? 'Tidak ada' : skill.imageFilename,
      'Jumlah bintang': skill.starCount.toString(),
      'Ditandai oleh pengguna saat ini': skill.isStarred ? 'Ya' : 'Tidak',
      'Pemberi bintang': skill.starredByNames.isEmpty
          ? 'Belum ada'
          : skill.starredByNames,
      'ID': skill.id ?? 'Tidak tersedia',
    };
    final labelStyle = Theme.of(context).textTheme.titleSmall;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Skill'),
        actions: [
          if (skill.id != null)
            IconButton(
              tooltip: 'Edit Skill',
              onPressed: () => _edit(context),
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (imageUri != null) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SkillImage(previewUri: imageUri),
                  ),
                  const SizedBox(height: 16),
                ],
                for (final field in fields.entries) ...[
                  Text(field.key, style: labelStyle),
                  SelectableText(field.value),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
