class Constants {
  static const topSoundRemoteConfigName = "top_sound";

  static const appIds = AppIds(
      appStore: "",
      androidAppStore: "com.wavez.pranksound.airhorn.hairclipper");

  static const defaultSupportEmail = "app@wavez.vn";

  static const privacyPolicyUrl = "https://wavez.vn/privacy-policy/";
}

class AppIds {
  final String appStore;

  final String androidAppStore;

  const AppIds({required this.appStore, required this.androidAppStore});
}

class Event {
  static const String openSound = "open_sound";
}

enum DataState { idle, loaded, loading, error }
