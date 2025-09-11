import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoDatePickerCustom extends StatefulWidget {
  const CupertinoDatePickerCustom({super.key});

  @override
  State<CupertinoDatePickerCustom> createState() =>
      _CupertinoDatePickerCustomState();
}

class _CupertinoDatePickerCustomState extends State<CupertinoDatePickerCustom> {
  DateTime? dateTime;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      height: MediaQuery.of(context).copyWith().size.height / 3,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, dateTime);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, dateTime);
                  },
                  child: const Text('Done')),
            ],
          ),
          Expanded(
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              dateOrder: DatePickerDateOrder.ymd,
              maximumYear: DateTime.now().year,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  dateTime = newDate;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
