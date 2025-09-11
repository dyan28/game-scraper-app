import 'package:flutter/material.dart';

extension StringX on String {
  String get overflow => Characters(this)
      .replaceAll(Characters(''), Characters('\u{200B}'))
      .toString();

  dynamic toStringExtension() {
    return isEmpty ? null : toString();
  }

  String formatImageName() {
    return replaceAll(RegExp(' +'), ' ').trim().replaceAll('\n', '');
  }

  String toSentenceCase() {
    if (isEmpty) {
      return '';
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String removeLeadingSlashes() {
    String result = this; // Bắt đầu với chuỗi gốc

    // Loại bỏ dấu gạch chéo '/' hoặc '\' ở ĐẦU chuỗi
    while (result.isNotEmpty &&
        (result.startsWith('/') || result.startsWith('\\'))) {
      result = result.substring(1); // Cắt bỏ ký tự đầu tiên
    }

    // Loại bỏ dấu gạch chéo '/' hoặc '\' ở CUỐI chuỗi
    while (
        result.isNotEmpty && (result.endsWith('/') || result.endsWith('\\'))) {
      result = result.substring(0, result.length - 1); // Cắt bỏ ký tự cuối cùng
    }

    return result;
  }
}
