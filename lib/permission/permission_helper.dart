import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> checkPermissionSupport(List<Permission> permissions,
      {Future<void> Function()? openAppSetting}) async {
    var permission = await _checkPermissionSupport(permissions);
    if (!permission) {
      if (!await _shouldShowPermissionSupport(permissions)) {
        await openAppSetting?.call();
        permission = await _checkPermissionSupport(permissions);
        return permission;
      } else {
        permission = await _requestPermissionSupport(permissions);
      }
    }
    if (!permission) {
      await openAppSetting?.call();
      permission = await _checkPermissionSupport(permissions);
    }
    return permission;
  }

  static Future<bool> _requestPermissionSupport(
      List<Permission> permissions) async {
    for (var p in permissions) {
      if (await p.request().isGranted) {
        return true;
      }
    }
    return false;
  }

  static Future<bool> _shouldShowPermissionSupport(
      List<Permission> permissions) async {
    for (var p in permissions) {
      if (await p.isPermanentlyDenied || await p.shouldShowRequestRationale) {
        return false;
      }
    }
    return true;
  }

  static Future<bool> _checkPermissionSupport(
      List<Permission> permissions) async {
    for (var p in permissions) {
      if (await p.isGranted) {
        return true;
      }
    }
    return false;
  }
}
