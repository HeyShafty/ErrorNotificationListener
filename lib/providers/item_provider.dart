import 'package:error_notification_listener/models/item_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
class ItemProvider {
  const ItemProvider({
    required this.item,
  });

  final ItemModel item;
}
