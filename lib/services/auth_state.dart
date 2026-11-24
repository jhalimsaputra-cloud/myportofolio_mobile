import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/services/api_client.dart';

class AuthState extends ChangeNotifier {
  AuthState(this._apiClient, {String? initialToken}) : _token = initialToken;

  final ApiClient _apiClient;
  String? _token;

  String? get token => _token;
  bool get isLoggedIn => _token != null;

  Future<void> login(String username, String password) async {
    _token = await _apiClient.obtainToken(username, password);
    notifyListeners();
  }

  Future<void> logout() async {
    final current = _token;
    if (current == null) return;
    try {
      await _apiClient.logout(token: current);
    } on ApiException {
      // A rejected or expired token still needs to be cleared locally.
    } on http.ClientException {
      // Local logout also works when the backend cannot be reached.
    } finally {
      if (_token == current) {
        _token = null;
        notifyListeners();
      }
    }
  }
}
