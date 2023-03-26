// ignore_for_file: avoid_redundant_argument_values

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

@immutable
class MyModel {
  const MyModel({
    required this.id,
  });

  final int id;

  @override
  String toString() => 'MyModel(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

extension on String {
  ValueKey<String> get vk => ValueKey(this);
}

extension on int {
  ValueKey<String> get vk => ValueKey('$this');
}

extension on Finder {
  Rect? get findSingleVisibleItem {
    final elements = evaluate();
    expect(elements.isNotEmpty, isTrue);
    final itemRect = elements.map((e) => e.globalPaintBounds).singleWhere(
          (element) => (element?.height ?? 0) > 0,
        );
    expect(itemRect, isNotNull);
    return itemRect;
  }

  int get visibleItemsCount {
    final elements = evaluate();
    return elements
        .where((element) => (element.globalPaintBounds?.height ?? 0) > 0)
        .length;
  }
}

extension GlobalPaintBounds on BuildContext {
  Rect? get globalPaintBounds {
    final renderObject = findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}

void main() {
  const intervalBetweenFramePaint =
      Duration(milliseconds: 16, microseconds: 683);
  group('AnimatedListView', () {
    late DefaultEventController<MyModel> eventController;
    late DefaultItemsNotifier<MyModel> itemsNotifier;
    late ScrollController scrollController;
    const _defaultItemsCount = 50;

    setUp(() {
      eventController = DefaultEventController();
      itemsNotifier = DefaultItemsNotifier();
      scrollController = ScrollController();
    });

    tearDown(() {
      eventController.close();
      itemsNotifier.dispose();
      scrollController.dispose();
    });

    String _getId(int index) => 'ID: $index';

    Widget _getWidget({int itemCount = _defaultItemsCount}) {
      final items = List.generate(itemCount, (index) => MyModel(id: index));

      return MaterialApp(
        home: Scaffold(
          body: AnimatedListView<MyModel>(
            items: items,
            controller: scrollController,
            itemsNotifier: itemsNotifier,
            eventController: eventController,
            idMapper: (object) => object.id.toString(),
            itemBuilder: (item) => ListTile(title: Text(_getId(item.id))),
          ),
        ),
      );
    }

    List<InsertItemEvent<MyModel>> _generateInsertEvents({
      int initialId = 0,
      int incrementedIndex = 0,
      int? commonIndex,
      int itemCount = 5,
    }) {
      return List.generate(
        itemCount,
        (index) => InsertItemEvent(
          item: MyModel(id: initialId + index),
          index: commonIndex ?? (incrementedIndex + index),
        ),
      );
    }

    Future<void> _scrollUntilUnmounted(
      WidgetTester tester,
      int index, {
      double delta = 30,
    }) async {
      while (itemsNotifier.mountedWidgetsIndexRange.includes(index)) {
        scrollController.jumpTo(scrollController.offset + delta);
        await tester.pumpAndSettle();
      }
    }

    testWidgets(
      'correctly builds items from initial item list',
      (tester) async {
        // arrange
        await tester.pumpWidget(_getWidget());

        // assert
        for (var i = 0; i < _defaultItemsCount; i++) {
          final itemFinder = find.text(_getId(i));
          await tester.scrollUntilVisible(itemFinder, 10);
          expect(itemFinder, findsOneWidget);
        }
      },
    );

    group('InsertItemEvent', () {
      group(
        'inserts new item with animation in mounted range',
        () {
          testWidgets('(at zero index)', (tester) async {
            // arrange
            await tester.pumpWidget(_getWidget());

            // act
            eventController.add(
              InsertItemEvent(
                item: const MyModel(id: _defaultItemsCount),
                index: 0,
              ),
            );
            //
            await tester.pump();

            // assert
            final finder = find.text(_getId(_defaultItemsCount));
            expect(finder, findsNothing);
            await tester.pumpAndSettle();
            expect(finder, findsOneWidget);
            expect(scrollController.offset, equals(0));
          });

          testWidgets('(multiple items at the same index)', (tester) async {
            // arrange
            await tester.pumpWidget(_getWidget());
            const index = 0;
            final items = _generateInsertEvents(
              initialId: _defaultItemsCount,
              commonIndex: index,
              itemCount: 3,
            );

            // act
            eventController
              ..add(items[0])
              ..add(items[1])
              ..add(items[2]);
            //

            // assert
            for (final item in items) {
              final finder = find.text(_getId(item.item.id));
              expect(finder, findsNothing);
            }
            //
            await tester.pumpAndSettle();
            //
            for (final item in items) {
              final finder = find.text(_getId(item.item.id));
              expect(finder, findsOneWidget);
            }
            expect(scrollController.offset, equals(0));
          });
        },
      );
      group('inserts items outside of mounted range', () {
        testWidgets('(first index that is outside of mounted range)',
            (tester) async {
          // arrange
          await tester.pumpWidget(_getWidget());
          // first index that is outside of mounted range
          final index = itemsNotifier.mountedWidgetsIndexRange.end + 1;
          final items = _generateInsertEvents(
            itemCount: 1,
            initialId: _defaultItemsCount,
            commonIndex: index,
          );

          // act
          eventController.add(items.first);

          // assert
          final finder = find.text(
            _getId(_defaultItemsCount),
            skipOffstage: false,
          );
          //
          await tester.pumpAndSettle();
          //
          expect(finder, findsNothing);
          expect(scrollController.offset, equals(0));
          // scrolling down by height of one item
          await tester.ensureVisible(find.text(_getId(1)));
          await tester.pumpAndSettle();
          //
          expect(finder, findsOneWidget);
        });

        testWidgets('(atop of mounted range)', (tester) async {
          // arrange
          await tester.pumpWidget(_getWidget());
          final events = _generateInsertEvents(
            itemCount: 1,
            commonIndex: 0,
            initialId: _defaultItemsCount,
          );
          final lastItemFinder = find.text(_getId(_defaultItemsCount - 1));

          // act
          // scrolling until the end
          await tester.scrollUntilVisible(lastItemFinder, 50);
          final offset = scrollController.offset;
          // ensuring that the first index is out of mounted range
          expect(itemsNotifier.mountedWidgetsIndexRange.includes(0), isFalse);
          // adding an item atop of mounted range
          eventController.add(events.first);

          // assert
          // ensuring that scroll offset remained at same position
          expect(scrollController.offset, equals(offset));
          // scrolling to the top, where inserted item should be visible
          scrollController.jumpTo(0);
          // Awaiting animation to complete
          await tester.pumpAndSettle();
          //
          final insertedItemFinder = find.text(_getId(_defaultItemsCount));
          expect(insertedItemFinder, findsOneWidget);
        });

        testWidgets('(atop of mounted range. Multiple items at same index)',
            (tester) async {
          // arrange
          await tester.pumpWidget(_getWidget());
          final events = _generateInsertEvents(
            itemCount: 3,
            commonIndex: 0,
            initialId: _defaultItemsCount,
          );
          final lastItemFinder = find.text(_getId(_defaultItemsCount - 1));

          // act
          // scrolling until the end
          await tester.scrollUntilVisible(lastItemFinder, 50);
          final offset = scrollController.offset;
          // ensuring that the first index is out of mounted range
          expect(itemsNotifier.mountedWidgetsIndexRange.includes(0), isFalse);
          // adding the items atop of mounted range
          eventController
            ..add(events[0])
            ..add(events[1])
            ..add(events[2]);

          // assert
          // ensuring that scroll offset remained at same position
          expect(scrollController.offset, equals(offset));
          // scrolling to the top, where inserted item should be visible
          scrollController.jumpTo(0);
          // Awaiting animation to complete
          await tester.pumpAndSettle();
          //
          var height = 0.0;
          for (final event in events.reversed) {
            final insertedItemFinder = find.byKey(
              ValueKey<String>(event.item.id.toString()),
            );
            expect(insertedItemFinder, findsOneWidget);
            final rect = tester.getRect(insertedItemFinder);

            expect(rect.top, equals(height));
            height += rect.height;
          }
        });
      });
    });

    // MoveItemEvent
    group('MoveItemEvent', () {
      testWidgets(
        'offset does not jump when moving an item from unmounted area '
        'to unmounted area',
        (tester) async {
          // arrange
          await tester.pumpWidget(_getWidget());
          const newIndex = 10;
          const movedItemId = '0';
          final movedItemFinder = find.byKey(
            movedItemId.vk,
            skipOffstage: false,
          );

          // act
          // 1. scrolling till the item with index [newIndex] + 1 is unmounted
          // (+1 because if we will insert the item at the [newIndex], it will
          // mount this item, and animate the insertion immediately, therefore
          // the scroll offset will change by item's height)
          await _scrollUntilUnmounted(tester, newIndex + 1);
          final mountedRange = itemsNotifier.mountedWidgetsIndexRange;
          final firstMountedIndex = mountedRange.start;
          final firstMountedIndexFinder = find.byKey(
            firstMountedIndex.vk,
            skipOffstage: false,
          );

          // 2. getting the position of the first mounted item
          final positionOfFirstMountedItem =
              tester.getRect(firstMountedIndexFinder);
          // 3. ensuring that item, which will be moved, is unmounted
          expect(movedItemFinder, findsNothing);
          // 4. moving item to unmounted area
          eventController.moveById(itemId: movedItemId, newIndex: newIndex);
          // 5. Just in case checking that nothing hapenned
          await tester.pumpAndSettle();
          expect(
            mountedRange,
            equals(itemsNotifier.mountedWidgetsIndexRange),
          );
          expect(
            tester.getRect(firstMountedIndexFinder),
            equals(positionOfFirstMountedItem),
          );
          // 6. scrolling backwards by item height
          // this should mount moved item
          scrollController.jumpTo(
            scrollController.offset - positionOfFirstMountedItem.height,
          );
          await tester.pumpAndSettle();

          // assert
          expect(
            tester.getRect(firstMountedIndexFinder),
            equals(
              positionOfFirstMountedItem.shift(
                Offset(
                  0,
                  positionOfFirstMountedItem.height,
                ),
              ),
            ),
          );
        },
      );

      testWidgets('Moving item to old position does not duplicate it',
          (tester) async {
        // arrange
        await tester.pumpWidget(_getWidget());
        const oldIndex = 1;
        const itemId = '$oldIndex';
        const newIndex = 0;
        final itemFinder = find.byKey(oldIndex.vk);

        // act
        // saving item's rect before moving
        final beforeMovingRect = tester.getRect(itemFinder);
        eventController.moveById(itemId: itemId, newIndex: newIndex);
        await tester.pumpAndSettle();
        eventController.moveById(itemId: itemId, newIndex: oldIndex);
        await tester.pumpAndSettle();

        // assert
        expect(itemFinder.findSingleVisibleItem, equals(beforeMovingRect));
      });

      group('Item is moved to right index.', () {
        group('Both new index and current are in mounted area, and', () {
          testWidgets('new index is greater than the current', (tester) async {
            // arrange
            await tester.pumpWidget(_getWidget());
            final mountedRange = itemsNotifier.mountedWidgetsIndexRange;
            const itemId = '0';
            final newIndex = mountedRange.end;
            final itemFinder = find.byKey(itemId.vk, skipOffstage: false);
            final prevItemFinder = find.byKey(
              newIndex.vk,
              skipOffstage: false,
            );

            // act
            eventController.moveById(itemId: itemId, newIndex: newIndex);
            await tester.pumpAndSettle();

            // assert
            final itemRect = itemFinder.findSingleVisibleItem;
            final prevItemRect = tester.getRect(prevItemFinder);
            expect(
              itemRect!.shift(Offset(0, -itemRect.height)),
              equals(prevItemRect),
            );
          });
          testWidgets('new index is less than the current', (tester) async {
            // arrange
            await tester.pumpWidget(_getWidget());
            final mountedRange = itemsNotifier.mountedWidgetsIndexRange;
            final itemId = mountedRange.end.toString();
            const newIndex = 1;
            final itemFinder = find.byKey(itemId.vk, skipOffstage: false);
            final prevItemFinder = find.byKey(0.vk);

            // act
            eventController.moveById(itemId: itemId, newIndex: newIndex);
            await tester.pumpAndSettle();

            //assert
            final itemRect = itemFinder.findSingleVisibleItem;
            final prevItemRect = tester.getRect(prevItemFinder);
            expect(
              itemRect!.shift(Offset(0, -itemRect.height)),
              equals(prevItemRect),
            );
          });
        });

        group('Both new index and current are in unmounted area, and', () {
          testWidgets(
            'new index is greater than the current',
            (tester) async {
              // arrange
              await tester.pumpWidget(_getWidget());
              const newIndex = 10;
              const movedItemId = '0';
              final movedItemFinder = find.byKey(
                movedItemId.vk,
                skipOffstage: false,
              );
              final nextItemFinder = find.byKey(
                (newIndex + 1).vk,
                skipOffstage: false,
              );

              // act
              // 1. scrolling till the item with index [newIndex] is unmounted
              await _scrollUntilUnmounted(tester, newIndex);
              final mountedRange = itemsNotifier.mountedWidgetsIndexRange;
              final firstMountedIndex = mountedRange.start;
              final firstMountedIndexFinder = find.byKey(
                firstMountedIndex.vk,
                skipOffstage: false,
              );

              // 2. getting the position of the first mounted item
              final positionOfFirstMountedItem =
                  tester.getRect(firstMountedIndexFinder);
              // 3. ensuring that item, which will be moved, is unmounted
              expect(movedItemFinder, findsNothing);
              // 4. moving item to unmounted area
              eventController.moveById(itemId: movedItemId, newIndex: newIndex);
              // 5. Just in case checking that nothing hapenned
              await tester.pumpAndSettle();

              // 6. scrolling backwards by item height
              // this should mount moved item
              scrollController.jumpTo(
                scrollController.offset - positionOfFirstMountedItem.height,
              );
              await tester.pumpAndSettle();

              // assert
              final itemAtNewIndexRect = tester.getRect(movedItemFinder);
              expect(
                itemAtNewIndexRect,
                equals(
                  positionOfFirstMountedItem.shift(
                    Offset(
                      0,
                      positionOfFirstMountedItem.height,
                    ),
                  ),
                ),
              );
              // The item with id [newIndex] + 1 should be the next
              expect(
                tester.getRect(nextItemFinder),
                equals(
                  itemAtNewIndexRect.shift(
                    Offset(
                      0,
                      positionOfFirstMountedItem.height,
                    ),
                  ),
                ),
              );
            },
          );
          testWidgets(
            'new index is less than the current',
            (tester) async {
              // arrange
              await tester.pumpWidget(_getWidget());
              const newIndex = 1;
              const movedItemIndex = 10;
              const movedItemId = '$movedItemIndex';
              final movedItemFinder = find.byKey(
                movedItemId.vk,
                skipOffstage: false,
              );
              final prevItemFinder = find.byKey(
                (newIndex - 1).vk,
                skipOffstage: false,
              );

              // act
              // 1. scrolling till the item with index [movedItemIndex] is
              // unmounted
              await _scrollUntilUnmounted(tester, movedItemIndex);

              // 2. ensuring that item, which will be moved, is unmounted
              expect(movedItemFinder, findsNothing);
              // 3. moving item
              eventController.moveById(itemId: movedItemId, newIndex: newIndex);
              await tester.pumpAndSettle();

              // 4. scrolling backwards to the area where item should be mounted
              scrollController.jumpTo(0);
              await tester.pumpAndSettle();

              // assert
              final itemAtNewIndexRect = movedItemFinder.findSingleVisibleItem;
              expect(
                itemAtNewIndexRect,
                equals(
                  tester.getRect(prevItemFinder).shift(
                        Offset(
                          0,
                          itemAtNewIndexRect!.height,
                        ),
                      ),
                ),
              );
            },
          );
        });
      });

      testWidgets(
        'offset does not jump when moving an item from mounted area '
        'to unmounted area',
        (tester) async {
          // arrange
          await tester.pumpWidget(_getWidget());
          const newIndex = 10;
          // Item, which we will move, will be the second item in mounted range
          // and in this test we need to check that after item moving the
          // global position of the first mounted item did not change
          const movedItemId = '${newIndex + 2}';
          final movedItemFinder = find.byKey(
            movedItemId.vk,
            skipOffstage: false,
          );

          // act
          // 1. scrolling till the item with index [newIndex] is unmounted
          await _scrollUntilUnmounted(tester, newIndex);
          final mountedRange = itemsNotifier.mountedWidgetsIndexRange;
          final firstMountedIndex = mountedRange.start;
          final firstMountedIndexFinder = find.byKey(
            firstMountedIndex.vk,
            skipOffstage: false,
          );

          // 2. getting the position of the first mounted item
          final positionOfFirstMountedItem =
              tester.getRect(firstMountedIndexFinder);
          // 3. ensuring that item, which will be moved, is mounted
          expect(movedItemFinder, findsOneWidget);
          // 4. moving item to unmounted area
          eventController.moveById(itemId: movedItemId, newIndex: newIndex);
          // 5. Just in case checking that nothing hapenned
          await tester.pumpAndSettle();
          expect(
            tester.getRect(firstMountedIndexFinder),
            equals(positionOfFirstMountedItem),
          );
          // 6. scrolling backwards by item height
          // this should mount moved item
          scrollController.jumpTo(
            scrollController.offset - positionOfFirstMountedItem.height,
          );
          await tester.pumpAndSettle();

          // assert
          expect(
            tester.getRect(firstMountedIndexFinder),
            equals(
              positionOfFirstMountedItem.shift(
                Offset(
                  0,
                  positionOfFirstMountedItem.height,
                ),
              ),
            ),
          );
        },
      );
    });

    group('RemoveItemEvent', () {
      testWidgets(
        'removes item with animation if it is mounted',
        (tester) async {
          // arrange
          final widget = _getWidget();
          await tester.pumpWidget(widget);
          const removedItemId = '0';
          const animationConfig = AnimationControllerConfig(
            duration: Duration(milliseconds: 500),
            initialValue: 1,
            lowerBound: 0,
            uppedBound: 1,
          );
          final keyFinder = find.byKey(removedItemId.vk);

          // act
          eventController.removeById(
            itemId: removedItemId,
            animationConfig: animationConfig,
          );

          // assert
          // Paiting all frames triggered by the animation
          await tester.pumpFrames(widget, animationConfig.duration);
          // At this moment the item should still be mounted
          expect(keyFinder, findsOneWidget);
          // Paint one frame. After that the item should be unmounted from
          // the tree
          await tester.binding.pump(intervalBetweenFramePaint * 2);
          expect(keyFinder, findsNothing);
        },
      );

      testWidgets('removes item from unmounted area', (tester) async {
        // arrange
        await tester.pumpWidget(_getWidget());
        const removedItemIndex = 0;
        const itemId = '$removedItemIndex';
        final itemFinder = find.byKey(removedItemIndex.vk, skipOffstage: false);

        // act
        // scrolling until the item is unmounted
        await _scrollUntilUnmounted(tester, removedItemIndex);
        // ensuring that the item, which should be removed, is unmounted
        expect(
          itemFinder,
          findsNothing,
        );
        eventController.removeById(itemId: itemId);
        await tester.pumpAndSettle();
        // scrolling to the top
        scrollController.jumpTo(0);
        await tester.pumpAndSettle();

        // assert
        // does not find visible item
        expect(itemFinder.visibleItemsCount, equals(0));
      });

      testWidgets(
        'offset does not jump whe removing an item from unmounted area',
        (tester) async {
          // arrange
          await tester.pumpWidget(_getWidget());
          const removedItemIndex = 0;

          // act
          // scrolling until the item is unmounted
          await _scrollUntilUnmounted(tester, removedItemIndex);
          // ensuring that item, which should be removed, is unmounted
          expect(
            find.byKey(removedItemIndex.vk, skipOffstage: false),
            findsNothing,
          );
          // saving last item's rect
          final firstMountedItemFinder = find.byKey(
            itemsNotifier.mountedWidgetsIndexRange.start.vk,
            skipOffstage: false,
          );
          final rectOfFirstMountedItem = tester.getRect(firstMountedItemFinder);
          // removing the item
          eventController.removeById(itemId: removedItemIndex.toString());

          // assert
          // giving the opportunity to repaint
          await tester.pumpAndSettle();
          // check that rect of last item did not change
          expect(
            tester.getRect(firstMountedItemFinder),
            equals(rectOfFirstMountedItem),
          );
        },
      );
    });

    group('Complex(several different events)', () {
      testWidgets(
        'moving item after inserting it atop of visible area '
        '(inserted item is not mounted)',
        (tester) async {
          // arrange
          await tester.pumpWidget(_getWidget());
          final newItemId = _defaultItemsCount.toString();
          final newItemFinder = find.byKey(newItemId.vk, skipOffstage: false);

          // act
          // scrolling until the end
          // await tester.scrollUntilVisible(newItemFinder, 50);
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
          await tester.pumpAndSettle();
          eventController
            // inserting new item at zero index(atop of mounted range)
            ..insert(item: const MyModel(id: _defaultItemsCount), index: 0)
            // moving it right after adding to the last index
            // (it was not mounted yet)
            ..moveById(
              itemId: newItemId,
              newIndex: _defaultItemsCount,
            );

          // assert
          final firstMountedItemFinder = find.byKey(
            itemsNotifier.mountedWidgetsIndexRange.start.vk,
            skipOffstage: false,
          );
          // saving first mounted item rect
          final initialRect = tester.getRect(firstMountedItemFinder);
          // findsNothing, because the animation is not executed yet
          expect(newItemFinder, findsNothing);
          // awaiting for enimation end
          await tester.pumpAndSettle();
          // finds the widget
          expect(newItemFinder, findsOneWidget);
          // ensuring that the offset did not jump
          expect(tester.getRect(firstMountedItemFinder), initialRect);
        },
      );
    });
  });
}
