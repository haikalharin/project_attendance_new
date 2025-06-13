import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';


/// Monitor device connection source only that states in [ConnectivityResult].
/// Please be mind that this class **not monitoring internet** connection
/// If you want monitor internet connection please refer to [InternetConnectionUtils]
/// that extend usability of this features.
class ConnectionUtils {
  static final ConnectionUtils _instance = ConnectionUtils._internal();

  ConnectionUtils._internal();

  factory ConnectionUtils() {
    return _instance;
  }

  static Future<bool> isNetworkConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    bool hasMobileOrWifi =
        connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.wifi);

    if (hasMobileOrWifi) {
      return true;
    } else {
      return false;
    }
  }

  /// Reactive connectivity monitoring using Rx Dart
  final Connectivity _connectivity = Connectivity();

  final BehaviorSubject<List<ConnectivityResult>> _connectivityController =
      BehaviorSubject<List<ConnectivityResult>>();

  /// Stream getter
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivityController.stream;

  /// Start monitoring
  Future<void> startMonitoring() async {
    await _connectivity.checkConnectivity().then(_connectivityController.add);

    _connectivity.onConnectivityChanged.listen(
      (result) {
        if (!_connectivityController.isClosed) {
          _connectivityController.add(result);
        }
      },
    );
  }

  /// Stop monitoring
  void stopMonitoring() {
    if (!_connectivityController.isClosed) {
      _connectivityController.close();
    }
  }
}
