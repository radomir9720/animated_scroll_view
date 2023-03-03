import 'package:flutter/widgets.dart';
import 'package:widgetbook_app/utils/snack_bar.dart';

extension TryParseIntExtension on BuildContext {
  T? tryParseInt<T>(String str, T Function(int number) onSuccess) {
    final number = int.tryParse(str);
    if (number == null) {
      showSnackBar('Invalid index');
      return null;
    }
    return onSuccess(number);
  }
}
