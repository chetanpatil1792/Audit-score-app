import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../apiUrls/api_urls.dart';
import 'jwt_helper.dart';

class ApiClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl = ApiUrls.baseUrl;

  // ... (Token getting/saving methods remain the same) ...
  Future<String?> _getAccessToken() async =>
      await _storage.read(key: 'access_token');

  Future<String?> _getRefreshToken() async =>
      await _storage.read(key: 'refresh_token');

  Future<void> _saveTokens(String access, String refresh) async {
    await _storage.write(key: 'access_token', value: access);
    await _storage.write(key: 'refresh_token', value: refresh);
  }
  // ... (End of token getting/saving methods) ...


  Future<bool> _refreshToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null) return false;

    print('🔄 Attempting to refresh token...');
    final response = await _inner.post(
      Uri.parse(ApiUrls.refreshToken),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccess = data['token'] ?? data['access'];
      if (newAccess != null) {
        await _storage.write(key: 'access_token', value: newAccess);
        print('✅ Access token refreshed successfully');
        return true;
      }
      return false;
    } else {
      print('❌ Refresh token expired (${response.statusCode}) — Initiating logout.');
      try {
        JwtHelper.Logout();
        Get.snackbar(
            'Session Expired',
            'Your session has expired. Please log in again.',
            snackPosition: SnackPosition.TOP
        );
      } catch (e) {
        print('⚠️ Error during automatic logout (AuthController not found?): $e');
      }
      return false;
    }
  }

  // Helper function to safely copy the request for retrying
  http.BaseRequest _copyRequest(http.BaseRequest original) {
    if (original is http.Request) {
      final newRequest = http.Request(original.method, original.url)
        ..headers.addAll(original.headers)
        ..bodyBytes = original.bodyBytes; // Copy body for http.Request
      return newRequest;
    }
    throw Exception('Cannot automatically retry non-http.Request types (e.g., StreamedRequest)');
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // 1. Initial attempt
    String? token = await _getAccessToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
      print('📤 Adding Authorization header for initial call ✅');
      print('🔑 Access Token being used: $token');

    }

    http.StreamedResponse response = await _inner.send(request);

    // 2. Check for 401 Unauthorized
    if (response.statusCode == 401) {
      print('⚠️ Received 401 Unauthorized. Attempting refresh...');

      await response.stream.drain(); // Discard the response body stream

      final refreshed = await _refreshToken();

      if (refreshed) {
        final newToken = await _getAccessToken();
        final newRequest = _copyRequest(request);
        newRequest.headers['Authorization'] = 'Bearer $newToken';

        print('🔄 Retrying request with new token...');
        response = await _inner.send(newRequest);
      } else {
        return http.StreamedResponse(
            Stream.fromIterable([utf8.encode(jsonEncode({'message': 'Token refresh failed and user logged out'}))]),
            401,
            request: request,
            headers: {'content-type': 'application/json'}
        );
      }
    }

    return response;
  }
}