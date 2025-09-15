import 'dart:math' as math;

import 'package:apk_pul/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DataUsageHalfCirclePainter extends CustomPainter {
  final double percentage;
  final double usedAmountGB;
  final double totalAmountGB;
  final double sizeOfSquare;
  final double strokeWidth;

  DataUsageHalfCirclePainter({
    this.sizeOfSquare = 100.0,
    required this.percentage,
    required this.usedAmountGB,
    required this.totalAmountGB,
    this.strokeWidth = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    size = Size(sizeOfSquare, sizeOfSquare);

    final Offset center = Offset(size.width / 2, size.height);

    final double radius = size.width / 2;

    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    const double startAngle = math.pi; //

    const double sweepAngleTotal = math.pi;

    final double sweepAngleUsed = sweepAngleTotal * percentage;

    final Paint remainingPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, startAngle, sweepAngleTotal, false, remainingPaint);

    final Paint usedPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, startAngle, sweepAngleUsed, false, usedPaint);

    final String usedText = '${usedAmountGB.toStringAsFixed(0)} Phút';
    final String totalText = 'of ${totalAmountGB.toStringAsFixed(0)} used';

    final TextPainter usedTextPainter = TextPainter(
      text: TextSpan(
        text: usedText,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    usedTextPainter.layout();

    final TextPainter totalTextPainter = TextPainter(
      text: TextSpan(
        text: totalText,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 16,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    totalTextPainter.layout();

    final double textCenterX = center.dx - usedTextPainter.width / 2;
    final double usedTextCenterY = center.dy - radius + 30;
    final double totalTextCenterY =
        usedTextCenterY + usedTextPainter.height + 5;

    usedTextPainter.paint(canvas, Offset(textCenterX, usedTextCenterY));
    totalTextPainter.paint(canvas,
        Offset(center.dx - totalTextPainter.width / 2, totalTextCenterY));
  }

  @override
  bool shouldRepaint(covariant DataUsageHalfCirclePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.usedAmountGB != usedAmountGB ||
        oldDelegate.totalAmountGB != totalAmountGB;
  }
}
