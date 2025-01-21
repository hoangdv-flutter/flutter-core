import 'package:flutter_core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class PremiumHolder {
  static const _isLifetime = "is_lifetime";

  static const _premiumDay = "premium_day";

  final SharedPreferences sharedPreferences;

  PremiumHolder(this.sharedPreferences);

  bool get isLifetime => sharedPreferences.getBool(_isLifetime) ?? false;

  set isLifetime(value) {
    sharedPreferences.setBool(_isLifetime, value);
    _updatePremiumStream();
  }

  int get premiumDay => sharedPreferences.getInt(_premiumDay) ?? 0;

  set premiumDay(value) {
    sharedPreferences.setInt(_premiumDay, value);
    _updatePremiumStream();
  }

  bool get isPremium => true;
      // isLifetime || premiumDay > DateTime.now().millisecondsSinceEpoch;

  late final _isPremiumBS = BehaviorSubject.seeded(isPremium);

  void _updatePremiumStream() {
    if (_isPremiumBS.valueOrNull != isPremium) {
      _isPremiumBS.addSafety(isPremium);
    }
  }

  ValueStream<bool> get isPremiumStream => _isPremiumBS.stream;

  @disposeMethod
  void disposed() {
    _isPremiumBS.close();
  }
}
