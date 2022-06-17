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
    - Item is not updated?

But clearly the item from the item list was modified after catching the `ItemChangedNotification`...
Yet the `ItemTile` will not rerender its child `ItemTileTitle` (I'd love to know the reason)

[I am thinking this could be the reason why](https://jelenaaa.medium.com/how-to-force-widget-to-redraw-in-flutter-2eec703bc024)
but I am not certain because this looks more like an issue linked to me passing data to my childrens using a `Provider` which could lead Flutter to think there was no actual state change...  
But I'm not sure.

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
7) ???
8) Why is this happening?

My understanding of flutter is not advanced enough to accurately understand why this is happening :( so I hope someone can identify the problem! 
