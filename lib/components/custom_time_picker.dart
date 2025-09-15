import 'package:apk_pul/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final ValueChanged<TimeOfDay> onTimeChanged;
  final TimeOfDay initialTime;

  const CustomTimePicker({
    super.key,
    required this.onTimeChanged,
    this.initialTime = const TimeOfDay(hour: 1, minute: 0),
  });

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute;

    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController =
        FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: [
          const Positioned(top: 65, left: 0, right: 0, child: Divider()),
          const Positioned(top: 120, left: 0, right: 0, child: Divider()),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hour Picker
              _buildTimeWheel(
                _hourController,
                _selectedHour,
                (index) {
                  setState(() {
                    _selectedHour = index % 24;
                    widget.onTimeChanged(TimeOfDay(
                        hour: _selectedHour, minute: _selectedMinute));
                  });
                },
                24, // 24 giờ
                (value) => value.toString().padLeft(2, '0'),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  ':',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              // Minute Picker
              _buildTimeWheel(
                _minuteController,
                _selectedMinute,
                (index) {
                  setState(() {
                    _selectedMinute = index % 60;
                    widget.onTimeChanged(TimeOfDay(
                        hour: _selectedHour, minute: _selectedMinute));
                  });
                },
                60, // 60 phút
                (value) => value.toString().padLeft(2, '0'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeWheel(
      FixedExtentScrollController controller,
      int selectedValue,
      Function(int) onSelectedItemChanged,
      int itemCount,
      String Function(int) displayFormatter) {
    return SizedBox(
      width: 80,
      height: 200,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 60,
        perspective: 0.005,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            // Lặp lại để tạo hiệu ứng vô hạn
            final value = index % itemCount;
            final isSelected = value == selectedValue;
    
            return Center(
              child: Text(
                displayFormatter(value),
                style: AppTextStyles.defaultBoldAppBar.copyWith(
                  fontSize: isSelected ? 38 : 28,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.deepPurple[700] : Colors.grey[400],
                ),
              ),
            );
          },
          childCount: itemCount * 200,
        ),
      ),
    );
  }
}
