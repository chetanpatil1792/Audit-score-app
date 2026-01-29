import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/constants/appcolors.dart';
import '../controller/AnnexureViewController.dart';

class AuditImagePage extends StatelessWidget {
  final int questionId;
  final int headerId;
  final int docketId;
  final AnnexureViewController controller = Get.find();
  final ImagePicker _picker = ImagePicker();

  AuditImagePage({required this.questionId, required this.headerId, required this.docketId}) {
    controller.fetchCapturedImages(questionId);
  }

  Future<File?> compressImage(String path) async {
    final dir = await getTemporaryDirectory();
    final targetPath = "${dir.path}/img_${DateTime.now().millisecondsSinceEpoch}.jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      path, targetPath, quality: 35, minWidth: 1024, minHeight: 1024,
    );
    return result != null ? File(result.path) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          // Dashboard Style Header
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryDark, Color(0xFF1E293B)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildPremiumAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        _buildHeroStatsCard(),
                        const SizedBox(height: 25),
                        _buildEvidenceSection(context),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildAnimatedFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildPremiumAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 5),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("EVIDENCE", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              Text("Management", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.collections_rounded, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          Container(
            height: 60, width: 60,
            decoration: BoxDecoration(color: primaryDark.withOpacity(0.05), shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome_motion_rounded, color: primaryDark, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Upload Status", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                Obx(() => Text("${controller.capturedImages.length} of 4 Images",
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1E293B)))),
              ],
            ),
          ),
          Obx(() => _buildStatusIndicator()),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    bool isFull = controller.capturedImages.length == 4;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isFull ? Colors.green.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isFull ? "Complete" : "Pending",
        style: TextStyle(color: isFull ? Colors.green : Colors.blue, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  Widget _buildEvidenceSection(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingImages.value) return const Center(child: CircularProgressIndicator(color: primaryDark));
      if (controller.capturedImages.isEmpty) return _buildEmptyState();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 15),
            child: Text("Captured Assets", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1E293B))),
          ),
          GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.85,
            ),
            itemCount: controller.capturedImages.length,
            itemBuilder: (context, index) {
              var img = controller.capturedImages[index];
              return _buildPremiumImageCard(img);
            },
          ),
        ],
      );
    });
  }

  Widget _buildPremiumImageCard(var img) {
    String url = "${ApiUrls.baseUrl2}${img['imagePath']}";
    return GestureDetector(
      onTap: () => _openFullImage(url, img['id']),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Hero(
                      tag: 'img_${img['id']}',
                      child: Image.network(url, fit: BoxFit.cover, width: double.infinity),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.tag, size: 12, color: Colors.grey),
                      Text("${img['id']}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const Spacer(),
                      const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
            // DELETE CHIP - Clean and Premium
            Positioned(
              top: 10, right: 10,
              child: GestureDetector(
                onTap: () => _showDeleteDialog(img['id']),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedFAB(BuildContext context) {
    return Obx(() => controller.capturedImages.length < 4
        ? Container(
      height: 60, margin: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        onPressed: () => _showPicker(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8, shadowColor: primaryDark.withOpacity(0.4),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text("ADD NEW EVIDENCE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
          ],
        ),
      ),
    )
        : const SizedBox.shrink());
  }

  void _showPicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 25),
            const Text("Choose Source", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: primaryDark)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _pickerOption(Icons.photo_library_rounded, "Gallery", const Color(0xFF6366F1), ImageSource.gallery),
                _pickerOption(Icons.camera_alt_rounded, "Camera", const Color(0xFFF59E0B), ImageSource.camera),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _pickerOption(IconData icon, String label, Color color, ImageSource source) {
    return InkWell(
      onTap: () { Get.back(); _pickAndUpload(source); },
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Future<void> _pickAndUpload(ImageSource source) async {
    final XFile? file = await _picker.pickImage(source: source, imageQuality: 75);
    if (file == null) return;
    File? compressed = await compressImage(file.path);
    if (compressed != null) {
      controller.uploadAuditImages(docketId: docketId, headerId: headerId, questionId: questionId, files: [compressed]);
    }
  }

  void _openFullImage(String url, int id) {
    Get.to(() => Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black, elevation: 0,
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close, color: Colors.white)),
        actions: [IconButton(onPressed: () { Get.back(); _showDeleteDialog(id); }, icon: const Icon(Icons.delete_outline, color: Colors.white))],
      ),
      body: InteractiveViewer(child: Hero(tag: 'img_$id', child: Center(child: Image.network(url)))),
    ));
  }

  void _showDeleteDialog(int imageId) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Delete Asset?", style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text("This action will remove the evidence from the server. This cannot be undone."),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () { Get.back(); controller.deleteCapturedImage(imageId, questionId); },
            child: const Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)]),
            child: Icon(Icons.cloud_upload_outlined, size: 60, color: Colors.grey.shade300),
          ),
          const SizedBox(height: 20),
          Text("No Evidences Yet", style: TextStyle(color: Colors.grey.shade400, fontSize: 16, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}