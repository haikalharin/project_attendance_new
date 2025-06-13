import 'dart:ui';

class DetectedFaceModel {
  final double left;
  final double top;
  final double right;
  final double bottom;

  DetectedFaceModel({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  factory DetectedFaceModel.fromRect(Rect rect) {
    return DetectedFaceModel(
      left: rect.left,
      top: rect.top,
      right: rect.right,
      bottom: rect.bottom,
    );
  }

  Rect toRect() {
    return Rect.fromLTRB(left, top, right, bottom);
  }
}
