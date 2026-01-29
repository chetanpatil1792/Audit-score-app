import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';
import '../model/EmployeeResponse.dart';


class ProfileController extends GetxController {
  final ApiClient api = ApiClient();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

   var auditorData = AuditorProfile().obs;
  var isLoading = false.obs;



  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;

      final userInfoString = await secureStorage.read(key: 'user_info');
      if (userInfoString == null) {
        print('⚠️ No user_info found in secure storage');
        auditorData.value = AuditorProfile(); // empty model
        return;
      }

      final userInfo = jsonDecode(userInfoString);
      final userId = userInfo['employeeId'];

      final response = await api.get(Uri.parse("${ApiUrls.getUserData}$userId"));

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);

        final auditorResponse = AuditorResponse.fromJson(jsonMap);

        auditorData.value = auditorResponse.auditor ?? AuditorProfile();

        print('✅ Auditor profile loaded successfully: ${auditorData.value.firstName}');
      } else if (response.statusCode == 404) {
        print('⚠️ Auditor not found (404) — showing empty fields');
        auditorData.value = AuditorProfile();
      } else if (response.statusCode == 401) {
        print('⚠️ Unauthorized — token invalid or expired');
      } else {
        print('❌ Error fetching profile: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Exception in fetchUserData: $e');
      auditorData.value = AuditorProfile();
    } finally {
      isLoading.value = false;
    }
  }
}