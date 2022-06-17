import 'package:error_notification_listener/notifications/base_item_notification.dart';
import 'package:flutter/material.dart';

typedef ModelNotificationPropagator = void Function(BaseItemNotification);

abstract class MyPageRoute<T> extends PageRoute<T> with MaterialRouteTransitionMixin<T> {
  MyPageRoute(ModelNotificationPropagator onNotification) : _onNotification = onNotification;

  final ModelNotificationPropagator _onNotification;

  static ModelNotificationPropagator onNotification(BuildContext target) {
    return (notification) => notification.dispatch(target);
  }

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final Widget result = buildContent(context);

    // This NotificationListener ensures we can propagate notifications from upper pages to other lower pages without
    // having to implement a custom Navigator stack
    return NotificationListener<BaseItemNotification>(
      onNotification: (notification) {
        _onNotification(notification);
        return false;
      },
      child: result,
    );
  }
}
