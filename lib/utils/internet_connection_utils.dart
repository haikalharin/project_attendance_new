// import 'dart:async';
//
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:rxdart/rxdart.dart';
//
// /// Check connection internet status and return [InternetConnectionStatus]
// /// please be aware that you need to call [stopMonitoring] in order to prevent memory leak
// /// You can custom host to lookup with [AddressCheckOption], set check interval, and set
// /// the slow connection threshold duration with [SlowConnectionConfig]
// class InternetConnectionUtils {
//   static final InternetConnectionUtils _instance =
//       InternetConnectionUtils._internal();
//
//   InternetConnectionUtils._internal();
//
//   factory InternetConnectionUtils() {
//     return _instance;
//   }
//
//   final _internetConnectionChecker = InternetConnectionChecker.createInstance(
//       checkInterval: Duration(minutes: 2),
//       addresses: [
//         AddressCheckOption(uri: Uri.parse("https://www.google.com/")),
//       ],
//       slowConnectionConfig: SlowConnectionConfig(
//         enableToCheckForSlowConnection: true,
//       ));
//
//   final BehaviorSubject<InternetConnectionStatus>
//       _internetConnectionController =
//       BehaviorSubject<InternetConnectionStatus>();
//
//   /// Stream getter
//   Stream<InternetConnectionStatus> get connectivityStream =>
//       _internetConnectionController.stream;
//
//   StreamSubscription<InternetConnectionStatus>? _statusChangeSubscription;
//
//   Future<void> startMonitoring() async {
//     final hasConnection = await _internetConnectionChecker.hasConnection;
//     final initialStatus = hasConnection
//         ? InternetConnectionStatus.connected
//         : InternetConnectionStatus.disconnected;
//
//     if (!_internetConnectionController.isClosed) {
//       _internetConnectionController.add(initialStatus);
//     }
//
//     _statusChangeSubscription =
//         _internetConnectionChecker.onStatusChange.listen((event) {
//       if (!_internetConnectionController.isClosed) {
//         _internetConnectionController.add(event);
//       }
//     });
//   }
//
//   void stopMonitoring() {
//     _statusChangeSubscription?.cancel();
//     _statusChangeSubscription = null;
//
//     if (!_internetConnectionController.isClosed) {
//       _internetConnectionController.close();
//     }
//   }
// }
