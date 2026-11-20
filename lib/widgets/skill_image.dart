import 'package:material_ui/material_ui.dart';

class SkillImage extends StatelessWidget {
  const SkillImage({super.key, required this.previewUri});

  final Uri? previewUri;

  @override
  Widget build(BuildContext context) {
    const unavailable = Center(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'Pratinjau gambar tidak tersedia',
          textAlign: TextAlign.center,
        ),
      ),
    );
    final url = previewUri;

    return SizedBox(
      width: 320,
      height: 160,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: url == null
              ? unavailable
              : Image.network(
                  url.toString(),
                  fit: BoxFit.contain,
                  semanticLabel: 'Gambar skill',
                  webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (frame != null || wasSynchronouslyLoaded) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        semanticsLabel: 'Memuat gambar skill',
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => unavailable,
                ),
        ),
      ),
    );
  }
}
