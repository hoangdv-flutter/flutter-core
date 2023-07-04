import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@singleton
class NetWorkChecker {
  var isNetworkAvailable = false;

  StreamSubscription? _networkStateSubs;

  final _networkConditions = [
    ConnectivityResult.mobile,
    ConnectivityResult.wifi,
    ConnectivityResult.ethernet
  ];

  NetWorkChecker() {
    _networkStateSubs = Connectivity().onConnectivityChanged.listen((event) {
      isNetworkAvailable = _networkConditions.contains(event);
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
