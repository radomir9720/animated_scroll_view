# 1.0.2
* **FIX**: `DefaultItemsNotifier().updateValue()` incorrect items equality check
* **FIX**: incorrect index when moving an item that should be inserted to greater index
* **FIX**: added forgotten `itemWrapper` and `itemsAnimationController` parameters to scrollables
* **FIX(SizeAndFadeTransition)**: do not throw exception if there is no `Scrollable` ancestor

# 1.0.1
* **FIX**: last item is inserted without animation by `InserAllItemsEvent`
* **CI**: fix publishing workflow
* **DOCS**: updated readme

# 1.0.0
* **BREAKING FEAT**: animate items, rebuild of which is caused by another items modification event *(breaking change: added `scrollViewType` parameter to `ModificationEvent.execute()` method)*
* **FEAT**: added new events: 
  - `InsertAllItemsEvent`
  - `InsertInfluencedItemEvent` 
  - `InsertAdaptiveItemEvent` 
  - `RemoveInfluencedItemEvent`
  - `RemoveAdaptiveItemEvent`
  - `MoveInfluencedItemEvent`
  - `MoveAdaptiveItemEvent`
* **CHORE**: migration to flutter 3.7 small changes
* **CI**: added workflow which publishes the package to pub.dev
* **CI**: bump flutter version to 3.7.12

# 0.5.2
* **FEAT**: determine the axis of SizeTransition under the hood
* **FEAT**(widgetbook): added axis knob for all scrollable widgets

# 0.5.1
* **FIX**: `idMapper` not assigned to `ItemsEntity` after calling `ItemsNotifier.updateValue()`
* **FIX**: item not marked as removed on move event when index did not changed

# 0.5.0

* **CHORE**: new `DefaultItemsNotifier` logic(fixes found issues)
* **DOCS**: document all public members
* **FEAT**: added extensions on `EventController` for easily adding new events
* **TEST**: added some tests for `AnimatedListView`
* **FIX**(widgetbook): wrap SliverAnimatedLListView in CustomScrollView
  
# 0.4.0

* **FEAT**: added AnimatedPageView widget
* **CHORE**: made all widgets expanded by default on widgetbook app
* **CHORE**: added use case to widgetbook app for AnimatedPageView

# 0.3.0
* **FEAT**: added widgetbook app with examples
* **CI**: added workflow, which builds the widgetbook app
* **CHORE**: updated package exports
* **CHORE**: replace `addPostFrameCallback` with `Future.microtask`
* **REFACTOR**: made `ItemAndItemIdConstructors` descendant of `ModificationEvent`
* **REFACTOR**: made Move and Remove events descendants of `ModificationEventWithItemAndItemIdConstructors`
* **FIX**: before doing any modification check if index is valid(for Insert and Move events)
* **FIX**: add `cachedAnimationValue` in `InsertItemEvent`
* **REFACTOR**: move scrollable folder to widgets folder
* **REFACTOR**: move `AnimatedItemWidget` to widgets folder
* **CHORE**: added generated files to gitignore

# 0.2.0

* **FIX**: no remove animation starting with second item remove
* **REFACTOR**: removed `Debouncer`
* **STYLE**: `Animation<double>` replaced with `DoubleAnimation` typedef

# 0.1.0

* **FEAT**: initial version(pre-release)
