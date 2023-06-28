
import 'package:dio/dio.dart';
import '../auth_service.dart';
import '../helper_service.dart';

class Api{
  final String baseUrl = HelperService.buildUri("", false).toString();

  final Dio _dio = Dio();

  Api(){
    _dio.options.baseUrl = baseUrl;

    _dio.interceptors.add(LogInterceptor(responseBody: true));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        final user =  await AuthService.loadUser();
        options.headers["Authorization"] = "Bearer ${user.accessToken}";
        return handler.next(options); //continue
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) async {
        return handler.next(response); // continue
      },
      onError: (DioError e, ErrorInterceptorHandler handler) async {
        if(e.response?.statusCode == 401){
          final user = await AuthService.loadUser();
          final refreshedUser = await AuthService.refreshToken(user);
          AuthService.saveUser(refreshedUser);
          return handler.resolve(await _retry(e.requestOptions));
        }
        return handler.next(e); //continue
      }
    ));
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<Response<dynamic>> get(String path) async {
    return _dio.get<dynamic>(path);
  }

  Future<Response<dynamic>> post(String path, dynamic data) async {
    return _dio.post<dynamic>(path, data: data);
  }

  Future<Response<dynamic>> put(String path, dynamic data) async {
    return _dio.put<dynamic>(path, data: data);
  }

  Future<Response<dynamic>> delete(String path) async {
    return _dio.delete<dynamic>(path);
  }

  Future<Response<dynamic>> patch(String path, dynamic data) async {
    return _dio.patch<dynamic>(path, data: data);
  }

  Future<Response<dynamic>> head(String path) async {
    return _dio.head<dynamic>(path);
  }


}