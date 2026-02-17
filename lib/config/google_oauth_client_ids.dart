class GoogleOAuthClientIds {
  GoogleOAuthClientIds._();

  static const String _androidServerClientIdFallback =
      '525715666823-6l3pck049aj7g60pn1obm652d090afi4.apps.googleusercontent.com';

  static const String _androidServerClientId = String.fromEnvironment(
    'GOOGLE_ANDROID_SERVER_CLIENT_ID',
  );
  static const String _iosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
  );

  static String? get androidServerClientId => _androidServerClientId.isEmpty
      ? _androidServerClientIdFallback
      : _androidServerClientId;

  static String? get iosClientId => _iosClientId.isEmpty ? null : _iosClientId;
}
