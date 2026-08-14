import 'package:injectable/injectable.dart';
import 'package:tiroconnect/src/features/notifications/data/datasource/notification_datasource.dart';
import 'package:tiroconnect/src/features/notifications/data/models/notification_model.dart';
import 'package:tiroconnect/src/features/notifications/data/repository/notification_repository.dart';

@Injectable(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource _dataSource;

  NotificationRepositoryImpl(this._dataSource);

  @override
  Future<void> createNotification(NotificationModel notification) {
    return _dataSource.createNotification(notification);
  }

  @override
  Future<List<NotificationModel>> getNotifications(String userId) {
    return _dataSource.getNotifications(userId);
  }

  @override
  Future<int> getUnreadCount(String userId) {
    return _dataSource.getUnreadCount(userId);
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return _dataSource.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead(String userId) {
    return _dataSource.markAllAsRead(userId);
  }

  @override
  Stream<List<NotificationModel>> watchNotifications(String userId) {
    return _dataSource.watchNotifications(userId);
  }
}
