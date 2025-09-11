import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_two_play/utils/app_colors.dart';
import 'package:tap_two_play/utils/app_text_style.dart';
import 'package:tap_two_play/utils/utils.dart';

final yearProvider = StateProvider<String?>((ref) {
  return '';
});
final monthProvider = StateProvider<String?>((ref) {
  return '';
});

enum TypePicker { year, month }

class DatePickerCustom extends ConsumerStatefulWidget {
  const DatePickerCustom({
    super.key,
    required this.input,
    this.typePicker = TypePicker.year,
  });
  final List<int> input;
  final TypePicker typePicker;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DatePickerCustomState();
}

class _DatePickerCustomState extends ConsumerState<DatePickerCustom>
    with Utils {
  late FixedExtentScrollController scrollController;
  late int currentIndex;
  @override
  void initState() {
    super.initState();
    scrollController = FixedExtentScrollController();

    currentIndex = _getCurrentIndex();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getCurrentInde());
  }

  Future<void> _getCurrentInde() async {
    Future.delayed(const Duration(milliseconds: 50), () {
      scrollController.jumpToItem(currentIndex);
    });
  }

  int _getCurrentIndex() {
    final index = widget.typePicker == TypePicker.year
        ? DateTime.now().year
        : DateTime.now().month;
    return widget.input.indexOf(index);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListWheelScrollView(
        physics: const FixedExtentScrollPhysics(),
        itemExtent: 42,
        diameterRatio: 6,
        useMagnifier: true,
        onSelectedItemChanged: (index) {
          setState(() {
            currentIndex = index;
            if (widget.typePicker == TypePicker.month) {
              ref.read(monthProvider.notifier).state =
                  widget.input[currentIndex].toString();
              return;
            }

            ref.read(yearProvider.notifier).state =
                widget.input[currentIndex].toString();
          });
        },
        controller: scrollController,
        children: List.generate(widget.input.length, (index) {
          final isSelect = currentIndex == index;
          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: !isSelect
                  ? null
                  : const Border.symmetric(
                      horizontal: BorderSide(color: AppColors.grey969696),
                    ),
            ),
            child: Text(
              widget.typePicker == TypePicker.month
                  ? 'Tháng ${widget.input[index]}'
                  : widget.input[index].toString(),
              style: AppTextStyles.defaultMedium.copyWith(
                color: AppColors.black1.withOpacity(isSelect ? 1 : 0.5),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class PickerData {
  final String? month;
  final String? year;

  PickerData({this.month, this.year});

  PickerData copyWith({
    String? month,
    String? year,
  }) {
    return PickerData(
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  @override
  String toString() => 'PickerData(month: $month, year: $year)';
}
