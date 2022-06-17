import 'package:error_notification_listener/models/item_model.dart';
import 'package:error_notification_listener/my_page_route.dart';
import 'package:error_notification_listener/notifications/item_changed_notification.dart';
import 'package:flutter/material.dart';

class ItemDetailsPage extends MyPageRoute<void> {
  ItemDetailsPage({
    required ModelNotificationPropagator onNotification,
    required this.item,
  }) : super(onNotification);

  final ItemModel item;

  @override
  Widget buildContent(BuildContext context) {
    return ItemDetails(item: item);
  }
}

class ItemDetails extends StatefulWidget {
  const ItemDetails({
    Key? key,
    required this.item,
  }) : super(key: key);

  final ItemModel item;

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  late bool status = widget.item.status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item ${widget.item.id} details'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Current status is: $status', textAlign: TextAlign.center),
          const Text('Tap the FAB to change the status', textAlign: TextAlign.center),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Change this page's item status
          setState(() {
            status = !status;
          });
          // Notify all of above tree that this item has changed.
          //
          // Once we reached the end of the tree (up the the ItemDetailsPage widget), the `MyPageRoute` class will
          // automatically transfer the notification to the previous page of the Navigator's stack
          ItemChangedNotification(
            item: widget.item.copyWith(status: status),
          ).dispatch(context);
        },
        child: const Icon(Icons.change_circle),
      ),
    );
  }
}
