import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/apiUrls/api_urls.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/token_helper.dart';

class DashboardController extends GetxController {
  var userName = ''.obs;
  var userLocation = ''.obs;
  var userImageUrl = ''.obs;
  var employeeId = 0.obs;

  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    getRiskAssessmentQuestions();
  }

  void loadUserData() {
    var userInfo = storage.read('userInfo') ?? {};

    userName.value = userInfo['userName'] ?? '';
    userLocation.value = userInfo['location'] ?? '';
    userImageUrl.value = userInfo['userImageUrl'] ?? '';
    employeeId.value = userInfo['employeeId'] ?? 0;
    getRiskAssessmentQuestions();
  }

  final _apiClient = ApiClient();


  var underProcessAudit = 0.obs;
  var yetToStartAudit = 0.obs;
  var completeAudit = 0.obs;


  Future<void> getRiskAssessmentQuestions() async {
    try {
      final uri = Uri.parse(ApiUrls.getTotalAuditDetails).replace(
        queryParameters: {'EmployeeId': '${employeeId.value}'},
      );

      final response = await _apiClient.get(uri);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List result = body['result'] ?? [];

        underProcessAudit.value = 0;
        yetToStartAudit.value = 0;
        completeAudit.value = 0;

        for (final item in result) {
          final status = item['status']?.toString().toLowerCase() ?? '';
          final count =
              int.tryParse(item['totalCount'].toString()) ?? 0;

          if (status == 'under process') {
            underProcessAudit.value = count;
          } else if (status == 'yet to start') {
            yetToStartAudit.value = count;
          } else if (status == 'completed') {
            completeAudit.value = count;
          }
        }
      } else {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
       Get.snackbar('Error', 'Check internet connection');
    }
  }

  String getInitials(String fullName) {
    fullName = fullName.trim();
    if (fullName.isEmpty) return '';

    List<String> names = fullName.split(' ').where((s) => s.isNotEmpty).toList();
    if (names.isEmpty) return '';

    if (names.length > 1) {
      return (names[0][0] + names.last[0]).toUpperCase();
    } else {
      return names[0][0].toUpperCase();
    }
  }
}
