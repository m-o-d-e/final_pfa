class HelperService {
  static const String host = "localhost";
  static const int port = 80;
  static const String scheme = "http";
  static const String apiPath = "/api/";

  static Uri buildUri(String path, bool isApiPath) {
    return Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: isApiPath ? apiPath + path : path,
    );
  }

  //Todo: this method may take the jwt token as a parameter if exists
  static Map<String, String> buildHeaders({String? accessToken}) {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }
}
