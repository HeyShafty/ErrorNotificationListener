import 'package:flutter/cupertino.dart';

@immutable
class ItemModel {
  const ItemModel({
    required this.id,
    required this.status,
  });

  final int id;
  final bool status;

  ItemModel copyWith({
    int? id,
    bool? status,
  }) {
    return ItemModel(
      id: id ?? this.id,
      status: status ?? this.status,
    );
  }
}
