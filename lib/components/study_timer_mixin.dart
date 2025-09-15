// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart'; // Import cần thiết cho WidgetsBindingObserver
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:apk_pul/models/daily_study_record.dart';
// import 'package:apk_pul/utils/logger.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// mixin StudyTimerMixin<T extends ConsumerStatefulWidget> on ConsumerState<T>
//     implements WidgetsBindingObserver {
//   Timer? _timer;
//   Duration _currentStudySessionTime = Duration.zero;
//   List<DailyStudyRecord> _studyRecords = [];

//   static const String _kStudyRecordsKey = 'study_records';
//   static const int _kStartOfWeek =
//       DateTime.monday; // Đặt Thứ Hai là ngày đầu tuần

//   // Getter để các màn hình kế thừa có thể truy cập
//   Duration get currentStudySessionTime => _currentStudySessionTime;
//   List<DailyStudyRecord> get studyRecords => _studyRecords;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _loadStudyRecords();
//     _startTimer();
//   }

//   @override
//   void dispose() {
//     _stopTimerAndSave();
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.detached) {
//       _stopTimerAndSave();
//     } else if (state == AppLifecycleState.resumed) {
//       _startTimer();
//     }
//   }

//   void _startTimer() {
//     logger.f('StudyTimerMixin: Bắt đầu bộ đếm thời gian học---');
//     if (_timer != null && _timer!.isActive) {
//       return;
//     }
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       // Gọi setState của màn hình sử dụng mixin
//       if (mounted) {
//         // Đảm bảo widget vẫn còn hoạt động
//         setState(() {
//           _currentStudySessionTime += const Duration(seconds: 1);
//         });
//       }
//     });
//   }

//   void _stopTimerAndSave() {
//     if (_timer != null) {
//       _timer!.cancel();
//       _timer = null;
//     }
//     _saveStudyTime();
//   }

//   // Lấy ngày đầu tiên của tuần chứa một ngày cho trước
//   DateTime _getStartOfWeek(DateTime date) {
//     int diff = date.weekday - _kStartOfWeek;
//     if (diff < 0) {
//       diff += 7;
//     }
//     return DateTime(date.year, date.month, date.day)
//         .subtract(Duration(days: diff));
//   }

//   // Tải dữ liệu thời gian học từ SharedPreferences
//   Future<void> _loadStudyRecords() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? recordsJson = prefs.getString(_kStudyRecordsKey);

//     if (recordsJson != null) {
//       final List<dynamic> jsonList = jsonDecode(recordsJson);
//       List<DailyStudyRecord> loadedRecords =
//           jsonList.map((json) => DailyStudyRecord.fromMap(json)).toList();

//       final startOfCurrentWeek = _getStartOfWeek(DateTime.now());

//       loadedRecords = loadedRecords.where((record) {
//         return _getStartOfWeek(record.date ?? DateTime.now())
//             .isAtSameMomentAs(startOfCurrentWeek);
//       }).toList();

//       if (mounted) {
//         setState(() {
//           _studyRecords = loadedRecords;
//         });
//       }
//     }
//   }

//   // Lưu thời gian học vào SharedPreferences
//   Future<void> _saveStudyTime() async {
//     if (_currentStudySessionTime == Duration.zero) {
//       return;
//     }

//     final prefs = await SharedPreferences.getInstance();
//     final today = DateTime.now();
//     final todayOnlyDate = DateTime(today.year, today.month, today.day);

//     final startOfCurrentWeek = _getStartOfWeek(todayOnlyDate);

//     if (_studyRecords.isNotEmpty) {
//       // Sử dụng bản ghi cuối cùng đã được sắp xếp để so sánh
//       final lastRecordedDate = _studyRecords.last.date;
//       final startOfLastRecordedWeek =
//           _getStartOfWeek(lastRecordedDate ?? DateTime.now());

//       if (!startOfCurrentWeek.isAtSameMomentAs(startOfLastRecordedWeek)) {
//         print('Phát hiện tuần mới, xóa dữ liệu tuần trước.');
//         _studyRecords.clear();
//       }
//     }

//     DailyStudyRecord? existingRecord;
//     int? existingRecordIndex;

//     for (int i = 0; i < _studyRecords.length; i++) {
//       if (_studyRecords[i].date?.year == todayOnlyDate.year &&
//           _studyRecords[i].date?.month == todayOnlyDate.month &&
//           _studyRecords[i].date?.day == todayOnlyDate.day) {
//         existingRecord = _studyRecords[i];
//         existingRecordIndex = i;
//         break;
//       }
//     }

//     if (existingRecord != null) {
//       _studyRecords[existingRecordIndex!] = DailyStudyRecord(
//         date: existingRecord.date,
//         totalStudyTime: (existingRecord.totalStudyTime ?? const Duration()) +
//             _currentStudySessionTime,
//       );
//     } else {
//       _studyRecords.add(DailyStudyRecord(
//         date: todayOnlyDate,
//         totalStudyTime: _currentStudySessionTime,
//       ));
//     }

//     _studyRecords.sort((a, b) =>
//         (a.date ?? DateTime.now()).compareTo(b.date ?? DateTime.now()));

//     final String recordsJson =
//         jsonEncode(_studyRecords.map((record) => record.toMap()).toList());
//     await prefs.setString(_kStudyRecordsKey, recordsJson);

//     // Reset thời gian và cập nhật UI nếu widget còn hoạt động
//     if (mounted) {
//       setState(() {
//         _currentStudySessionTime = Duration.zero;
//       });
//     }

//     logger.i('Thời gian học đã được lưu. Bản ghi tuần hiện tại:');
//     for (var record in _studyRecords) {
//       print(record);
//     }
//   }

//   // Hàm tiện ích để định dạng thời gian (có thể đặt ở ngoài nếu muốn)
//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(duration.inHours);
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$hours:$minutes:$seconds';
//   }

//   @override
//   void didChangeAccessibilityFeatures() {
//     // TODO: implement didChangeAccessibilityFeatures
//   }

//   @override
//   void didChangeLocales(List<Locale>? locales) {
//     // TODO: implement didChangeLocales
//   }

//   @override
//   void didChangeMetrics() {
//     // TODO: implement didChangeMetrics
//   }

//   @override
//   void didChangePlatformBrightness() {
//     // TODO: implement didChangePlatformBrightness
//   }

//   @override
//   void didChangeTextScaleFactor() {
//     // TODO: implement didChangeTextScaleFactor
//   }

//   @override
//   void didChangeViewFocus(ViewFocusEvent event) {
//     // TODO: implement didChangeViewFocus
//   }

//   @override
//   void didHaveMemoryPressure() {
//     // TODO: implement didHaveMemoryPressure
//   }

//   @override
//   Future<bool> didPopRoute() {
//     // TODO: implement didPopRoute
//     throw UnimplementedError();
//   }

//   @override
//   Future<bool> didPushRoute(String route) {
//     // TODO: implement didPushRoute
//     throw UnimplementedError();
//   }

//   @override
//   Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
//     // TODO: implement didPushRouteInformation
//     throw UnimplementedError();
//   }

//   @override
//   Future<AppExitResponse> didRequestAppExit() {
//     // TODO: implement didRequestAppExit
//     throw UnimplementedError();
//   }

//   @override
//   void handleCancelBackGesture() {
//     // TODO: implement handleCancelBackGesture
//   }

//   @override
//   void handleCommitBackGesture() {
//     // TODO: implement handleCommitBackGesture
//   }

//   @override
//   bool handleStartBackGesture(PredictiveBackEvent backEvent) {
//     // TODO: implement handleStartBackGesture
//     throw UnimplementedError();
//   }

//   @override
//   void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {
//     // TODO: implement handleUpdateBackGestureProgress
//   }
// }
