import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/skill.dart';
import 'package:myportofolio_mobile/screens/skill_detail_screen.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class SkillListScreen extends StatefulWidget {
  const SkillListScreen({super.key});

  @override
  State<SkillListScreen> createState() => _SkillListScreenState();
}

class _SkillListScreenState extends State<SkillListScreen> {
  late Future<List<Skill>> _skills;

  @override
  void initState() {
    super.initState();
    _skills = context.read<ApiClient>().getSkills();
  }

  Future<void> _reload() async {
    final request = context.read<ApiClient>().getSkills();
    setState(() {
      _skills = request;
    });
    try {
      await request;
    } catch (_) {
      // FutureBuilder displays the failure.
    }
  }

  Future<void> _createSkill() async {
    final created = await Navigator.of(context).push<Skill>(
      MaterialPageRoute<Skill>(
        builder: (_) => const SkillFormPage(showDrawer: false),
      ),
    );
    if (created != null && mounted) await _reload();
  }

  Future<void> _showDetail(Skill skill) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => SkillDetailScreen(skill: skill)),
    );
    if (updated == true && mounted) await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Skill')),
      drawer: LeftDrawer(isSkillList: true, onAddSkill: _createSkill),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah Skill',
        onPressed: _createSkill,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Skill>>(
        future: _skills,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Memuat daftar skill',
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Gagal memuat daftar skill.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final skills = snapshot.data ?? const <Skill>[];
          return RefreshIndicator(
            onRefresh: _reload,
            child: skills.isEmpty
                ? const CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text('Belum ada skill.')),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
                    itemCount: skills.length,
                    itemBuilder: (context, index) {
                      final skill = skills[index];
                      return Card(
                        child: ListTile(
                          title: Text(skill.name),
                          subtitle: Text(
                            '${skill.skillType.label}\n${skill.description}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _showDetail(skill),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
