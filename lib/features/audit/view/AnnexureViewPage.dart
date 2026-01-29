import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/constants/decorations.dart';
import '../controller/AnnexureViewController.dart';
import '../model/inprocesListForAuditor.dart';
import '../widgets/AnnexureWidgets.dart' hide buildTableDecoration;
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import 'AuditImagePage.dart';
import 'dynamic_annexure_form_page.dart';
class AnnexureViewPage extends StatefulWidget {
  const AnnexureViewPage({super.key});

  @override
  State<AnnexureViewPage> createState() => _AnnexureViewPageState();
}

class _AnnexureViewPageState extends State<AnnexureViewPage> {
  final controller = Get.put(AnnexureViewController());

  bool isTableView = false;
  int currentIndex = 0;
  bool isRendering = false;


  Future<void> _toggleView() async {
    setState(() {
      isRendering = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isTableView = !isTableView;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isRendering = false;
      });
    });
  }
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: lightBg,
          appBar: AppBar(
            backgroundColor: primaryDarkBlue,
            leadingWidth: 15,
            title: const Text("Audit", style: TextStyle(color: Colors.white, fontSize: 16)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
              onPressed: () => Get.back(),
            ),
            actions: [
              TextButton(
                onPressed: isRendering ? null : _toggleView, // Click block karein jab render ho raha ho
                child: Text(
                  isTableView ? "Single Question" : "Table View",
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
          body: isRendering
              ? _buildRenderLoader() // Switch karte waqt ye dikhega
              : Column(
            children: [
              _buildDocketDropdown(), // Extracted for cleanliness
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingQuestions.value) {
                    return const Center(child: CircularProgressIndicator(color: primaryDarkBlue));
                  }
                  if (controller.questionDataForView.isEmpty) {
                    return _buildNoDataWidget();
                  }
                  return isTableView ? buildTableView() : buildSingleQuestionView();
                }),
              ),
            ],
          ),
        ),
        Obx(
              () => controller.isSubmitting.value
              ? Container(
            // Apply a slightly dark overlay across the entire screen
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Card(
                // Loading Card Design
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      // Loading Indicator
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent), // Change color
                        strokeWidth: 4,
                      ),
                      SizedBox(height: 16),
                      // Loading Text
                      Text(
                        'Please wait...', // Inform the user
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
              : const SizedBox.shrink(),
        )
      ],
    );
  }

  Widget _buildRenderLoader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(color: primaryDarkBlue),
          SizedBox(height: 16),
          Text("Rendering View...", style: TextStyle(color: primaryDarkBlue, fontWeight: FontWeight.bold)),
          Text("Optimizing large data set", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDocketDropdown() {
    return Obx(() => Container(
      width: double.infinity,
      decoration: buildTableDecoration(),
      padding: const EdgeInsets.all(12),
      child: DropdownButtonFormField<InProcessItemAuditor>(
        decoration: buildDropdownDecoration('Select Docket Number'),
        dropdownColor: Colors.white,
        isExpanded: true,
        style: const TextStyle(fontSize: 14, color: primaryColor),
        items: controller.inProcessList
            .map((item) => DropdownMenuItem(value: item, child: Text(item.docketNumber ?? '')))
            .toList(),
        value: controller.selectedDocket.value,
        onChanged: (val) => controller.onDocketChanged(val),
      ),
    ));
  }

  Widget _buildNoDataWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_late_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text("No Questions Available", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget buildTableView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 140),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            decoration: buildTableDecoration(),
            width: double.infinity,
            child: Scrollbar(
              controller: _horizontalScrollController,
              thumbVisibility: true,
              trackVisibility: true,
              child: SingleChildScrollView(
                controller: _horizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  // dataRowHeight: 180,
                  dataRowMinHeight: 50, // Minimum height itni rahegi
                  dataRowMaxHeight: double.infinity, // Content ke hisab se height badhegi
                  headingRowHeight: 40,
                  columnSpacing: 15,
                  headingRowColor: MaterialStateProperty.all(tableHeaderBg),
                  border: TableBorder.all(color: borderColor.withOpacity(0.5), width: 1),
                  columns: const [
                    DataColumn(label: Text('Sr No', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDarkBlue, fontSize: 13))),
                    DataColumn(label: Text('Question', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDarkBlue, fontSize: 13))),
                    DataColumn(label: Text('Risk', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDarkBlue, fontSize: 13))),
                    DataColumn(label: Text('Rating', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDarkBlue, fontSize: 13))),
                    DataColumn(label: Text('Observation', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDarkBlue, fontSize: 13))),
                    DataColumn(label: Text('Annexure', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDarkBlue, fontSize: 13))),
                    DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDarkBlue, fontSize: 13))),
                  ],
                  rows: List.generate(controller.questionDataForView.length, (index) {
                    final data = controller.questionDataForView[index];
                    return DataRow(cells: [
                      DataCell(Text(data['index'].toString(), style: const TextStyle(fontSize: 12))),
                      // Table Row ke andar Question Cell
                      DataCell(
                          SizedBox(
                              width: 250,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                    data['question'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 10.5, // Thoda kam kiya
                                      height: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF334155), // Slate color for premium look
                                    ),
                                    maxLines: 30,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis
                                ),
                              )
                          )
                      ),
                      // DataCell(SizedBox(width: 250, child: Text(data['question'] ?? '', style: const TextStyle(fontSize: 12, height: 1.4), maxLines: 30,softWrap: true, overflow: TextOverflow.ellipsis))),
                      DataCell(Obx(() => DropdownButton<String>(
                        value: (data['risk'] != null) ? data['risk'].toString() : null,
                        hint: const Text("Select Risk", style: TextStyle(fontSize: 11)),
                        items: controller.riskOptions.map((opt) {
                          return DropdownMenuItem<String>(
                            value: opt['id'].toString(), // Bhejni ID hai
                            child: Text(opt['riskLevel'] ?? '', style: const TextStyle(fontSize: 11)), // Dikhan RiskLevel hai
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            data['risk'] = val;
                          });
                        },
                        underline: const SizedBox(),
                        isDense: true,
                      ))),

                      DataCell(Obx(() => DropdownButton<String>(
                        value: (data['rating'] != null) ? data['rating'].toString() : null,
                        hint: const Text("0", style: TextStyle(fontSize: 12)),
                        items: controller.ratingOptions.map((opt) {
                          String val = opt['ratingNumber'].toString();
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val, style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            data['rating'] = val;
                          });
                        },
                        underline: const SizedBox(),
                        isDense: true,
                      ))),
                      DataCell(
                        SizedBox(
                          width: 160,
                          child: TextFormField(
                            initialValue: data['observation'] ?? '',
                            decoration: const InputDecoration(
                              hintText: "Observation...",
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            ),
                            style: const TextStyle(fontSize: 12),
                            onChanged: (val) {
                              data['observation'] = val;
                            },
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 80,
                          child: Row(
                            children: [
                              IconButton(
                                tooltip: "Add Annexure",
                                icon: Icon(
                                  Icons.add,
                                  size: 20,
                                  color: data['annexureId'] == 0
                                      ? Colors.grey   // disabled color
                                      : Colors.blueAccent,
                                ),
                                 onPressed: data['annexureId'] == 0
                                    ? null
                                    : () {
                                  controller.annexureIdForSubmit.value = data['annexureId'];
                                  controller.riskAssessmentQuestionId.value = data['riskAssessmentQuestionId'];
                                  controller.getAnnexureHeaders(data['annexureId']);
                                 },
                              ),
                            ],
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 60,
                          child: (data['uploadFile'] == true) // Check if true
                              ? Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                IconButton(
                                  tooltip: "Manage Images",
                                  icon: Icon(
                                    Icons.camera_alt_outlined,
                                    color: (data['imagePath'] != null && data['imagePath'].toString().isNotEmpty)
                                        ? Colors.blueAccent
                                        : Colors.grey.shade400,
                                    size: 26,
                                  ),
                                  onPressed: () {
                                    final originalQuestion = controller.riskAssessmentQuestions.firstWhere(
                                            (q) => q.riskAssessmentQuestionId == data['riskAssessmentQuestionId']);

                                    Get.to(() => AuditImagePage(
                                      questionId: data['riskAssessmentQuestionId'],
                                      headerId: originalQuestion.headerQuestionId ?? 0,
                                      docketId: controller.selectedDocketId.value,
                                    ));
                                  },
                                ),
                                if (data['imagePath'] != null && data['imagePath'].toString().isNotEmpty)
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 1.5),
                                      ),
                                      constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
                                      child: const Icon(Icons.check, size: 8, color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                          )
                              : const SizedBox.shrink(), // Hide if false
                        ),
                      ),
                    ]);
                  }),
                ),
              ),
            ),
          ),

           Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child:
                  const Text("Close", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.prepareAndSubmitRiskAssessmentDetails();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Submit",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          ),

         ],
      ),
    );
  }

  Widget buildSingleQuestionView() {
    final data = controller.questionDataForView[currentIndex];
    String? selectedOption = data['rating'];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: SizedBox(
              width: double.infinity,
              child: data['annexureId'] == 0
                  ? const SizedBox.shrink()
                  : ElevatedButton(
                onPressed: () {
                  controller.getAnnexureHeaders(data['annexureId']);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: const Size(0, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // 👈 button compact rahe
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add,
                      size: 14,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Add Annexure",
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            elevation: 3,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                     children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: primaryDark,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Question ${currentIndex + 1} of ${controller.questionDataForView.length}",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.cyan[800],
                            letterSpacing: 0.5
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(
                    "${data['index']}) ${data['question']}",
                    style: const TextStyle(
                      fontSize: 13, // Pehle 16 tha
                      fontWeight: FontWeight.w500,
                      color: primaryDarkBlue,
                      height: 1.4,
                      letterSpacing: -0.1, // Compact look ke liye
                    ),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: primaryDark,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Select Rating",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.cyan[800],
                            letterSpacing: 0.5
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Obx(() => SizedBox(
                    height: 38,
                    child: DropdownButtonFormField<String>(
                      value: data['rating']?.toString(),
                      hint: const Text("Select", style: TextStyle(fontSize: 11)),
                      isExpanded: true,
                      isDense: true,
                      alignment: Alignment.centerLeft,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        constraints: const BoxConstraints(maxHeight: 38, minHeight: 38),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      items: controller.ratingOptions.map((opt) {
                        String val = opt['ratingNumber'].toString();
                        return DropdownMenuItem(
                          value: val,
                          child: Text(val, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => data['rating'] = val),
                    ),
                  )),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: primaryDark,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Risk Level",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.cyan[800],
                            letterSpacing: 0.5
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Obx(() => SizedBox(
                    height: 38, // Same height as Rating dropdown
                    child: DropdownButtonFormField<String>(
                      value: data['risk']?.toString(),
                      hint: const Text("Select Risk Level", style: TextStyle(fontSize: 11)),
                      isExpanded: true,
                      isDense: true,
                      alignment: Alignment.centerLeft,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        constraints: const BoxConstraints(maxHeight: 38, minHeight: 38),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      items: controller.riskOptions.map((opt) {
                        return DropdownMenuItem<String>(
                          value: opt['id'].toString(),
                          child: Text(
                              opt['riskLevel'] ?? '',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => data['risk'] = val),
                    ),
                  )),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: primaryDark,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Observation by IA",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.cyan[800],
                            letterSpacing: 0.5
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    key: ValueKey("observation_${data['index']}"),
                    initialValue: data['observation'] ?? '',
                    maxLines: 3,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    onChanged: (val) {
                      data['observation'] = val;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter observation...",
                      hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  if (data['uploadFile'] == true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 16,
                            decoration: BoxDecoration(
                              color: primaryDark,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Evidence Capture",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.cyan[800],
                                letterSpacing: 0.5
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Premium Action Card
                      InkWell(
                        onTap: () {
                          final originalQuestion = controller.riskAssessmentQuestions.firstWhere(
                                  (q) => q.riskAssessmentQuestionId == data['riskAssessmentQuestionId']);

                          Get.to(() => AuditImagePage(
                            questionId: data['riskAssessmentQuestionId'],
                            headerId: originalQuestion.headerQuestionId ?? 0,
                            docketId: controller.selectedDocketId.value,
                          ));
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: primaryDark.withOpacity(0.1), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Icon with Dashboard-style Neon Background
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Icon(Icons.auto_awesome_motion_rounded,
                                    color: Colors.blueAccent, size: 24),
                              ),
                              const SizedBox(width: 15),

                              // Text Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Manage Media",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Text(
                                      "Add or view support documents",
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                    ),
                                  ],
                                ),
                              ),

                              // Trailing Arrow with Badge-like feel
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_forward_ios_rounded,
                                    size: 14, color: primaryDark),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: _buildCompactNavBtn(
                          label: "Previous",
                          icon: Icons.arrow_back_ios_new_rounded,
                          isNext: false,
                          height: 38, // Height 38 set ki
                          onPressed: currentIndex > 0 ? () => setState(() => currentIndex--) : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCompactNavBtn(
                          label: "Next",
                          icon: Icons.arrow_forward_ios_rounded,
                          isNext: true,
                          height: 38, // Height 38 set ki
                          onPressed: currentIndex < controller.questionDataForView.length - 1
                              ? () => setState(() => currentIndex++) : null,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Divider(thickness: 0.8, color: Color(0xFFE2E8F0)), // Clean Slate Divider
                  ),

                  Row(
                    children: [
                      Container(
                        height: 38, width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close_rounded, color: Colors.grey, size: 22),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(color: Colors.green.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () => controller.prepareAndSubmitRiskAssessmentDetails(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: const Text("SUBMIT AUDIT",
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5)),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
         ],
      ),
    );
  }

  Widget _buildCompactNavBtn({
    required String label,
    required IconData icon,
    required bool isNext,
    required double height, // Naya parameter
    VoidCallback? onPressed
  }) {
    return SizedBox(
      height: height, // Yahan height 38 apply hogi
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: onPressed == null ? Colors.grey.shade50 : Colors.white,
          side: BorderSide(
              color: onPressed == null ? Colors.grey.shade200 : primaryDarkBlue.withOpacity(0.5)
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Matches dropdowns
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isNext) Icon(icon, size: 12, color: onPressed == null ? Colors.grey : primaryDarkBlue),
            if (!isNext) const SizedBox(width: 6),
            Text(
                label,
                style: TextStyle(
                  color: onPressed == null ? Colors.grey : (isNext ? primaryDarkBlue : Colors.black87),
                  fontWeight: FontWeight.bold,
                  fontSize: 12, // Compact font
                )
            ),
            if (isNext) const SizedBox(width: 6),
            if (isNext) Icon(icon, size: 12, color: onPressed == null ? Colors.grey : primaryDarkBlue),
          ],
        ),
      ),
    );
  }
  }


