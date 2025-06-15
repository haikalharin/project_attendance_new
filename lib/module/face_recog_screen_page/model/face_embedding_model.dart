import 'dart:math';

class FaceEmbeddingModel {
  final List<double> features;

  FaceEmbeddingModel(this.features);

  double distanceTo(FaceEmbeddingModel other) {
    if (features.length != other.features.length) return double.infinity;

    double sum = 0;
    for (int i = 0; i < features.length; i++) {
      sum += (features[i] - other.features[i]) * (features[i] - other.features[i]);
    }
    return sqrt(sum);
  }


  // Optional: untuk debug
  Map<String, dynamic> toJson() => {
    'features': features,
  };
}
