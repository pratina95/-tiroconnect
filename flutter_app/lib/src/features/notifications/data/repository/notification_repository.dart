import 'package:tiroconnect/src/features/notifications/data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<void> createNotification(NotificationModel notification);
  Future<List<NotificationModel>> getNotifications(String userId);
  Future<int> getUnreadCount(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Stream<List<NotificationModel>> watchNotifications(String userId);
}
