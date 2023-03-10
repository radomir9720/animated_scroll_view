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

void main() {
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
          await tester.pump();

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
    });
  });
}
