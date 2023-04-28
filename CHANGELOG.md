# 0.5.1
* fix: `idMapper` not assigned to `ItemsEntity` after calling `ItemsNotifier.updateValue()`
* fix: item not marked as removed on move event when index did not changed

# 0.5.0

* chore: new `DefaultItemsNotifier` logic(fixes found issues)
* docs: document all public members
* feat: added extensions on `EventController` for easily adding new events
* test: added some tests for `AnimatedListView`
* fix(widgetbook): wrap SliverAnimatedLListView in CustomScrollView
  
# 0.4.0

* feat: added AnimatedPageView widget
* chore: made all widgets expanded by default on widgetbook app
* chore: added use case to widgetbook app for AnimatedPageView

# 0.3.0
* feat: added widgetbook app with examples
* ci: added workflow, which builds the widgetbook app
* chore: updated package exports
* chore: replace `addPostFrameCallback` with `Future.microtask`
* refactor: made `ItemAndItemIdConstructors` descendant of `ModificationEvent`
* refactor: made Move and Remove events descendants of `ModificationEventWithItemAndItemIdConstructors`
* fix: before doing any modification check if index is valid(for Insert and Move events)
* fix: add `cachedAnimationValue` in `InsertItemEvent`
* refactor: move scrollable folder to widgets folder
* refactor: move `AnimatedItemWidget` to widgets folder
* chore: added generated files to gitignore

# 0.2.0

* fix: no remove animation starting with second item remove
* refactor: removed `Debouncer`
* style: `Animation<double>` replaced with `DoubleAnimation` typedef

# 0.1.0

* feat: initial version(pre-release)
