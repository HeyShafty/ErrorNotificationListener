import 'package:error_notification_listener/item_details_page.dart';
import 'package:error_notification_listener/models/item_model.dart';
import 'package:error_notification_listener/my_page_route.dart';
import 'package:error_notification_listener/notifications/base_item_notification.dart';
import 'package:error_notification_listener/notifications/item_changed_notification.dart';
import 'package:error_notification_listener/providers/item_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  FirstPageState createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  late final List<ItemModel> items;

  @override
  void initState() {
    super.initState();
    items = List.generate(20, (index) => ItemModel(id: index, status: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main page'),
      ),
      body: NotificationListener<BaseItemNotification>(
        onNotification: (notification) {
          if (notification is ItemChangedNotification) {
            print('Item ${notification.item} changed!');
            setState(() {
              items[notification.item.id] = notification.item;
            });
          }
          // This is false on purpose
          return false;
        },
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => _itemBuilder(context, items[index], index),
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, ItemModel item, int index) {
    print('Building item: $item');
    return ItemTile(/* key: UniqueKey(), */ item: item);
  }
}

class ItemTile extends StatelessWidget {
  const ItemTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => ItemProvider(item: item),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          ItemDetailsPage(onNotification: MyPageRoute.onNotification(context), item: item),
        ),
        title: const ItemTileTitle(),
      ),
    );
  }
}

class ItemTileTitle extends StatelessWidget {
  const ItemTileTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final item = context.select<ItemProvider, ItemModel>((provider) => provider.item);

    return Text('ID: ${item.id}, Status: ${item.status}');
  }
}
