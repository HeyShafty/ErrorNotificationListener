import 'package:error_notification_listener/models/item_model.dart';
import 'package:error_notification_listener/notifications/base_item_notification.dart';

class ItemChangedNotification extends BaseItemNotification {
  const ItemChangedNotification({
    required this.item,
  });

  final ItemModel item;
}
