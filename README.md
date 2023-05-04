
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

Scrollable widget, which lets you easily animate its items list modifications(insert, remove, move, etc.).

## **Disclaimer**
_Be careful using this package in production because there are still many untested cases. Also GridView and PageView are not very useful yet._

## **[LIVE DEMO](https://radomir9720.github.io/animated_scroll_view/#/)**
_Examples(from live demo) can be found [here][live_demo_examples_link].
Real application examples can be found [here][real_app_example_link1] and [here][real_app_example_link2]_

Mainly, developed as a replacement for out-of-the-box animated scrollables:

- `AnimatedList`
- `SliverAnimatedList`
- `AnimatedGrid` (available from flutter version 3.7.0)
- `SliverAnimatedGrid` (available from flutter version 3.7.0)

because of their numerous disadvantages:

- Scroll offset jumps when an item is built atop(outside) of the current
layout(Issue [#74031](https://github.com/flutter/flutter/issues/74031)).
- Out-of-the-box animated scrollables have inconvinient API, developer
is required to write a lot of code to make it work
- There is a lot of cases when developer can forget/miss something to setup,
and, as a result, lose a lot of time figuring out what's wrong(e.g. [#63185](https://github.com/flutter/flutter/issues/63185))
- `AnimatedGrid` and `SliverAnimatedGrid` are not available if you are using
flutter version below 3.7.0

Also, `AnimatedPageView` widget can be useful for you, as it does not have an out of the box analogue.

There are already implementations-replacements for each of the
out-of-the-box animated scrollables mentioned above:

- `AnimatedListView` (replacement for `AnimatedList`)
- `SliverAnimatedListView` (replacement for `SliverAnimatedList`)
- `AnimatedGridView` (replacement for `AnimatedGrid`)
- `SliverAnimatedGridView` (replacement for `SliverAnimatedGrid`)

Also, you can extend `AnimatedScrollView`, and create your own
implementation, using the API of this package.

## TODO:

Status  |Task Name
:------:|----
✅|Simultaneously removing and inserting item when moving([#35618](https://github.com/flutter/flutter/issues/35618))
✅|Write documentation
⬜|For `GridView` and `PageView`: animate items, rebuild of which is caused by another items modification event
✅|Set default axis for `SizeAndFadeTransition` to axis of the scrollable([#100931](https://github.com/flutter/flutter/issues/100931#issuecomment-1120515790))
⬜|Cover all code with tests
✅|AnimatedPageView([#58959](https://github.com/flutter/flutter/issues/58959))?
✅|Wrap ItemWidget in `SizedAndFadeTransition` and `PointerIgnorer` by default?
✅|Widgetbook with live demo examples

## Installation 💻

Add `animated_scroll_view` to your `pubspec.yaml`:

```
flutter pub add animated_scroll_view
```

or manually:

```yaml
dependencies:
  animated_scroll_view: ^<latest version>
```

Install it:

```sh
flutter packages get
```

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[real_app_example_link1]: https://github.com/radomir9720/pixel_app_flutter/blob/0.5.0/lib/presentation/screens/apps/body/handset_apps_screen_body.dart
[real_app_example_link2]: https://github.com/radomir9720/pixel_app_flutter/blob/0.5.0/lib/presentation/screens/apps/body/tablet_apps_screen_body.dart
[live_demo_examples_link]: https://github.com/radomir9720/animated_scroll_view/tree/main/widgetbook_app/lib/widgets/scrollables