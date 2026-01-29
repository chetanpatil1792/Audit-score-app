import 'package:get/get.dart';

import '../view/Notification.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    // Add 10 sample notifications
    final types = [NotificationType.success, NotificationType.warning, NotificationType.info];
    notifications.value = List.generate(10, (index) {
      return NotificationItem(
        title: 'Audit Notification #${index + 1}',
        description: 'Details for audit task #${index + 1} requiring your attention.',
        type: types[index % 3],
        timestamp: DateTime.now().subtract(Duration(minutes: index * 15)),
        isRead: index < 3, // first 3 marked as read
      );
    });
  }

  void markAsRead(int index) {
    notifications[index].isRead = true;
    notifications.refresh();
  }
}
