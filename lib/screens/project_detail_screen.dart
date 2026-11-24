import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Proyek')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (project.projectImageUrl.trim().isNotEmpty) ...[
                Image.network(
                  project.projectImageUrl,
                  height: 220,
                  fit: BoxFit.contain,
                  semanticLabel: 'Gambar proyek ${project.title}',
                  webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                  errorBuilder: (_, _, _) => const Center(
                    child: Text('Gambar proyek tidak tersedia.'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(project.title, style: textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text(project.description),
              const SizedBox(height: 16),
              Text('Tech Stack', style: textTheme.titleMedium),
              Text(project.techStack),
              if (project.projectUrl.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('Project URL', style: textTheme.titleMedium),
                SelectableText(project.projectUrl),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
