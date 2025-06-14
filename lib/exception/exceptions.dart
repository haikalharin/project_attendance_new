class CacheException implements Exception {}

class ApiException implements Exception {}

class BadNetworkException implements Exception {}

class InternalServerException implements Exception {}

class UnauthenticatedException implements Exception {
  final String errorMessage;

  UnauthenticatedException({required this.errorMessage});
}

class ApiErrorMessageException implements Exception {
  final String errorMessage;

  ApiErrorMessageException({required this.errorMessage});
}
