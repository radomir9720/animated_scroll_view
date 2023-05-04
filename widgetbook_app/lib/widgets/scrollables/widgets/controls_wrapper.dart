import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_app/utils/snack_bar.dart';
import 'package:widgetbook_app/widgets/scrollables/models/modification_state.dart';
import 'package:widgetbook_app/widgets/scrollables/models/my_model.dart';
import 'package:widgetbook_app/widgets/scrollables/widgets/enter_index_text_field.dart';
import 'package:widgetbook_app/widgets/scrollables/widgets/move_item_form.dart';

class AnimatedScrollViewControlsWrapper extends StatefulWidget {
  const AnimatedScrollViewControlsWrapper({
    Key? key,
    required this.viewBuilder,
    this.itemCount = 50,
    this.forceNotifyOnMoveAndRemove = false,
  }) : super(key: key);

  @protected
  final bool forceNotifyOnMoveAndRemove;

  @protected
  final int itemCount;

  @protected
  final Widget Function(
    ItemsNotifier<MyModel> itemsNotifier,
    EventController<MyModel> eventController,
    List<MyModel> items,
  ) viewBuilder;

  @override
  State<AnimatedScrollViewControlsWrapper> createState() =>
      _AnimatedScrollViewControlsWrapper();
}

class _AnimatedScrollViewControlsWrapper
    extends State<AnimatedScrollViewControlsWrapper> {
  final eventController = DefaultEventController<MyModel>();
  final modificationNotifier =
      ValueNotifier<ModificationState>(const ModificationState.initial());
  final itemsNotifier = DefaultItemsNotifier<MyModel>();

  late List<MyModel> items;

  late int biggestIndex;

  @override
  void initState() {
    super.initState();
    biggestIndex = widget.itemCount - 1;
    items = List.generate(
      widget.itemCount,
      (index) => MyModel(
        id: index,
        color: Colors.primaries[index % Colors.primaries.length],
      ),
    );
  }

  @override
  void dispose() {
    eventController.close();
    itemsNotifier.dispose();
    modificationNotifier.dispose();
    super.dispose();
  }

  bool checkItemIdExists(int itemId) {
    try {
      itemsNotifier.getIndexById(itemId.toString());
      return true;
    } on ItemNotFoundException catch (_) {
      context.showSnackBar('Item with id "$itemId" not found!');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.viewBuilder(
        itemsNotifier,
        eventController,
        items,
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ValueListenableBuilder<ModificationState>(
          valueListenable: modificationNotifier,
          builder: (context, state, child) {
            return state.when(
              initial: () {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        modificationNotifier.value =
                            const ModificationState.insert();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Insert'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        modificationNotifier.value =
                            const ModificationState.delete();
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        modificationNotifier.value =
                            const ModificationState.move();
                      },
                      icon: const Icon(Icons.move_down),
                      label: const Text('Move'),
                    ),
                  ],
                );
              },
              insert: () {
                return EnterIndexTextField(
                  buttonLabel: 'Insert',
                  onButtonPressed: (value) {
                    final length = itemsNotifier.value.length;
                    eventController.add(
                      InsertAdaptiveItemEvent(
                        item: MyModel(
                          id: ++biggestIndex,
                          color: Colors
                              .primaries[length % Colors.primaries.length],
                        ),
                        index: value,
                      ),
                    );
                    modificationNotifier.value =
                        const ModificationState.initial();
                  },
                );
              },
              delete: () {
                return EnterIndexTextField(
                  buttonLabel: 'Delete',
                  onButtonPressed: (value) {
                    if (!checkItemIdExists(value)) return;
                    eventController.add(
                      RemoveAdaptiveItemEvent.byId(
                        itemId: value.toString(),
                        forceNotify: widget.forceNotifyOnMoveAndRemove,
                      ),
                    );
                    modificationNotifier.value =
                        const ModificationState.initial();
                  },
                );
              },
              move: () {
                return MoveItemForm(
                  onPressed: (itemId, newIndex) {
                    if (!checkItemIdExists(itemId)) return;
                    eventController.add(
                      MoveAdaptiveItemEvent.byId(
                        itemId: itemId.toString(),
                        newIndex: newIndex,
                        forceNotify: widget.forceNotifyOnMoveAndRemove,
                      ),
                    );
                    modificationNotifier.value =
                        const ModificationState.initial();
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
