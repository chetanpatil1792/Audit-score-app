import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';
import '../model/auditor_docket_list_response.dart';
import '../model/branch_response.dart';
import '../model/changesListRespnoseModel.dart';
import '../model/in_process_list_response.dart';

class AuditProcessController extends GetxController {
  String _getCurrentDateFormatted() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  final RxString assignDate = ''.obs;
  var selectedMonth = ''.obs;

  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December'
  ];

  RxList<Branch> branchList = <Branch>[].obs;
  Rx<Branch?> selectedBranch = Rx<Branch?>(null);

  final _apiClient = ApiClient();
  final _box = GetStorage();

  // Loading states for tables
  var isDocketListLoading = true.obs;
  var isInProcessListLoading = true.obs;
  var isInChangesListLoading = true.obs;

  void updateAssignDate(String newMonth) {
    if (newMonth.isEmpty) return;

    final currentYear = DateTime.now().year;
    final monthIndex = months.indexOf(newMonth) + 1;

    if (monthIndex > 0) {
      final firstDayOfMonth = DateTime(currentYear, monthIndex, 1);
      final formattedDate = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
      assignDate.value = formattedDate;
      print('Selected Month: $newMonth');
      print('New Assign Date (1st day): ${assignDate.value}');

      selectedBranch.value = null;
      branchList.clear(); // Clear old branches
      docketList.clear(); // Clear old dockets
      fetchBranchList();
    }
  }

  Future<void> fetchBranchList() async {
    final userInfoJson = _box.read('userInfo');
    if (userInfoJson == null) {
      Get.snackbar('Error', 'User data not found. Please log in again.', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
      return;
    }
    final userInfo = userInfoJson is String ? jsonDecode(userInfoJson) : userInfoJson;

    try {
      final uri = Uri.parse(ApiUrls.getBranchList).replace(queryParameters: {
        'AssignDate': assignDate.value,
        'EmployeeId': userInfo['employeeId'].toString(),
      });

      print('Fetching branch list from: $uri');

      final request = http.Request('GET', uri);
      final streamedResponse = await _apiClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        final data = BranchResponse.fromJson(jsonMap);

        branchList.assignAll(data.data);

        print('✅ Successfully fetched ${data.data.length} branches.');
      }
      else {
        branchList.clear();
        print('❌ Failed to fetch branches. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception in fetchBranchList: $e');
      branchList.clear();
    }
  }

  var isStartingAudit = false.obs;


  void showConfirmation({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    Get.defaultDialog(
      title: title,
      middleText: message,
      textCancel: 'No',
      textConfirm: 'Yes',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        onConfirm();
      },
    );
  }

  void handleActionSelection(String action, Map<String, String> row) {
    switch (action) {
      case 'Start Audit':
        showConfirmation(
          title: 'Confirmation',
          message: 'Are you sure you want to start the audit?',
          onConfirm: () => startAuditApi(row),
        );
        break;

      // case 'Reschedule Audit':
      //   showConfirmation(
      //     title: 'Confirmation',
      //     message: 'Are you sure you want to reschedule the audit?',
      //     onConfirm: () => rescheduleAuditApi(row),
      //   );
      //   break;
      case 'Reschedule Audit':
        showReschedulePopup(row); // ✅ changed only this
        break;

      case 'Cancel Audit':
        showConfirmation(
          title: 'Confirmation',
          message: 'Are you sure you want to cancel the audit?',
          onConfirm: () => cancelAuditApi(row),
        );
        break;
    }
  }

// ================= DATE FORMATTER =================
  String formatDateYYYYMMDD(DateTime date) {
    final yyyy = date.year.toString();
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return "$yyyy-$mm-$dd"; // ✅ YYYY-MM-DD
  }

// ================= DATE PICKER =================
  Future<String?> pickDate(
      BuildContext context, {
        required DateTime initialDate,
      }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple, // premium accent
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return null;
    return formatDateYYYYMMDD(picked);
  }

// ================= RESCHEDULE POPUP =================
  void showReschedulePopup(Map<String, String> row) {
    final now = DateTime.now();
    final startDate = now;
    final endDate = now.add(const Duration(days: 2));

    final rescheduleStartCtrl =
    TextEditingController(text: formatDateYYYYMMDD(startDate));
    final rescheduleEndCtrl =
    TextEditingController(text: formatDateYYYYMMDD(endDate));

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Reschedule Audit",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              /// Reschedule Start Date
              TextField(
                controller: rescheduleStartCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Reschedule Start Date",
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onTap: () async {
                  final date = await pickDate(
                    Get.context!,
                    initialDate: startDate,
                  );
                  if (date != null) {
                    rescheduleStartCtrl.text = date;
                  }
                },
              ),

              const SizedBox(height: 14),

              /// Reschedule End Date
              TextField(
                controller: rescheduleEndCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Reschedule End Date",
                  prefixIcon: const Icon(Icons.event),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onTap: () async {
                  final date = await pickDate(
                    Get.context!,
                    initialDate: endDate,
                  );
                  if (date != null) {
                    rescheduleEndCtrl.text = date;
                  }
                },
              ),

              const SizedBox(height: 22),

              /// Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      row['RescheduleStartDate'] =
                          rescheduleStartCtrl.text;
                      row['RescheduleEndDate'] =
                          rescheduleEndCtrl.text;

                      Get.back();
                      rescheduleAuditApi(row);
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  var isAuditActionLoading = false.obs;

  Future<void> startAuditApi(Map<String, String> row) async {
    isAuditActionLoading.value = true;

    try {
      final uri = Uri.parse(ApiUrls.startAudit).replace(queryParameters: {
        'DocketId': row['DocketId'] ?? '',
        'IsAuditActive': '1',
      });

      final request = http.Request('POST', uri); // ✅ POST
      final streamedResponse = await _apiClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        final result = jsonMap["data"]?[0];

        final id = result?["id"]?.toString() ?? "0";
        final msg = result?["returnMSG"] ?? "Something went wrong";

        Get.snackbar(
          id != "0" ? "Success" : "Failed",
          msg,
          colorText: Colors.white,
          backgroundColor: id != "0" ? Colors.green : Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      await getDocketAuditorList();
      await getInProcessList();
      isAuditActionLoading.value = false;
    }
  }

  Future<void> rescheduleAuditApi(Map<String, String> row) async {
    isAuditActionLoading.value = true;

    try {
      final uri = Uri.parse(ApiUrls.rescheduleAudit).replace(queryParameters: {
        'AssignDate': row['AssignDate'] ?? '',
        'AuditStartDate': row['StartDate'] ?? '',
        'AuditEndDate': row['EndDate'] ?? '',
        'DocketId': row['DocketId'] ?? '0',
        'IsAuditReschedule': '1',
        'RescheduleStartDate': row['RescheduleStartDate'] ?? '',
        'RescheduleEndDate': row['RescheduleEndDate'] ?? '',
      });
      print("#####################################$uri");

      final request = http.Request('POST', uri); // ✅ POST
      final streamedResponse = await _apiClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      final decoded = jsonDecode(response.body);
      print("########!!!!!#$decoded");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print("########!!!!!#$decoded");

        final List dataList = decoded["data"] ?? [];

        String id = "0";
        String msg = "Failed";

        if (dataList.isNotEmpty) {
          id = dataList[0]["id"]?.toString() ?? "0";
          msg = dataList[0]["returnMSG"] ?? "Failed";
        }

        final bool isSuccess =
            decoded["success"] == true && id != "0" && msg != "AlreadyRescheduled";

        Get.snackbar(
          isSuccess ? "Success" : "Failed",
          msg,
          colorText: Colors.white,
          backgroundColor: isSuccess ? Colors.green : Colors.orange,
        );
      }

    } catch (e) {
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      await getDocketAuditorList();
      await getInProcessList();
      isAuditActionLoading.value = false;
    }
  }

  Future<void> cancelAuditApi(Map<String, String> row) async {
    isAuditActionLoading.value = true;

    try {
      final uri = Uri.parse(ApiUrls.cancelAudit).replace(queryParameters: {
        'DocketId': row['DocketId'] ?? '0',
        'IsAuditCancel': '1',
        'Remark': row['CancelRemark'] ?? 'Audit cancelled',
      });

      final request = http.Request('POST', uri); // ✅ POST
      final streamedResponse = await _apiClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body)["result"]?[0];
        final id = result?["id"]?.toString() ?? "0";
        final msg = result?["returnMSG"] ?? "";

        Get.snackbar(
          id != "0" ? "Success" : "Failed",
          msg,
          colorText: Colors.white,
          backgroundColor: id != "0" ? Colors.green : Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      await getDocketAuditorList();
      await getInProcessList();
      isAuditActionLoading.value = false;
    }
  }


  Future<void> getDocketAuditorList() async {
      final userInfoJson = _box.read('userInfo');
      final userInfo = userInfoJson is String ? jsonDecode(userInfoJson) : userInfoJson;

      if (selectedBranch.value == null) {
      docketList.clear();
      return;
    }

    isDocketListLoading.value = true;
    try {
      final assignDate = this.assignDate.value;
      final branchId = selectedBranch.value!.branchId.toString();
      final uri = Uri.parse(ApiUrls.docketAuditorList).replace(queryParameters: {
        'AssignDate': assignDate,
        'BranchId': branchId,
        'EmployeeId': userInfo['employeeId'].toString(),
      });

      print('Fetching docket list from: $uri');
      final request = http.Request('GET', uri);
      final streamedResponse = await _apiClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final res = auditorDocketListResponseFromJson(response.body);
        docketList.assignAll(res.data);
        print('✅ Successfully fetched ${res.data.length} dockets.');
      }
      else {
        docketList.clear();
        print('❌ Failed to fetch dockets. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception in getDocketAuditorList: $e');
      docketList.clear();
    } finally {
      isDocketListLoading.value = false;
    }
  }

  Future<void> getInProcessList() async {
    isInProcessListLoading.value = true;
    try {
      final assignDate = this.assignDate.value;
      final branchId = selectedBranch.value!.branchId.toString();
      final uri = Uri.parse(ApiUrls.inProcessList).replace(queryParameters: {
        'AssignDate': assignDate,
        'BranchId': branchId,
        'EmployeeId': '0',
      });
      print('Fetching in-process list from: $uri');

      final request = http.Request('GET', uri);
      final streamedResponse = await _apiClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final res = inProcessListResponseFromJson(response.body);
        inProcessList.assignAll(res.data);
        print('✅ Successfully fetched ${res.data.length} in-process items.');
      }
      else {
        inProcessList.clear();
        print('❌ Failed to fetch in-process items. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception in getInProcessList: $e');
      inProcessList.clear();
    } finally {
      isInProcessListLoading.value = false;
    }
  }

  RxList<DocketAuditor> docketList = <DocketAuditor>[].obs;
  RxList<InProcessItem> inProcessList = <InProcessItem>[].obs;

  RxList<EmployeeResult> changesList = <EmployeeResult>[].obs;

  Future<void> getInChangesList() async {
    isInChangesListLoading.value = true;
    try {
      final assignDate = this.assignDate.value;
      final branchId = selectedBranch.value!.branchId.toString();
      final uri = Uri.parse(ApiUrls.changesList).replace(queryParameters: {
        'AssignDate': assignDate,
        'BranchId': branchId,
        'EmployeeId': '0',
      });
      final request = http.Request('GET', uri);
      final streamedResponse = await _apiClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final res = apiResponseFromJson(response.body);

        // Agar res.result null hua toh empty list assign ho jayegi bina crash kiye
        changesList.assignAll(res.result ?? []);

        print('✅ Successfully fetched changes ${changesList.length} items.');
      }else {
        changesList.clear();
        print('❌ API Error: Status Code ${response.statusCode}');
       }

    } catch (e) {
      print('❌ Exception in getInProcessList: $e');
      changesList.clear();
    } finally {
      isInChangesListLoading.value = false;
    }
  }



  @override
  void onInit() {
    super.onInit();
    assignDate.value = _getCurrentDateFormatted();

    final currentMonthIndex = DateTime.now().month - 1;
    if (currentMonthIndex >= 0 && currentMonthIndex < months.length) {
      selectedMonth.value = months[currentMonthIndex];
    }

    fetchBranchList();
    getInProcessList();
    getInChangesList();

    // When the selected branch changes, fetch the docket list.
    ever(selectedBranch, (_) => getDocketAuditorList());
    ever(selectedBranch, (_) => getInProcessList());
    ever(selectedBranch, (_) => getInChangesList());
  }
}
