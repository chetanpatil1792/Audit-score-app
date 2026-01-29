import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/appcolors.dart';
import '../controller/NotificationController.dart';


class NotificationPage extends StatelessWidget {
  NotificationPage({Key? key}) : super(key: key);
   final controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryDarkBlue,
      ),
      body: Obx(() {
        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: controller.notifications.length,
          separatorBuilder: (context, index) => const SizedBox(height: 6),
          itemBuilder: (context, index) {
            final item = controller.notifications[index];
            return NotificationTile(
              item: item,
              onTap: () => controller.markAsRead(index),
            );
          },
        );
      }),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onTap;

  const NotificationTile({Key? key, required this.item, required this.onTap}) : super(key: key);

  Color getIconColor() {
    switch (item.type) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.info:
        return Colors.blue;
    }
  }

  IconData getIcon() {
    switch (item.type) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(getIcon(), color: getIconColor(), size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMM yyyy, hh:mm a').format(item.timestamp),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (!item.isRead)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 6),
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String description;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
}

enum NotificationType { success, warning, info }
