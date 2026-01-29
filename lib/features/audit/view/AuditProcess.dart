import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/constants/decorations.dart';
import '../controller/AuditProcessController.dart';
import '../model/branch_response.dart';
import '../widgets/AuditProcessWidget.dart';
import '../widgets/ShimmerWidget.dart';
import 'package:shimmer/shimmer.dart';

class AuditProcess extends StatelessWidget {
  AuditProcess({super.key});

  final controller = Get.find<AuditProcessController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Dashboard Gray Background
      appBar: AppBar(
        title: const Text('Audit Process',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: primaryDark, // Dashboard Primary Color
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            // Padding kam kar di hai taaki table ko zyada width mile
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Filters Section (Premium Compact Card) ---
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCompactDropdown<String>(
                          label: 'Select Month',
                          value: controller.selectedMonth.value.isEmpty ? null : controller.selectedMonth.value,
                          items: controller.months.map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 13)))).toList(),
                          onChanged: (val) {
                            controller.selectedMonth.value = val ?? '';
                            controller.updateAssignDate(val ?? '');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCompactDropdown<Branch>(
                          label: 'Branch Name',
                          value: controller.selectedBranch.value,
                          items: controller.branchList.map((b) => DropdownMenuItem(value: b, child: Text(b.branchName ?? 'Unknown', style: const TextStyle(fontSize: 13)))).toList(),
                          onChanged: (val) => controller.selectedBranch.value = val,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- Docket List ---
                _buildSectionLabel("Docket List", Icons.assignment_outlined),
                const SizedBox(height: 8),
                _buildTableWrapper(
                  child: buildDataTable(
                    headers: const ["Docket Number", "Product Name", "Branch Name", "Assign Month", "Audit Start Date", "Audit End Date", "Action"],
                    rows: controller.docketList.map((docket) {
                      return {
                        'Docket Number': docket.docketNumber ?? '',
                        'Product Name': docket.productName ?? '',
                        'Branch Name': docket.branchName ?? '',
                        'Assign Month': getMonthName(docket.fullAssignDate),
                        'Audit Start Date': docket.auditStartDate ?? '',
                        'Audit End Date': docket.auditEndDate ?? '',
                        'Action': 'Start',
                        'DocketId': docket.id.toString(),
                        'StartDate': docket.auditStartDate ?? '',
                        'EndDate': docket.auditEndDate ?? '',
                        'AssignDate': docket.fullAssignDate ?? '',
                      };
                    }).toList(),
                    onActionSelected: (String action, Map<String, String> row) => controller.handleActionSelection(action, row),
                  ),
                ),

                const SizedBox(height: 25),

                // --- In-Process List ---
                _buildSectionLabel("In-Process List", Icons.pending_actions_rounded),
                const SizedBox(height: 8),
                Obx(() => controller.isInProcessListLoading.value
                    ? buildShimmerTable(3)
                    : _buildTableWrapper(
                  child: buildDataTable(
                    headers: const ["Docket Number", "Product Name", "Assign Month"],
                    rows: controller.inProcessList.map((item) {
                      return {
                        'Docket Number': item.docketNumber ?? '',
                        'Product Name': item.productName ?? '',
                        'Assign Month': item.assignDate ?? '',
                      };
                    }).toList(),
                  ),
                )),
                const SizedBox(height: 20),

                // --- Changes List ---
                // _buildSectionLabel("Changes List", Icons.change_circle),
                // const SizedBox(height: 8),
                // Obx(() => controller.isInChangesListLoading.value
                //     ? buildShimmerTable(3)
                //     : _buildTableWrapper(
                //   child: buildDataTable(
                //     headers: const ["Docket Number", "Product Name","Branch Name","Supervisor Name", "Assign Month"],
                //     rows: controller.changesList.map((item) {
                //       return {
                //         'Docket Number': item.docketNumber ?? '',
                //         'Product Name': item.productName ?? '',
                //         'Branch Name': item.branchName ?? '',
                //         'Supervisor Name': item.supervisorName ?? '',
                //         'Assign Month': item.assignDate ?? '',
                //       };
                //     }).toList(),
                //   ),
                // )),
                // const SizedBox(height: 20),
              ],
            )),
          ),

          // Loading Overlay
          Obx(() => controller.isStartingAudit.value
              ? Container(
            color: Colors.black26,
            child: const Center(child: CircularProgressIndicator(color: primaryDark)),
          )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildCompactDropdown<T>({required String label, T? value, required List<DropdownMenuItem<T>> items, required ValueChanged<T?> onChanged}) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 11, color: Colors.blueGrey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildSectionLabel(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: primaryDark),
          const SizedBox(width: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF334155))),
        ],
      ),
    );
  }

  Widget _buildTableWrapper({required Widget child}) {
    return Container(
      width: double.infinity, // Table ko poori space milegi
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    );
  }

  String getMonthName(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parts = date.split('/');
      if (parts.length != 3) return '';
      final monthNumber = int.parse(parts[1]);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return months[monthNumber - 1];
    } catch (e) { return ''; }
  }

  Widget buildShimmerTable(int columnCount) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}