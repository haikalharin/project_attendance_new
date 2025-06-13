import 'dart:math';

class FaceEmbeddingModel {
  final List<double> vector;
  FaceEmbeddingModel(this.vector);

  double distanceTo(FaceEmbeddingModel other) {
    if (vector.length != other.vector.length) return double.infinity;
    double sum = 0;
    for (int i = 0; i < vector.length; i++) {
      final diff = vector[i] - other.vector[i];
      sum += diff * diff;
    }
    return sqrt(sum); // Ganti ini!
  }
}
