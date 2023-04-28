Take one of the widgets, provided by this package: 

- `AnimatedListView` 
- `SliverAnimatedListView` 
- `AnimatedGridView`
- `SliverAnimatedGridView`
- `AnimatedPageView`

Example:
```dart
AnimatedListView(
    eventController: eventController,
    // [itemsNotifier] is optional
    itemsNotifier: itemsNotifier,
    idMapper: (object) => object.id.toString(),
    items: items,
    itemBuilder: (item) {
        return ListTile(
            leading: SizedBox.square(
                dimension: 20,
                child: ColoredBox(color: item.color),
            ),
            title: Text('ItemId: ${item.id}'),
        );
    },
);
```

And then, using event controller, add some event:

```dart
eventController.add(
    MoveItemEvent.byId(
        itemId: itemId,
        newIndex: newIndex,
    ),
);

// Also, you can use the "short-cut" version:
eventController.moveById(
    itemId: itemId,
    newIndex: newIndex,
);
```

And the item will be moved with animation!

Also, there are `InsertItemEvent` and `RemoveItemEvent` provided by default.

In addition, you can implement your own event, with your logic.