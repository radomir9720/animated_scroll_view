import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@WidgetbookApp.material(
  name: 'animated_scroll_view',
  foldersExpanded: true,
  devices: [
    Apple.iPhoneSE2016,
    Apple.iPhoneSE2020,
    Apple.iPhone11ProMax,
    Apple.iPadPro12inch,
    Samsung.s10,
    Samsung.s21ultra,
    Apple.macBook13Inch,
    Apple.iPad10Inch,
  ],
)
class AnimatedScrollViewApp {}

@WidgetbookTheme(name: 'Light', isDefault: true)
ThemeData getDarkTheme() => ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Colors.blueAccent,
        background: Colors.white,
        onPrimary: Colors.black,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );

@WidgetbookTheme(name: 'Dark')
ThemeData getLightTheme() => ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade900,
      colorScheme: ColorScheme.dark(
        primary: Colors.blueAccent,
        onPrimary: Colors.white,
        background: Colors.grey.shade900,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
