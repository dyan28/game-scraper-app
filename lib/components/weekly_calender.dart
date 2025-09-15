import 'package:apk_pul/components/show_modal_bottom_sheet.dart';
import 'package:apk_pul/generated/assets.gen.dart';
import 'package:apk_pul/utils/app_colors.dart';
import 'package:apk_pul/utils/datetime_extention.dart';
import 'package:apk_pul/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CalenderItem extends StatefulWidget {
  const CalenderItem({super.key});

  @override
  State<CalenderItem> createState() => _CalenderItemState();
}

class _CalenderItemState extends State<CalenderItem> with Utils {
  late DateTime currentTime;
  DateTime? selectTime;
  DateTime? initMonth;

  late AutoScrollController controller;
  final allDate = DateTime.now().getAllDatesInMonth();
  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();

    controller = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index =
          allDate.indexWhere((element) => element.day == currentTime.day);
      _scrollToCounter(index);
    });
  }

  void _onSelectDate(DateTime dateTime) {
    setState(() {
      selectTime = dateTime;
    });
  }

  void _scrollToCounter(int counter) {
    controller.scrollToIndex(counter,
        preferPosition: AutoScrollPosition.middle);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    )),
                width: 40,
                child: GestureDetector(
                  onTap: () async {
                    initMonth = await DialogUtil.cupertinoDatePicker(context);
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        Assets.svg.icDatePicker.path,
                        height: 15,
                      ),
                      Text('${initMonth?.month ?? currentTime.month}'),
                    ],
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(width: 4),
              Expanded(flex: 5, child: _buildDatePicker()),
            ],
          ),
          const Divider(
            thickness: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    final now = DateTime.now();
    return SizedBox(
      width: 200,
      height: 40,
      child: ListView.builder(
        itemCount: allDate.length,
        shrinkWrap: true,
        controller: controller,
        reverse: true,
        dragStartBehavior: DragStartBehavior.down,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final day = DateFormat.E().format(allDate[index]);
          final number = DateFormat.d().format(allDate[index]);
          return GestureDetector(
            onTap: () {
              _onSelectDate(allDate[index]);
              _scrollToCounter(index);
            },
            child: _wrapScrollTag(
              index: index,
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        (now.day == allDate[index].day && selectTime == null) ||
                                (selectTime ?? DateTime.now())
                                    .isAtSameMomentAs(allDate[index])
                            ? Colors.blue
                            : Colors.white,
                  ),
                  width: 45,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    children: [
                      Text(day),
                      Text(number),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _wrapScrollTag({required int index, required Widget child}) =>
      AutoScrollTag(
        key: ValueKey(index),
        controller: controller,
        index: index,
        highlightColor: Colors.black.withOpacity(0.1),
        child: child,
      );
}
