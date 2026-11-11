import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileSheet extends StatefulWidget {
  const ProfileSheet({super.key, required this.name, required this.className});

  final String name;
  final String className;

  @override
  State<ProfileSheet> createState() => _ProfileSheetState();
}

enum _CopyStatus { idle, copying, copied, failed }

class _ProfileSheetState extends State<ProfileSheet> {
  _CopyStatus _copyStatus = _CopyStatus.idle;

  Future<void> _copyProfile() async {
    setState(() => _copyStatus = _CopyStatus.copying);

    var result = _CopyStatus.copied;
    try {
      await Clipboard.setData(
        ClipboardData(text: '${widget.name}\n${widget.className}'),
      );
    } on PlatformException {
      result = _CopyStatus.failed;
    }

    // The user can dismiss the sheet while the platform writes the clipboard.
    if (!mounted) return;
    setState(() => _copyStatus = result);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final feedback = switch (_copyStatus) {
      _CopyStatus.copied => 'Profil disalin.',
      _CopyStatus.failed => 'Profil gagal disalin. Coba lagi.',
      _ => null,
    };

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Ringkasan profil', style: textTheme.titleLarge),
                ),
                IconButton(
                  tooltip: 'Tutup profil',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(widget.name, style: textTheme.titleMedium),
            Text(widget.className),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _copyStatus == _CopyStatus.copying
                  ? null
                  : _copyProfile,
              icon: const Icon(Icons.copy_outlined),
              label: const Text('Salin profil'),
            ),
            if (feedback != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Semantics(
                  liveRegion: true,
                  child: Text(feedback, textAlign: TextAlign.center),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
