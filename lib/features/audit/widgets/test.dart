// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../core/constants/appcolors.dart';
// import '../controller/GoToAuditController.dart';
// import '../widgets/AnnexureWidgets.dart';
//
//
// class AnnexureViewPage extends StatefulWidget {
//   final String headerQuestion;
//   final RxList<Map<String, dynamic>> annexureData;
//
//   AnnexureViewPage({
//     super.key,
//     required this.headerQuestion,
//     required this.annexureData,
//   });
//
//   @override
//   State<AnnexureViewPage> createState() => _AnnexureViewPageState();
// }
//
// class _AnnexureViewPageState extends State<AnnexureViewPage> {
//   final ImagePicker _picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//     _normaliseAnnexureData();
//   }
//
//   Widget _buildSingleViewBottomBar() {
//     return SafeArea(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, -2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: OutlinedButton(
//                 onPressed: () => Get.back(),
//                 style: OutlinedButton.styleFrom(
//                   side: const BorderSide(color: Colors.grey),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   "Close",
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: () {
//                   controller.submittedData.value = widget.annexureData
//                       .map((e) => {
//                     'index': e['index'],
//                     'question': e['question'],
//                     'rating': e['rating'] ?? '',
//                     'observation': e['observation'] ?? '',
//                     'images': List<String>.from(e['images'] ?? []),
//                   })
//                       .toList();
//                   Get.snackbar(
//                     "Success",
//                     "Annexure submitted successfully!",
//                     backgroundColor: Colors.green.shade100,
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   "Submit",
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _normaliseAnnexureData() {
//     for (final item in widget.annexureData) {
//       item['observation'] ??= '';
//       // Prefer single imagePath; if legacy 'images' exists, keep only the first as imagePath
//       if (item['imagePath'] == null && item['images'] is List && (item['images'] as List).isNotEmpty) {
//         item['imagePath'] = (item['images'] as List).first.toString();
//       }
//       item.remove('images');
//     }
//   }
//
//   Future<void> _showImageSourceSheet(int index) async {
//     await showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt_outlined),
//               title: const Text("Capture from Camera"),
//               onTap: () {
//                 Navigator.pop(context);
//                 _addImageFromCamera(index);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library_outlined),
//               title: const Text("Choose from Gallery"),
//               onTap: () {
//                 Navigator.pop(context);
//                 _addImageFromGallery(index);
//               },
//             ),
//             const Divider(height: 0),
//             ListTile(
//               leading: const Icon(Icons.close),
//               title: const Text("Cancel"),
//               onTap: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _addImageFromCamera(int index) async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 85,
//       );
//       if (image == null) return;
//       _setImagePath(index, image.path);
//       Get.snackbar(
//         "Photo Added",
//         "Image captured successfully.",
//         backgroundColor: Colors.green.shade100,
//       );
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "Unable to access camera. Please try again.",
//         backgroundColor: Colors.red.shade100,
//       );
//     }
//   }
//
//   Future<void> _addImageFromGallery(int index) async {
//     try {
//       final XFile? selected = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
//       if (selected == null) return;
//       _setImagePath(index, selected.path);
//       Get.snackbar(
//         "Image Added",
//         "Image selected successfully.",
//         backgroundColor: Colors.green.shade100,
//       );
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "Unable to select image. Please try again.",
//         backgroundColor: Colors.red.shade100,
//       );
//     }
//   }
//
//   void _setImagePath(int index, String path) {
//     widget.annexureData[index]['imagePath'] = path;
//     widget.annexureData.refresh();
//   }
//
//   void _clearImage(int questionIndex) {
//     widget.annexureData[questionIndex]['imagePath'] = null;
//     widget.annexureData.refresh();
//   }
//
//   void _previewImage(String path) {
//     if (path.isEmpty) return;
//     showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         insetPadding: const EdgeInsets.all(16),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: Container(
//             color: Colors.black,
//             child: Stack(
//               children: [
//                 Builder(builder: (_) {
//                   final file = File(path);
//                   return InteractiveViewer(
//                     child: file.existsSync()
//                         ? Image.file(
//                       file,
//                       fit: BoxFit.contain,
//                     )
//                         : Container(
//                       alignment: Alignment.center,
//                       color: Colors.black,
//                       child: const Icon(
//                         Icons.image_not_supported_outlined,
//                         color: Colors.white,
//                         size: 64,
//                       ),
//                     ),
//                   );
//                 }),
//                 Positioned(
//                   top: 16,
//                   right: 16,
//                   child: IconButton(
//                     icon: const Icon(Icons.close, color: Colors.white),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImagePickerGrid(int questionIndex) {
//     final String imagePath = (widget.annexureData[questionIndex]['imagePath'] ?? '') as String;
//     final file = imagePath.isNotEmpty ? File(imagePath) : null;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           height: 150,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade400),
//             image: (file != null && file.existsSync())
//                 ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
//                 : null,
//           ),
//           child: (file == null || !file.existsSync())
//               ? const Center(child: Icon(Icons.photo_camera_back_outlined, size: 48, color: Colors.grey))
//               : null,
//         ),
//         const SizedBox(height: 10),
//         Row(
//           children: [
//             OutlinedButton.icon(
//               onPressed: () => _addImageFromCamera(questionIndex),
//               icon: const Icon(Icons.camera_alt_outlined, color: primaryDarkBlue),
//               label: const Text("Camera", style: TextStyle(color: primaryDarkBlue)),
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: primaryDarkBlue),
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//             ),
//             const SizedBox(width: 10),
//             OutlinedButton.icon(
//               onPressed: () => _addImageFromGallery(questionIndex),
//               icon: const Icon(Icons.photo_library_outlined, color: primaryDarkBlue),
//               label: const Text("Gallery", style: TextStyle(color: primaryDarkBlue)),
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: primaryDarkBlue),
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//             ),
//             // const Spacer(),
//
//           ],
//         ),
//         Row(
//           children: [
//             if (file != null && file.existsSync())
//               TextButton.icon(
//                 onPressed: () => _previewImage(imagePath),
//                 icon: const Icon(Icons.remove_red_eye_outlined),
//                 label: const Text("Preview"),
//               ),
//             if (file != null && file.existsSync())
//               TextButton.icon(
//                 onPressed: () => _clearImage(questionIndex),
//                 icon: const Icon(Icons.delete_outline, color: Colors.red),
//                 label: const Text("Remove", style: TextStyle(color: Colors.red)),
//               ),
//           ],
//         )
//       ],
//     );
//   }
//
//   bool isTableView = false; // toggle view
//   int currentIndex = 0; // for single question view
//
//
//
//   final controller = Get.find<GoToAuditController>();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: lightBg,
//       appBar: AppBar(
//         backgroundColor: primaryDarkBlue,
//         title: Text(
//           "Annexure - ${widget.headerQuestion}",
//           style: const TextStyle(color: Colors.white, fontSize: 16),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
//           onPressed: () => Get.back(),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 isTableView = !isTableView;
//               });
//             },
//             child: Text(
//               isTableView ? "Single Question" : "Table View",
//               style: const TextStyle(color: Colors.white),
//             ),
//           )
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(0.0),
//         child: Obx(() {
//           if (widget.annexureData.isEmpty) {
//             return const Center(
//               child: CircularProgressIndicator(color: primaryDarkBlue),
//             );
//           }
//           return isTableView ? buildTableView() : buildSingleQuestionView();
//         }),
//       ),
//       bottomNavigationBar: isTableView ? null : _buildSingleViewBottomBar(),
//     );
//   }
//
//   // ---------------------- Table View (Updated to fix overflow) ----------------------
//   Widget buildTableView() {
//     // मुख्य Column को SingleChildScrollView में लपेटा गया
//     return SingleChildScrollView(
//       padding: const EdgeInsets.only(bottom: 140),
//       child: Column(
//         children: [
//           // DataTable Section: अब Expanded की आवश्यकता नहीं है
//           Container(
//             margin: const EdgeInsets.all(8.0),
//             decoration: buildTableDecoration(),
//             width: double.infinity,
//             child: Scrollbar(
//               thumbVisibility: true,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   dataRowHeight: 50,
//                   headingRowHeight: 40,
//                   columnSpacing: 15,
//                   headingRowColor: MaterialStateProperty.all(tableHeaderBg),
//                   border: TableBorder.all(color: borderColor.withOpacity(0.5), width: 1),
//                   columns: const [
//                     DataColumn(label: Text('Sr No', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDarkBlue, fontSize: 13))),
//                     DataColumn(label: Text('Question', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDarkBlue, fontSize: 13))),
//                     DataColumn(label: Text('Risk', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDarkBlue, fontSize: 13))),
//                     DataColumn(label: Text('Rating', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDarkBlue, fontSize: 13))),
//                     DataColumn(label: Text('Observation', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDarkBlue, fontSize: 13))),
//                     DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDarkBlue, fontSize: 13))),
//                   ],
//                   rows: List.generate(widget.annexureData.length, (index) {
//                     final data = widget.annexureData[index];
//                     return DataRow(cells: [
//                       DataCell(Text(data['index'].toString(), style: const TextStyle(fontSize: 12))),
//                       DataCell(SizedBox(width: 250, child: Text(data['question'] ?? '', style: const TextStyle(fontSize: 12, height: 1.3), maxLines: 3, overflow: TextOverflow.ellipsis))),
//                       DataCell(Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: getRiskColor(data['risk']),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(data['risk'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 11)),
//                       )),
//                       DataCell(DropdownButton<String>(
//                         value: data['rating'],
//                         hint: const Text("Select", style: TextStyle(fontSize: 12)),
//                         items: const [
//                           DropdownMenuItem(value: 'Yes', child: Text('Yes')),
//                           DropdownMenuItem(value: 'No', child: Text('No')),
//                           DropdownMenuItem(value: 'NA', child: Text('NA')),
//                         ],
//                         onChanged: (val) {
//                           data['rating'] = val;
//                           widget.annexureData.refresh();
//                         },
//                         underline: const SizedBox(),
//                         isDense: true,
//                       )),
//                       DataCell(
//                         SizedBox(
//                           width: 160,
//                           child: TextFormField(
//                             initialValue: data['observation'] ?? '',
//                             decoration: const InputDecoration(
//                               hintText: "Observation...",
//                               border: OutlineInputBorder(),
//                               isDense: true,
//                               contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//                             ),
//                             style: const TextStyle(fontSize: 12),
//                             onChanged: (val) {
//                               data['observation'] = val;
//                             },
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         SizedBox(
//                           width: 150,
//                           child: Row(
//                             children: [
//                               IconButton(
//                                 tooltip: "Add image",
//                                 icon: const Icon(Icons.add_photo_alternate_outlined,
//                                     color: Colors.blueAccent, size: 20),
//                                 onPressed: () => _showImageSourceSheet(index),
//                               ),
//                               const SizedBox(width: 4),
//                               _SingleImagePreview(
//                                 imagePath: (data['imagePath'] ?? '') as String,
//                                 onTap: (data['imagePath'] != null && (data['imagePath'] as String).isNotEmpty)
//                                     ? () => _previewImage(data['imagePath'])
//                                     : null,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ]);
//                   }),
//                 ),
//               ),
//             ),
//           ),
//
//           // --- Submit/Close Buttons ---
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // Close Button
//                 ElevatedButton(
//                   onPressed: () {
//                     Get.back();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 30, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                   child:
//                   const Text("Close", style: TextStyle(color: Colors.white, fontSize: 16)),
//                 ),
//                 // Submit Button
//                 ElevatedButton(
//                   onPressed: () {
//                     // Submit लॉजिक
//                     controller.submittedData.value = widget.annexureData
//                         .map((e) => {
//                       'index': e['index'],
//                       'question': e['question'],
//                       'rating': e['rating'] ?? '',
//                       'observation': e['observation'] ?? '',
//                     })
//                         .toList();
//                     Get.snackbar("Success", "Annexure submitted successfully!",
//                         backgroundColor: Colors.green.shade100);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 30, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                   child: const Text("Submit",
//                       style: TextStyle(color: Colors.white, fontSize: 16)),
//                 ),
//               ],
//             ),
//           ),
//
//           // Submitted Records View
//           _buildSubmittedRecordsView(),
//         ],
//       ),
//     );
//   }
//
//
//   // ---------------------- Single Question View ----------------------
//   Widget buildSingleQuestionView() {
//     final data = widget.annexureData[currentIndex];
//     String? selectedOption = data['rating'];
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.only(bottom: 140),
//       child: Column(
//         children: [
//           Card(
//             elevation: 3,
//             color: Colors.white,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             margin: const EdgeInsets.all(8),
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Question Header
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Question ${currentIndex + 1} of ${widget.annexureData.length}",
//                         style: const TextStyle(
//                             fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: getRiskColor(data['risk']),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           data['risk'] ?? 'No Risk',
//                           style: const TextStyle(color: Colors.white, fontSize: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     "${data['index']}. ${data['question']}",
//                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryDarkBlue),
//                   ),
//                   const SizedBox(height: 15),
//
//                   // Rating Options
//                   Text(
//                     "Select Rating",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: ['Yes', 'No', 'NA'].map((option) {
//                       final isSelected = selectedOption == option;
//                       return Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               data['rating'] = option;
//                             });
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(horizontal: 4),
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                   color: isSelected ? primaryDarkBlue : Colors.grey.shade400,
//                                   width: 2),
//                               borderRadius: BorderRadius.circular(10),
//                               color: isSelected ? primaryDarkBlue.withOpacity(0.1) : Colors.white,
//                             ),
//                             child: Center(
//                               child: Text(
//                                 option,
//                                 style: TextStyle(
//                                     color: isSelected ? primaryDarkBlue : Colors.grey[800],
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 15),
//
//                   // Observation
//                   Text(
//                     "Observation by IA",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     key: ValueKey("observation_${data['index']}"),
//                     initialValue: data['observation'] ?? '',
//                     maxLines: 3,
//                     onChanged: (val) {
//                       data['observation'] = val;
//                     },
//                     decoration: InputDecoration(
//                       hintText: "Type your observation here...",
//                       filled: true,
//                       fillColor: Colors.grey.shade100,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.grey.shade400),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//
//                   // Photo Capture
//                   Text(
//                     "Evidence Capture",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
//                   ),
//                   const SizedBox(height: 10),
//                   _buildImagePickerGrid(currentIndex),
//                   const SizedBox(height: 20),
//
//                   // Navigation Buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ElevatedButton.icon(
//                         onPressed: currentIndex > 0
//                             ? () {
//                           setState(() {
//                             currentIndex--;
//                           });
//                         }
//                             : null,
//                         icon: const Icon(Icons.arrow_back, color: primaryDarkBlue),
//                         label: const Text("Previous", style: TextStyle(color: primaryDarkBlue)),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           padding:
//                           const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             side: const BorderSide(color: primaryDarkBlue),
//                           ),
//                           elevation: 2,
//                         ),
//                       ),
//                       ElevatedButton.icon(
//                         onPressed: currentIndex < widget.annexureData.length - 1
//                             ? () {
//                           setState(() {
//                             currentIndex++;
//                           });
//                         }
//                             : null,
//                         icon: const Icon(Icons.arrow_forward, color: Colors.white),
//                         label: const Text("Next", style: TextStyle(color: Colors.white)),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: primaryDarkBlue,
//                           padding:
//                           const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           elevation: 2,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                 ],
//               ),
//             ),
//           ),
//           // Submitted Records View को Single View के नीचे जोड़ें
//           _buildSubmittedRecordsView(),
//         ],
//       ),
//     );
//   }
//
//   // ---------------------- PREMIUM SUBMITTED RECORDS VIEW ----------------------
//   Widget _buildSubmittedRecordsView() {
//     if (controller.submittedData.isEmpty) {
//       return const SizedBox.shrink(); // अगर डेटा नहीं है तो कुछ नहीं दिखाएं
//     }
//
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 20.0),
//       child: Obx(() => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "✅ Submitted Records",
//             style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: primaryDarkBlue), // मुख्य रंग का उपयोग
//           ),
//           const SizedBox(height: 10),
//           Card(
//             elevation: 5, // प्रीमियम लुक के लिए अधिक एलिवेशन
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             margin: EdgeInsets.zero,
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Scrollbar(
//                 thumbVisibility: true,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: DataTable(
//                     columnSpacing: 20,
//                     dataRowHeight: 60,
//                     headingRowHeight: 45,
//                     headingTextStyle: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: primaryDarkBlue,
//                         fontSize: 14),
//                     dataTextStyle: const TextStyle(
//                         fontSize: 13, color: Colors.black87, height: 1.3),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     columns: const [
//                       DataColumn(label: Text('S.No.')),
//                       DataColumn(label: Text('Question')),
//                       DataColumn(label: Text('Rating')),
//                       DataColumn(label: Text('Observation')),
//                     ],
//                     rows: controller.submittedData
//                         .map(
//                           (e) => DataRow(
//                         cells: [
//                           DataCell(Text(e['index'].toString())),
//                           DataCell(SizedBox(
//                             width: 200, // Question के लिए फिक्स्ड चौड़ाई
//                             child: Text(e['question'] ?? '',
//                                 maxLines: 3,
//                                 overflow: TextOverflow.ellipsis),
//                           )),
//                           DataCell(Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: e['rating'] == 'Yes' ? Colors.green.shade100 : Colors.red.shade100,
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Text(e['rating'] ?? '-',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     color: e['rating'] == 'Yes' ? Colors.green.shade800 : Colors.red.shade800)),
//                           )),
//                           DataCell(SizedBox(
//                             width: 150, // Observation के लिए फिक्स्ड चौड़ाई
//                             child: Text(e['observation'] ?? '-',
//                                 maxLines: 3,
//                                 overflow: TextOverflow.ellipsis),
//                           )),
//                         ],
//                       ),
//                     )
//                         .toList(),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       )),
//     );
//   }
// }
//
// class _SingleImagePreview extends StatelessWidget {
//   final String imagePath;
//   final VoidCallback? onTap;
//
//   const _SingleImagePreview({
//     required this.imagePath,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (imagePath.isEmpty) {
//       return const Icon(Icons.photo_library_outlined, color: Colors.grey, size: 24);
//     }
//     final file = File(imagePath);
//     return GestureDetector(
//       onTap: onTap,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: file.existsSync()
//                 ? Image.file(
//               file,
//               width: 40,
//               height: 40,
//               fit: BoxFit.cover,
//             )
//                 : Container(
//               width: 40,
//               height: 40,
//               color: Colors.grey.shade200,
//               alignment: Alignment.center,
//               child: const Icon(
//                 Icons.image_not_supported_outlined,
//                 color: Colors.grey,
//                 size: 18,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
