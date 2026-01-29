import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart';
import '../../../routes/app_routes.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: primaryDark,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryDark, primaryLight],
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.help_outline,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'How Can We Help?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find answers to common questions',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // FAQ Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFAQItem(
                    'How do I create a new audit?',
                    'To create a new audit, navigate to the Dashboard and click on "Go to Audit" in the Quick Actions section. Select your branch and month, then follow the prompts to start the audit process.',
                  ),
                  _buildFAQItem(
                    'How can I view my audit history?',
                    'You can view your audit history by going to the Dashboard and accessing the "Audit Process" section. Here you\'ll find a list of all your completed and pending audits.',
                  ),
                  _buildFAQItem(
                    'What should I do if I encounter an error?',
                    'If you encounter any errors, please try refreshing the app or logging out and logging back in. If the issue persists, contact our support team through the Contact Us page.',
                  ),
                  _buildFAQItem(
                    'How do I update my profile information?',
                    'To update your profile, go to the Dashboard drawer menu, tap on "View Profile", and then click the edit icon. Make your changes and save.',
                  ),
                  _buildFAQItem(
                    'Can I access the app offline?',
                    'Some features are available offline, but for full functionality including syncing data and submitting audits, an internet connection is required.',
                  ),

                  const SizedBox(height: 32),

                  // Quick Actions
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildQuickActionCard(
                    Icons.video_library,
                    'Watch Tutorial Videos',
                    'Learn how to use the app with our video guides',
                    Colors.blue,
                  ),
                  _buildQuickActionCard(
                    Icons.description,
                    'User Manual',
                    'Download the complete user manual',
                    Colors.orange,
                  ),
                  _buildQuickActionCard(
                    Icons.chat_bubble_outline,
                    'Live Chat Support',
                    'Chat with our support team in real-time',
                    Colors.green,
                  ),

                  const SizedBox(height: 32),

                  // Support Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primaryDark.withValues(alpha: 0.1),
                          primaryLight.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: primaryDark.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.support_agent,
                          size: 50,
                          color: primaryDark,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Still Need Help?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Our support team is available 24/7 to assist you',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Get.toNamed(AppRoutes.contactUs);
                                },
                                icon: const Icon(Icons.email),
                                label: const Text('Email Us'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primaryDark,
                                  side: const BorderSide(color: primaryDark),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Get.snackbar(
                                    'Live Chat',
                                    'Live chat feature coming soon!',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                                icon: const Icon(Icons.chat),
                                label: const Text('Live Chat'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryDark,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: primaryDark,
          ),
        ),
        iconColor: primaryDark,
        collapsedIconColor: primaryDark,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}

