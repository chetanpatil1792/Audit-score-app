import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';
import '../model/inprocesListForAuditor.dart';

class GoToAuditController extends GetxController {
  final _apiClient = ApiClient();

  var selectedProductId = 0.obs;
  var selectedDocketId = 0.obs;
  var selectedDocketName = ''.obs;

  RxList<InProcessItemAuditor> inProcessList = <InProcessItemAuditor>[].obs;
  Rx<InProcessItemAuditor?> selectedDocket = Rx<InProcessItemAuditor?>(null);

  @override
  void onInit() {
    super.onInit();
    getInProcessList();
  }

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
}
