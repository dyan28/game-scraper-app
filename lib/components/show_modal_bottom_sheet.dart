import 'package:flutter/material.dart';

import 'cupertino_date_picker.dart';

class DialogUtil {
  static Future<DateTime?> cupertinoDatePicker(BuildContext context) async {
    final result = await showModalBottomSheet<DateTime>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => const CupertinoDatePickerCustom(),
    );
    return result;
  }
}
