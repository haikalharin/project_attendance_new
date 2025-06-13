

class ServerException implements Exception {
  final String? error;
  final StackTrace stacktrace;

  ServerException(this.error, this.stacktrace);

  @override
  String toString() {
    if (error == null) return "ServerException";


      // /// record error to firebase
      // FirebaseCrashlytics.instance.recordError(
      //   error,
      //   StackTrace.fromString(stacktrace.toString()),
      //   reason: "ServerException",
      //   fatal: false,
      // );

    //Logger.printLog('[i] ServerException');
    //Logger.printLog('[x] ERROR: $error');
    return "[>] STACKTRACE: $stacktrace";
  }
}
