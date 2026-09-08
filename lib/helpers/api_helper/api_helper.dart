import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Centralized HTTP client used by the application.
///
/// The helper configures Dio once and automatically attaches the persisted
/// authentication token to authenticated requests.
class ApiHelper {
  static Dio? _dio;

  ApiHelper._();

  /// Initialize the Dio client once during application startup.
  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "http://spiderxrestauranttt.runasp.net",
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          "Content-Type": "application/json",
          "lang": "en",
        },
      ),
    );
  }

  /// Add the stored bearer token to the current Dio instance.
  static Future<void> _addAuthorizationHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token != null && token.isNotEmpty) {
      _dio!.options.headers["Authorization"] = "Bearer $token";
    }
  }

  /// Send a GET request.
  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    await _addAuthorizationHeader();
    return _dio!.get(path, queryParameters: queryParameters);
  }

  /// Send a PATCH request.
  static Future<Response> patchData({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    await _addAuthorizationHeader();
    return _dio!.patch(path, queryParameters: queryParameters);
  }

  /// Send a POST request.
  static Future<Response?> postData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    await _addAuthorizationHeader();
    return _dio?.post(path, data: body, queryParameters: queryParameters);
  }

  /// Send a PUT request.
  static Future<Response> putData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    await _addAuthorizationHeader();
    return _dio!.put(path, data: body, queryParameters: queryParameters);
  }

  /// Send a DELETE request.
  static Future<Response> deleteData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    await _addAuthorizationHeader();
    return _dio!.delete(path, data: body, queryParameters: queryParameters);
  }
}
