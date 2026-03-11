class BackendApiConfig {
  const BackendApiConfig._();

  static const String baseUrl = String.fromEnvironment('API_BASE_URL',
      defaultValue: 'http://localhost/rzatdb_api');

  static bool get isEnabled => baseUrl.trim().isNotEmpty;
}
