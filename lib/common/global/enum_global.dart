import 'dart:ui';

import 'package:flutter/material.dart';

enum DeviceStatus {
  study,
  sleep,
  play,
  restricted,
  waiting,
  online,
  offline,
  lowBattery,
  syncing,
  updating,
  commandSuccess,
  newlyAdded,
}

enum DailyDate {
  mon,
  tue,
  wed,
  thu,
  fri,
  sat,
  sun,
}

extension DailyHeaderExtension on DailyDate {
  String get label {
    switch (this) {
      case DailyDate.mon:
        return "T2";
      case DailyDate.tue:
        return "T3";
      case DailyDate.wed:
        return "T4";
      case DailyDate.thu:
        return "T5";
      case DailyDate.fri:
        return "T6";
      case DailyDate.sat:
        return "T7";
      case DailyDate.sun:
        return "CN";
    }
  }
}

extension DeviceStatusExtension on DeviceStatus {
  String get label {
    switch (this) {
      case DeviceStatus.study:
        return "Giờ học";
      case DeviceStatus.sleep:
        return "Giờ ngủ";
      case DeviceStatus.play:
        return "Giờ chơi";
      case DeviceStatus.restricted:
        return "Bị giới hạn";
      case DeviceStatus.waiting:
        return "Chờ khung giờ tiếp theo";
      case DeviceStatus.online:
        return "Online";
      case DeviceStatus.offline:
        return "Offline";
      case DeviceStatus.lowBattery:
        return "Pin yếu";
      case DeviceStatus.syncing:
        return "Đang đồng bộ";
      case DeviceStatus.updating:
        return "Đang cập nhật cấu hình";
      case DeviceStatus.commandSuccess:
        return "Đã nhận lệnh";
      case DeviceStatus.newlyAdded:
        return "Thiết bị mới";
    }
  }
}
