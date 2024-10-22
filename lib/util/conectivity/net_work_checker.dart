part of '../util.dart';

@singleton
class NetWorkChecker {
  var isNetworkAvailable = false;

  StreamSubscription? _networkStateSubs;

  late final BehaviorSubject<bool> _networkAvailableStream =
      BehaviorSubject.seeded(isNetworkAvailable);
  Stream<bool> get networkAvailableStream => _networkAvailableStream;

  final _networkConditions = [
    ConnectivityResult.mobile,
    ConnectivityResult.wifi,
    ConnectivityResult.ethernet
  ];

  NetWorkChecker() {
    _networkStateSubs = Connectivity().onConnectivityChanged.listen((event) {
      isNetworkAvailable = _networkConditions.contains(event);
      _networkAvailableStream.addSafety(isNetworkAvailable);
    });
  }

  Future<void> invokeWithNetWorkChecker(BuildContext context,
      {Function()? onNetworkAvailable,
      Function()? onNetworkConnectFailed}) async {
    if (isNetworkAvailable) {
      onNetworkAvailable?.call();
      return;
    } else {
      onNetworkConnectFailed?.call();
    }
  }

  @disposeMethod
  void dispose() {
    _networkStateSubs?.cancel();
  }
}
