import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/constants/decorations.dart';
import '../controller/GoToAuditController.dart';
import '../model/inprocesListForAuditor.dart';
import 'AnnexureViewPage.dart';

class GoToAudit extends StatelessWidget {
  GoToAudit({super.key});
  final controller = Get.find<GoToAuditController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        title: const Text('Go To Audit', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () => Get.back(),
        ),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: buildTableDecoration(),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<InProcessItemAuditor>(
                          decoration: buildDropdownDecoration('Docket Number'),
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          style: const TextStyle(fontSize: 14, color: primaryColor),
                          items: controller.inProcessList
                              .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item.docketNumber ?? ''),
                          ))
                              .toList(),
                          value: controller.selectedDocket.value,
                          onChanged: (val) => controller.onDocketChanged(val),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (controller.selectedDocket.value != null)
              AnnexureViewPage(),
          ],
        )),
      ),
    );
  }
}
