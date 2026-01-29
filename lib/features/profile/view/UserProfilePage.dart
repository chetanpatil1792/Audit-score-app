import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/appcolors.dart';
import '../controller/ProfileController.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    controller.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Ultra light slate
      body: Obx(() {
        if (controller.isLoading.value) {
          return const _ShimmerLoadingState();
        }

        final auditor = controller.auditorData.value;
        if (auditor.id == null) return _buildNoDataState();

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(auditor),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHorizontalStatChips(auditor),
                    const SizedBox(height: 30),

                    _buildSectionHeader("Official Identity"),
                    _buildPremiumCard([
                      _buildInfoRow(Icons.badge_rounded, "Auditor ID", auditor.empCode ?? "N/A", color: Colors.blue),
                      _buildDivider(),
                      _buildInfoRow(Icons.alternate_email_rounded, "Email Address", auditor.email ?? "N/A", color: Colors.orange),
                      _buildDivider(),
                      _buildInfoRow(Icons.phone_android_rounded, "Primary Mobile", auditor.mobile ?? "N/A", color: Colors.green),
                    ]),

                    const SizedBox(height: 25),

                    _buildSectionHeader("Work Info"),
                    _buildPremiumCard([
                      _buildInfoRow(Icons.account_tree_outlined, "Reporting Manager", auditor.manager1 ?? "N/A", color: Colors.purple),
                      _buildDivider(),
                      _buildInfoRow(Icons.business_center_outlined, "Department", auditor.department ?? "N/A", color: Colors.teal),
                      _buildDivider(),
                      _buildInfoRow(Icons.location_on_outlined, "Branch Location", auditor.branch ?? "N/A", color: Colors.redAccent),
                    ]),

                    const SizedBox(height: 25),

                    _buildSectionHeader("Personal Details"),
                    _buildPremiumCard([
                      _buildInfoRow(Icons.cake_outlined, "Date of Birth", auditor.dob ?? "N/A", color: Colors.pink),
                      _buildDivider(),
                      _buildInfoRow(Icons.map_outlined, "Address", "${auditor.district ?? ''}, ${auditor.state ?? ''}", color: Colors.indigo),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // --- Premium Sliver AppBar with Profile Integration ---
  Widget _buildSliverAppBar(auditor) {
    final name = "${auditor.firstName ?? ''} ${auditor.lastName ?? ''}";
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      elevation: 0,
      stretch: true,
      backgroundColor: primaryDark,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 28),
          onPressed: () => Get.snackbar("Admin Notice", "Profile editing is disabled."),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            // Gradient Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryDark, Color(0xFF334155)],
                ),
              ),
            ),
            // Profile Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      auditor.profileImage ?? "https://ui-avatars.com/api/?name=$name&background=random",
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text(auditor.designation ?? "Auditor",
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, letterSpacing: 1)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Bento Style Stat Chips ---
  Widget _buildHorizontalStatChips(auditor) {
    return Row(
      children: [
        _buildStatTile("Role", auditor.role ?? "N/A", Icons.verified_user_rounded, Colors.blue),
        const SizedBox(width: 12),
        _buildStatTile("Grade", auditor.grade ?? "N/A", Icons.grade_rounded, Colors.amber),
      ],
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                  Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryDark)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- Premium Card Styling ---
  Widget _buildPremiumCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {required Color color}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(height: 1, indent: 70, endIndent: 20, color: Colors.grey.shade100);

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: primaryDark)),
    );
  }

  Widget _buildNoDataState() {
    return const Center(child: Text("No Data Found", style: TextStyle(fontWeight: FontWeight.bold)));
  }
}

// --- UPGRADED SHIMMER ---
class _ShimmerLoadingState extends StatelessWidget {
  const _ShimmerLoadingState();
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.white,
      child: Column(
        children: [
          Container(height: 280, color: Colors.white),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(children: [
                    Expanded(child: Container(height: 70, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)))),
                    const SizedBox(width: 12),
                    Expanded(child: Container(height: 70, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)))),
                  ]),
                  const SizedBox(height: 20),
                  Container(height: 200, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}