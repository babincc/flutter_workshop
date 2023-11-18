class UrlTool {
  static String buildUrl({
    required String baseUrl,
    Map<String, String?>? queryParams,
  }) {
    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    /// Whether or not the URL already has query parameters.
    bool hasQueryParameters = false;

    if (queryParams != null) {
      for (final String key in queryParams.keys) {
        final String? value = queryParams[key];

        if (value == null) continue;

        if (hasQueryParameters) {
          urlBuffer.write('&');
        } else {
          urlBuffer.write('?');
        }

        urlBuffer.write('$key=$value');
        hasQueryParameters = true;
      }
    }

    return urlBuffer.toString();
  }
}
