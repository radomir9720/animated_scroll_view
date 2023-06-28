import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook/widgetbook.dart';

import 'main.directories.g.dart';

void main() => runApp(const AnimatedScrollViewApp());

@widgetbook.App()
class AnimatedScrollViewApp extends StatelessWidget {
  const AnimatedScrollViewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      addons: [
        DeviceFrameAddon(
          initialDevice: Devices.ios.iPhoneSE,
          devices: [
            Devices.ios.iPhoneSE,
            Devices.ios.iPhone12ProMax,
            Devices.ios.iPad12InchesGen4,
            Devices.android.samsungGalaxyS20,
            Devices.android.samsungGalaxyNote20,
            Devices.macOS.macBookPro,
            Devices.ios.iPad,
          ],
        ),
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme<ThemeData>(
              name: 'Light',
              data: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                colorScheme: const ColorScheme.light(
                  primary: Colors.blueAccent,
                  background: Colors.white,
                  onPrimary: Colors.black,
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            WidgetbookTheme<ThemeData>(
              name: 'Dark',
              data: ThemeData(
                scaffoldBackgroundColor: Colors.grey.shade900,
                colorScheme: ColorScheme.dark(
                  primary: Colors.blueAccent,
                  onPrimary: Colors.white,
                  background: Colors.grey.shade900,
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
