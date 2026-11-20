final _driveFileId = RegExp(r'^[A-Za-z0-9_-]+$');
final _urlWhitespace = RegExp(r'\s');

/// Resolves an image URL or a shared Google Drive file URL for display.
Uri? skillImagePreviewUri(String input) {
  final text = input.trim();
  final uri = Uri.tryParse(text);
  if (uri == null ||
      (uri.scheme != 'https' && uri.scheme != 'http') ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      _urlWhitespace.hasMatch(text)) {
    return null;
  }

  if (uri.host != 'drive.google.com') return uri;

  final segments = uri.pathSegments;
  final String? id;
  if (segments.length >= 3 && segments[0] == 'file' && segments[1] == 'd') {
    id = segments[2];
  } else if (uri.path == '/open' ||
      uri.path == '/uc' ||
      uri.path == '/thumbnail') {
    id = uri.queryParameters['id'];
  } else {
    return null;
  }
  if (id == null || !_driveFileId.hasMatch(id)) return null;

  final resourceKey = uri.queryParameters['resourcekey'];
  return Uri.https('drive.google.com', '/thumbnail', {
    'id': id,
    'sz': 'w800',
    if (resourceKey != null && resourceKey.isNotEmpty)
      'resourcekey': resourceKey,
  });
}
