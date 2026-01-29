import 'package:flutter/material.dart';
import '../../../core/constants/appcolors.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: const Text(
          'About Us',
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
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.assessment,
                      size: 50,
                      color: primaryDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Score',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Our Mission'),
                  const SizedBox(height: 12),
                  _buildContentCard(
                    'We are committed to providing a comprehensive audit management solution that helps organizations maintain compliance, track performance, and ensure quality standards across all branches and departments.',
                    Icons.flag_outlined,
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle('What We Do'),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    Icons.verified_user,
                    'Compliance Management',
                    'Ensure your organization meets all regulatory requirements and standards.',
                  ),
                  _buildFeatureItem(
                    Icons.analytics,
                    'Performance Tracking',
                    'Monitor and analyze audit performance metrics in real-time.',
                  ),
                  _buildFeatureItem(
                    Icons.location_city,
                    'Branch Management',
                    'Manage audits across multiple branches efficiently.',
                  ),
                  _buildFeatureItem(
                    Icons.security,
                    'Risk Assessment',
                    'Identify and mitigate potential risks proactively.',
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Our Team'),
                  const SizedBox(height: 12),
                  _buildContentCard(
                    'Our dedicated team of professionals works tirelessly to deliver innovative solutions that streamline audit processes and enhance organizational efficiency.',
                    Icons.people_outline,
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Contact Information'),
                  const SizedBox(height: 12),
                  _buildContactItem(
                    Icons.email,
                    'Email',
                    'support@auditscore.com',
                  ),
                  _buildContactItem(
                    Icons.phone,
                    'Phone',
                    '+1 (555) 123-4567',
                  ),
                  _buildContactItem(
                    Icons.language,
                    'Website',
                    'www.auditscore.com',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: primaryDark,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildContentCard(String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryDark, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primaryDark, size: 24),
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
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryDark, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: primaryDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

