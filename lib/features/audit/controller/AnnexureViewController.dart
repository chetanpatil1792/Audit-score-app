import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';
import '../model/inprocesListForAuditor.dart';
import '../model/risk_assessment_question_response.dart';
import '../view/dynamic_annexure_form_page.dart';

class AnnexureViewController extends GetxController {

  RxMap<String, dynamic> annexureData = <String, dynamic>{}.obs;

  var annexureIdForSubmit = 0.obs;
  var riskAssessmentQuestionId = 0.obs;

  void setAnnexureData(Map<String, dynamic> data) {
     annexureData.assignAll(data);

    print('Submitting Data: $annexureData');

     saveDynamicAnnexure(
      annexureData: annexureData.value,
    );
  }

  Future<void> saveDynamicAnnexure({
    required Map<String, dynamic> annexureData,
  }) async
  {
     final rows = [
      annexureData.entries.map((entry) {
        return {
          "name": entry.key,       // space / slash / case same rahe
          "value": entry.value.toString(),
        };
      }).toList()
    ];

    final body = {
      "annexureId": annexureIdForSubmit.value,
      "productId": selectedProductId.value,
      "docketNumber": selectedDocketId.value,
      "riskAssessmentQuestionId": riskAssessmentQuestionId.value,
      "rows": rows,
    };

    print("Submitting Data: $annexureData");
    print("API Body: $body");
     print("API URL: ${ApiUrls.annexureSave}");

    try {
      final response = await _apiClient.post(
        Uri.parse(ApiUrls.annexureSave),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['result'] != 0) {
          print("✅ Annexure Saved Successfully: ${data['result']}");
          Get.snackbar(
            "Success",
            "Annexure saved successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          print("❌ API returned result 0");
          Get.snackbar(
            "Error",
            "Failed to save annexure",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        print("❌ Server Error: ${response.body}");
      }
    } catch (e) {
      print("❌ API call failed: $e");
    }
  }

  RxList<dynamic> annexureHeaders = <dynamic>[].obs;

  Future<void> getAnnexureHeaders(int annexureId) async {
    try {
      isLoadingHeaders.value = true;
      final uri = Uri.parse(ApiUrls.getAnnexureHeaders).replace(
          queryParameters: {
            'AnnexureId': annexureId.toString(),
          });
      final response = await _apiClient.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          annexureHeaders.assignAll(data['data'] as List);
          if (annexureHeaders.isNotEmpty) {
            Get.to(() => DynamicAnnexureFormPage(formFields: annexureHeaders));
          }
        }
      }
    } catch (e) {
      print('❌ getAnnexureHeaders Error: $e');
    } finally {
      isLoadingHeaders.value = false;
    }
  }


  var selectedProductId = 0.obs;
  var selectedDocketId = 0.obs;
  var selectedDocketName = ''.obs;

  RxList<InProcessItemAuditor> inProcessList = <InProcessItemAuditor>[].obs;
  Rx<InProcessItemAuditor?> selectedDocket = Rx<InProcessItemAuditor?>(null);

  void onDocketChanged(InProcessItemAuditor? docket) {
    if (docket == null) {
      selectedProductId.value = 0;
      selectedDocketId.value = 0;
      selectedDocketName.value = '';
      selectedDocket.value = null;
      return;
    }
    selectedDocket.value = docket;
    selectedProductId.value = docket.productId ?? 0;
    selectedDocketId.value = docket.id ?? 0;
    selectedDocketName.value = docket.docketNumber ?? '';
    getRiskAssessmentQuestions();
  }

