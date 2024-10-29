// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_core/flutter_core.dart';
// import 'package:flutter_core/flutter_core_platform_interface.dart';
// import 'package:flutter_core/flutter_core_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockFlutterCorePlatform
//     with MockPlatformInterfaceMixin
//     implements FlutterCorePlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
import 'package:flutter_core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('append url path test', () async {
    expect("a/".appendUrlPath("b"), 'a/b');
    expect("a//".appendUrlPath("/b"), 'a/b');
    expect("a/".appendUrlPath("/b"), 'a/b');
    expect("/a/".appendUrlPath("/b/"), '/a/b/');
  });
}
