import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tap_two_play/components/custom_time_picker.dart';
import 'package:tap_two_play/utils/app_text_style.dart';
import 'package:tap_two_play/utils/utils.dart';

class Dialogs with Utils {
  Dialogs(this.context);
  final BuildContext context;

  /// returns `true` when user select "OK".
  Future<bool> showConfirmDialog(String message) async {
    final dialogResult = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Oke'),
            ),
          ],
        );
      },
    );

    // when user cancel dialog, dialogResult is null.
    return dialogResult ?? false;
  }

  Future<void> showError(
    String? error, {
    Function? onPress,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          content: Text(error ?? ''),
          actions: [
            TextButton(
              onPressed: () {
                if (onPress == null) {
                  Navigator.pop(context, true);
                } else {
                  onPress();
                }
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> cupertioDialog({
    String? title,
    String? content,
    required VoidCallback yesAction,
  }) async {
    final dialogResult = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title ?? ''),
          content: Text(content ?? ''),
          actions: [
            CupertinoDialogAction(
              child: const Text("YES"),
              onPressed: () {
                yesAction();
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
    // when user cancel dialog, dialogResult is null.
    return dialogResult ?? false;
  }
}

class ShowSimpleDialog with Utils {
  ShowSimpleDialog._();

  static Future<void> showAlertDialog(BuildContext context) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Lỗi'),
        content: const Text('Tiêu đề và ảnh không được để trống'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Oke'),
          ),
        ],
      ),
    );
  }

  static Future<dynamic> topShowGeneralDialog(
    BuildContext context, {
    required Widget childWidget,
  }) async {
    final result = await showGeneralDialog<dynamic>(
      context: context,
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, _, __) {
        return childWidget;
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: const Offset(0, -1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
    return result;
  }

  static Future<dynamic> showBottomSheetCustom(BuildContext context) async {
    final result = showBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => Card(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: const Center(
            child: Text("This is a modal sheet"),
          ),
        ),
      ),
    );
    return result;
  }

  static void actionSheet(
    BuildContext context, {
    required VoidCallback onTapDelete,
    required VoidCallback onTapEdit,
  }) async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              onTapEdit();
            },
            child: Text(
              'Chỉnh sửa',
              style: AppTextStyles.defaultMedium.copyWith(
                color: Colors.blue,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// default behavior, turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              onTapDelete();
            },
            child: Text(
              'Xoá',
              style: AppTextStyles.defaultMedium,
            ),
          ),
          CupertinoActionSheetAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as delete or exit and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Huỷ',
              style: AppTextStyles.defaultMedium.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> fullScreenDialog(BuildContext context) async {
    await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (
          BuildContext buildContext,
          Animation animation,
          Animation secondaryAnimation,
        ) {
          return Center(
            child: Container(
              // height: MediaQuery.of(context).size.height - 80,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  )
                ],
              ),
            ),
          );
        });
  }

  static Future<TimeOfDay?> showtimePickerBottomSheetCustom(
    BuildContext context,
  ) async {
    TimeOfDay? initialTime;
    final result = await showModalBottomSheet<TimeOfDay>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.7,
        child: StatefulBuilder(builder: (context, setState) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: AppTextStyles.defaultFont,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, initialTime);
                        },
                        child: Text(
                          'Save',
                          style: AppTextStyles.defaultFont.copyWith(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                CustomTimePicker(
                  onTimeChanged: (time) {
                    setState(() {
                      initialTime = time;
                    });
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
    return result;
  }
}
