import 'package:santai/app/data/models/notification/notification_res_model.dart';

abstract class NotificationRepository {
  Future<NotifyResponseModel?> getNotificationsByTimestamp(int lastTimestamp);
}
