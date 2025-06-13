import 'package:flutter/material.dart';
import '../model/detected_face_model.dart';

class FacePainter extends CustomPainter {
  final List<DetectedFaceModel> faces;
  final Size imageSize;
  final bool isCameraFront;

  FacePainter({
    required this.faces,
    required this.imageSize,
    required this.isCameraFront,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    for (var face in faces) {
      final rect = _scaleRect(
        rect: face.toRect(),
        imageSize: imageSize,
        widgetSize: size,
      );

      canvas.drawRect(rect, paint);
    }
  }

  Rect _scaleRect({
    required Rect rect,
    required Size imageSize,
    required Size widgetSize,
  }) {
    final scaleX = widgetSize.width / imageSize.width;
    final scaleY = widgetSize.height / imageSize.height;

    final left = isCameraFront
        ? widgetSize.width - rect.right * scaleX
        : rect.left * scaleX;

    return Rect.fromLTWH(
      left,
      rect.top * scaleY,
      rect.width * scaleX,
      rect.height * scaleY,
    );
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) => true;
}