  Future<void> getInProcessList() async {
    try {
      final uri = Uri.parse(ApiUrls.inProcessListForAuditor);
      final request = http.Request('GET', uri);
      final streamedResponse = await _apiClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        final res = auditorInProcessListResponseFromJson(response.body);
        inProcessList.assignAll(res.data);
      } else {
        inProcessList.clear();
      }
    } catch (_) {
      inProcessList.clear();
    }
  }


  final _apiClient = ApiClient();
  final RxInt headerId = 0.obs;

  final int annexureId = 0;
  final String headerName = '';
  final String headerQuestion = '';
  final int headerQuestionId = 0;

  RxList<RiskAssessmentQuestionNew> riskAssessmentQuestions = <RiskAssessmentQuestionNew>[].obs;
  RxList<Map<String, dynamic>> questionDataForView = <Map<String, dynamic>>[].obs;
  RxBool isLoadingHeaders = true.obs;
  var isSubmitting = false.obs;
  RxBool isLoadingQuestions = false.obs; // Naya loader flag

  RxList<dynamic> riskOptions = <dynamic>[].obs;
  RxList<dynamic> ratingOptions = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    getInProcessList();
    getRiskAssessmentQuestions();
    getRatingOptions();
    getRiskLevels();
  }

  Future<void> getRiskLevels() async {
    try {
      final response = await _apiClient.get(
          Uri.parse(ApiUrls.getRiskLevelList));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        riskOptions.assignAll(data['data']);
        print('✅ Successfully fetched ${riskOptions.length} risk levels.');
      }
    } catch (e) {
      print('❌ getRiskLevels Error: $e');
    }
  }

  Future<void> getRatingOptions() async {
    try {
      final response = await _apiClient.get(
          Uri.parse(ApiUrls.getRatingMaster)); // Apni sahi URL yahan dalein
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ratingOptions.assignAll(data['data']);
      }
    } catch (e) {
      print('❌ getRatingOptions Error: $e');
    }
  }

  Future<void> getRiskAssessmentQuestions() async {
    isLoadingQuestions.value = true; // Loading shuru
    try {
      final uri = Uri
          .parse(ApiUrls.getRiskAssessmentQuestionMasterDetails)
          .replace(queryParameters: {
        'productId': selectedProductId.value.toString(),
        'docketNumber': selectedDocketId.value.toString(),
      });
      final request = http.Request('GET', uri);
      final streamedResponse = await _apiClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = riskAssessmentQuestionResponseFromJson(response.body);
        riskAssessmentQuestions.assignAll(data.data);
        final formattedData = data.data.map((q) =>
        {
          'id': q.id,
          'index': q.indexNo,
          'question': q.riskAssessmentQuestion,
          'uploadFile': q.uploadFile,
          'annexureId': q.annexureId,
          'riskAssessmentQuestionId': q.riskAssessmentQuestionId,
          'risk': q.auditRisk?.toString(),
          'rating': q.auditRating != null ? q.auditRating.toString() : null,
          'observation': q.auditObservation?.toString() ?? "",
          'imagePath': q.imagePath?.toString() ?? "",
          'isNetworkImage': q.imagePath != null && q.imagePath!.isNotEmpty, // Flag for UI
        }).toList();
        questionDataForView.assignAll(formattedData);
      }
    } catch (e) {
      print('❌ getRiskAssessmentQuestions Error: $e');
    } finally {
      isLoadingQuestions.value = false; // Loading khatam
    }
  }


  // void prepareAndSubmitRiskAssessmentDetails() async {
  //   final filteredList = questionDataForView.where((e) {
  //     final hasRating = e['rating'] != null && e['rating']
  //         .toString()
  //         .isNotEmpty;
  //     final hasObservation = e['observation'] != null && e['observation']
  //         .toString()
  //         .trim()
  //         .isNotEmpty;
  //     final hasImage = e['imagePath'] != null &&
  //         (e['imagePath'] as String).isNotEmpty;
  //
  //     return hasRating || hasObservation || hasImage;
  //   }).toList();
  //
  //   if (filteredList.isEmpty) {
  //     Get.snackbar("Alert", "Please answer at least one question.",
  //         backgroundColor: Colors.orange);
  //     return;
  //   }
  //
  //   // Direct submit call (ratingMap ki ab zaroorat nahi hai)
  //   await submitAuditSingleCall(filteredList);
  // }

  void prepareAndSubmitRiskAssessmentDetails() async {
    final filteredList = questionDataForView.toList();

    await submitAuditSingleCall(filteredList);
  }

  Future<void> submitAuditSingleCall(
      List<Map<String, dynamic>> filteredData) async
  {
    try {
      isSubmitting.value = true;

      final url = Uri.parse(ApiUrls.SaveAudit);
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');

      // ---------------- Root Payload ----------------
      Map<String, dynamic> payload = {
        "Id": 0,
        "DocketNumber": selectedDocketId.value,
        "DocNumber": selectedDocketName.value,
        "ProductId": selectedProductId.value,
        "RiskAssessmentsDetails": []
      };

      // ---------------- Details Loop ----------------
      for (int i = 0; i < filteredData.length; i++) {
        var item = filteredData[i];

        final originalQuestion = riskAssessmentQuestions.firstWhere(
              (q) =>
          q.riskAssessmentQuestionId ==
              item['riskAssessmentQuestionId'],
        );

        payload["RiskAssessmentsDetails"].add({
          "headerQuestionId": originalQuestion.headerQuestionId,
          "headerQuestion": originalQuestion.headerQuestion ?? "",
          "riskAssessmentQuestionId": item['riskAssessmentQuestionId'] ?? 0,
          "riskAssessmentQuestion":
          item['question']?.toString() ?? "",
          "auditRating":
          item['rating'] != null && item['rating'].toString().isNotEmpty
              ? int.parse(item['rating'].toString())
              : 0,
          "auditRisk":
          item['risk'] != null && item['risk'].toString().isNotEmpty
              ? int.parse(item['risk'].toString())
              : 0,
          "auditObservation":
          item['observation']?.toString() ?? "",
          "annexure": originalQuestion.annexure ?? "",
          "annexureId": originalQuestion.annexureId,
          "indexNo": item['index'] ?? 0,
        });
      }

      // ---------------- Debug Print ----------------
      print("------- 🚀 NORMAL POST REQUEST -------");
      print("URL: $url");
      print("Headers: Authorization: Bearer $token");
      print("Body: ${jsonEncode(payload)}");
      print("------------------------------------");

      // ---------------- API Call ----------------
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);
      print("Response: ${response.body}");

      if (response.statusCode == 200 &&
          data['result'] != null &&
          data['result'] != 0) {
        Get.snackbar(
          "Success",
          "Audit submitted successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await getRiskAssessmentQuestions();
      } else {
        throw Exception("Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Submission Error: $e");
      Get.snackbar(
        "Error",
        "Submission failed. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }



  RxList<dynamic> capturedImages = <dynamic>[].obs;
  var isLoadingImages = false.obs;

  Future<void> fetchCapturedImages(int questionId) async {
    try {
      isLoadingImages.value = true;
      final uri = Uri.parse(ApiUrls.getCapturedImages).replace(
        queryParameters: {
          'RiskAssessmentQuestionId': questionId.toString(),
          'DocketId': selectedDocketId.value.toString(),
        },
      );
      final response = await _apiClient.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          capturedImages.assignAll(data['result']);
          updateLocalImageThumbnail(questionId);
        }
      }
    } catch (e) {
      print("Error fetching images: $e");
    } finally {
      isLoadingImages.value = false;
    }
  }

  Future<void> uploadAuditImages({
    required int docketId,
    required int headerId,
    required int questionId,
    required List<File> files,
  }) async
  {
    try {
      isSubmitting.value = true;
      var request = http.MultipartRequest('POST', Uri.parse(ApiUrls.saveAuditImages));
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['DocketId'] = docketId.toString();
      request.fields['HeaderQuestionId'] = headerId.toString();
      request.fields['RiskAssessmentQuestionId'] = questionId.toString();

      for (var file in files) {
        request.files.add(await http.MultipartFile.fromPath('files', file.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Images uploaded successfully", backgroundColor: Colors.green, colorText: Colors.white);
        fetchCapturedImages(questionId); // Refresh list
      }
    } catch (e) {
      print("Upload error: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deleteCapturedImage(int imageId, int questionId) async {
    try {
      final uri = Uri.parse(ApiUrls.deleteCapturedImage).replace(
        queryParameters: {
          'Id': imageId.toString(),
        },
      );
      final response = await _apiClient.post(uri); // As per your requirement it's POST

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['result'] == 1) {
          Get.snackbar("Deleted", "Image removed", backgroundColor: Colors.orange);
          fetchCapturedImages(questionId); // Refresh list
        }
      }
    } catch (e) {
      print("Delete error: $e");
    }
  }

  void updateLocalImageThumbnail(int questionId) {
    String? newPath = capturedImages.isNotEmpty
        ? capturedImages.first['imagePath']
        : "";

    int idx = questionDataForView.indexWhere((e) => e['riskAssessmentQuestionId'] == questionId);
    if (idx != -1) {
      questionDataForView[idx]['imagePath'] = newPath;
      questionDataForView.refresh(); // UI ko update karne ke liye
    }
  }


/// with image multipart request
  // Future<void> submitAuditSingleCall(
  //     List<Map<String, dynamic>> filteredData) async
  // {
  //   try {
  //     isSubmitting.value = true;
  //     final url = Uri.parse(ApiUrls.SaveAudit);
  //     final storage = FlutterSecureStorage();
  //     final token = await storage.read(key: 'access_token');
  //
  //     final request = http.MultipartRequest('POST', url);
  //     request.headers['Authorization'] = 'Bearer $token';
  //     request.headers['Accept'] = 'application/json';
  //
  //     // --- Root Fields ---
  //     request.fields['Id'] = '0';
  //     request.fields['DocketNumber'] =
  //         selectedDocketId.value.toString(); // 123456
  //     request.fields['DocNumber'] =
  //         selectedDocketName.value.toString(); // DOC-2025-001
  //     request.fields['ProductId'] = selectedProductId.value.toString(); // 1
  //
  //     // --- Details Loop ---
  //     for (int i = 0; i < filteredData.length; i++) {
  //       var item = filteredData[i];
  //
  //       final originalQuestion = riskAssessmentQuestions.firstWhere((q) =>
  //       q.riskAssessmentQuestionId == item['riskAssessmentQuestionId']);
  //
  //       // Mapping as per your requirement:
  //       request.fields["RiskAssessmentsDetails[$i].headerQuestionId"] = originalQuestion.headerQuestionId.toString(); // int → string
  //       request.fields["RiskAssessmentsDetails[$i].headerQuestion"] = originalQuestion.headerQuestion ?? ""; // string safe
  //       request.fields["RiskAssessmentsDetails[$i].riskAssessmentQuestionId"] = item['riskAssessmentQuestionId'] != null ? item['riskAssessmentQuestionId'].toString() : "0";
  //       request.fields["RiskAssessmentsDetails[$i].riskAssessmentQuestion"] = item['question']?.toString() ?? "";
  //       request.fields["RiskAssessmentsDetails[$i].auditRating"] = (item['rating'] != null && item['rating'].toString().isNotEmpty) ? item['rating'].toString() : "0"; // integer safe
  //       request.fields["RiskAssessmentsDetails[$i].auditRisk"] = (item['risk'] != null && item['risk'].toString().isNotEmpty) ? item['risk'].toString() : "0"; // integer safe
  //       request.fields["RiskAssessmentsDetails[$i].auditObservation"] = item['observation']?.toString() ?? "";
  //       request.fields["RiskAssessmentsDetails[$i].annexure"] = originalQuestion.annexure ?? "";
  //       request.fields["RiskAssessmentsDetails[$i].annexureId"] = originalQuestion.annexureId.toString(); // int → string
  //       request.fields["RiskAssessmentsDetails[$i].indexNo"] = item['index'] != null ? item['index'].toString() : "0"; // integer safe
  //
  //       if (item['imagePath'] != null && item['imagePath']
  //           .toString()
  //           .isNotEmpty) {
  //         request.files.add(await http.MultipartFile.fromPath(
  //           "RiskAssessmentsDetails[$i].Image",
  //           item['imagePath'],
  //           contentType: MediaType('image', 'jpeg'),
  //         ));
  //       }
  //     }
  //
  //     // --- 🟢 PRINT REQUEST BODY START ---
  //     print("------- 🚀 MULTIPART REQUEST START -------");
  //     print("URL: $url");
  //     print("Headers: ${request.headers}");
  //
  //     print("\n--- 📝 Text Fields ---");
  //     request.fields.forEach((key, value) {
  //       print("$key: $value");
  //     });
  //
  //     print("\n--- 🖼️ Files ---");
  //     for (var file in request.files) {
  //       print("Field: ${file.field} | Name: ${file
  //           .filename} | Content-Type: ${file.contentType} | Length: ${file
  //           .length} bytes");
  //     }
  //     print("------- 🚀 MULTIPART REQUEST END -------\n");
  //     // --- 🔴 PRINT REQUEST BODY END ---
  //
  //     final response = await request.send();
  //     final responseBody = await response.stream.bytesToString();
  //     print("Response: $responseBody");
  //
  //     final data = jsonDecode(responseBody);
  //
  //     if (response.statusCode == 200 &&
  //         data['result'] != null &&
  //         data['result'] != 0) {
  //       Get.snackbar(
  //         "Success",
  //         "Audit submitted successfully",
  //         backgroundColor: Colors.green,
  //         colorText: Colors.white,
  //       );
  //
  //       await getRiskAssessmentQuestions();
  //     } else {
  //       throw Exception("Failed with status: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("❌ Submission Error: $e");
  //     Get.snackbar("Error", "Submission failed. Please try again.",
  //         backgroundColor: Colors.red, colorText: Colors.white);
  //   } finally {
  //     isSubmitting.value = false;
  //   }
  // }

}
