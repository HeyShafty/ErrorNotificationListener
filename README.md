# Error on NotificationListener

Small code repo to illustrate by issue

## Quick project description

I am trying to create a global state management where model changes are broadcasted up
the widget tree using notifications.  
Also, I want notifications to be able to propagate down the Navigator stack, and this for an indefinite amount of pages. When we push a page, we want to be able to catch the notifications going up said pushed page despite them being stacked at the `MaterialApp`'s level in the widget tree.  

I came up with a simple solution that you can see in the `MyPageRoute` class.  
Code should be fairly simple to read and understand so I hope I was clear enough when
describing my project.

## Please consider

that the code from this repo is an abstraction of the app I am working on.  
So yes sometimes the code will be unecessarily complex because it is only an isolatation of the problem.

## What is not working?

1) Launch app
    - You can see an item list
2) Tap any item tile
3) Tap the floating action button to change the widget's status
4) Go back to item list
    - Item tile is not updated? (I am expecting it to be rebuild/rerendered)

The item list was definitely modified after catching the `ItemChangedNotification` in the `NotificationListener`.
Yet, when the `ListView.builder` will rebuild its elements, the modified `ItemTile` will not rerender its child `ItemTileTitle` who is in charge of showing the item's status.

[I am thinking this could be the reason why](https://jelenaaa.medium.com/how-to-force-widget-to-redraw-in-flutter-2eec703bc024)
but I am not certain because this could also be an issue linked to me passing data to my childrens using a `Provider` which could lead Flutter to think there was no actual state change...  
But I'm not sure.

Also could be because this is an issue related to the widget's lifecycle and how the `ItemTile` will not rebuild its child `ItemTileTitle` because nothing has really changed in the widget tree. Only the `Provider`'s value changed.
But then why is the `context.select` from the `build` method of `ItemTileTitle` not rebuilding if the `Provider`'s value changed?

This current part describes my main problem. Anything below are more errors caused by me trying to fix the above problem.

## The UniqueKey/ValueKey fix

I am considering forcing flutter to rebuild all of my `ItemTile`s no matter what, by
giving them unconditionally a `UniqueKey`.  

So I changed the following code:

In `main.dart` at around :68
```dart
Widget _itemBuilder(BuildContext context, ItemModel item, int index) {
  return ItemTile(key: UniqueKey() /* or ValueKey(item) */, item: item);
}
```

1) Launch app
    - You can see an item list
2) Tap any item tile
3) Tap the floating action button to change the widget's status
4) Go back to item list
    - The item is now updated!
    - *but...*
5) Tap any item (again)
6) Tap the floating action button **MORE THAN ONCE** to change the widget's status back and forth
    - **ERROR**, null check value
    - *error copypasta below*
7) ???
8) Why is this happening?

My understanding of flutter is not advanced enough to accurately understand why this is happening :( so I hope someone can identify the problem! 

```
════════ Exception caught by gesture ═══════════════════════════════════════════
The following _CastError was thrown while handling a gesture:
Null check operator used on a null value

When the exception was thrown, this was the stack
#0      Element.widget
package:flutter/…/widgets/framework.dart:3229
#1      _NotificationElement.onNotification
package:flutter/…/widgets/notification_listener.dart:128
#2      _NotificationNode.dispatchNotification
package:flutter/…/widgets/framework.dart:3078
#3      Element.dispatchNotification
package:flutter/…/widgets/framework.dart:4375
#4      Notification.dispatch
package:flutter/…/widgets/notification_listener.dart:60
#5      MyPageRoute.onNotification.<anonymous closure>
package:error_notification_listener/my_page_route.dart:12
#6      MyPageRoute.buildPage.<anonymous closure>
package:error_notification_listener/my_page_route.dart:26
#7      _NotificationElement.onNotification
package:flutter/…/widgets/notification_listener.dart:130
#8      _NotificationNode.dispatchNotification
package:flutter/…/widgets/framework.dart:3078
#9      Element.dispatchNotification
package:flutter/…/widgets/framework.dart:4375
#10     Notification.dispatch
package:flutter/…/widgets/notification_listener.dart:60
#11     _ItemDetailsState.build.<anonymous closure>
package:error_notification_listener/item_details_page.dart:61
#12     _InkResponseState._handleTap
package:flutter/…/material/ink_well.dart:1005
#13     GestureRecognizer.invokeCallback
package:flutter/…/gestures/recognizer.dart:198
#14     TapGestureRecognizer.handleTapUp
package:flutter/…/gestures/tap.dart:613
#15     BaseTapGestureRecognizer._checkUp
package:flutter/…/gestures/tap.dart:298
#16     BaseTapGestureRecognizer.handlePrimaryPointer
package:flutter/…/gestures/tap.dart:232
#17     PrimaryPointerGestureRecognizer.handleEvent
package:flutter/…/gestures/recognizer.dart:563
#18     PointerRouter._dispatch
package:flutter/…/gestures/pointer_router.dart:94
#19     PointerRouter._dispatchEventToRoutes.<anonymous closure>
package:flutter/…/gestures/pointer_router.dart:139
#20     _LinkedHashMapMixin.forEach (dart:collection-patch/compact_hash.dart:614:13)
#21     PointerRouter._dispatchEventToRoutes
package:flutter/…/gestures/pointer_router.dart:137
#22     PointerRouter.route
package:flutter/…/gestures/pointer_router.dart:123
#23     GestureBinding.handleEvent
package:flutter/…/gestures/binding.dart:445
#24     GestureBinding.dispatchEvent
package:flutter/…/gestures/binding.dart:425
#25     RendererBinding.dispatchEvent
package:flutter/…/rendering/binding.dart:329
#26     GestureBinding._handlePointerEventImmediately
package:flutter/…/gestures/binding.dart:380
#27     GestureBinding.handlePointerEvent
package:flutter/…/gestures/binding.dart:344
#28     GestureBinding._flushPointerEventQueue
package:flutter/…/gestures/binding.dart:302
#29     GestureBinding._handlePointerDataPacket
package:flutter/…/gestures/binding.dart:285
#33     _invoke1 (dart:ui/hooks.dart:170:10)
#34     PlatformDispatcher._dispatchPointerDataPacket (dart:ui/platform_dispatcher.dart:331:7)
#35     _dispatchPointerDataPacket (dart:ui/hooks.dart:94:31)
(elided 3 frames from dart:async)
Handler: "onTap"
Recognizer: TapGestureRecognizer#8a772
    debugOwner: GestureDetector
    state: possible
    won arena
    finalPosition: Offset(356.8, 798.9)
    finalLocalPosition: Offset(44.8, 33.6)
    button: 1
    sent tap down
════════════════════════════════════════════════════════════════════════════════
```
