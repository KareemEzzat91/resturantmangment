import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  static Dio? _dio;
  ApiHelper._();

  /// ⏳ **تهيئة Dio مرة واحدة فقط**
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

  /// ✅ **إضافة التوكين تلقائيًا إلى جميع الطلبات**
  static Future<void> _addAuthorizationHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token != null && token.isNotEmpty) {
      _dio!.options.headers["Authorization"] = "Bearer $token";
    }
  }

  /// 📌 **GET Request**
  static Future<Response> getData({required String path, Map<String, dynamic>? queryParameters}) async {
    await _addAuthorizationHeader(); // تأكد من إضافة التوكين قبل كل طلب
    return await _dio!.get(path, queryParameters: queryParameters);
  }
  /// 📌 **GET Request**
  static Future<Response> patchData({required String path, Map<String, dynamic>? queryParameters}) async {
    await _addAuthorizationHeader(); // تأكد من إضافة التوكين قبل كل طلب
    return await _dio!.patch(path, queryParameters: queryParameters);
  }

  /// 📌 **POST Request**
  static Future<Response?> postData({required String path, Map<String, dynamic>? queryParameters, Map<String, dynamic>? body}) async {
    await _addAuthorizationHeader();
    return await _dio?.post(path, data: body, queryParameters: queryParameters);
  }

  /// 📌 **PUT Request**
  static Future<Response> putData({required String path, Map<String, dynamic>? queryParameters, Map<String, dynamic>? body}) async {
    await _addAuthorizationHeader();
    return await _dio!.put(path, data: body, queryParameters: queryParameters);
  }

  /// 📌 **DELETE Request**
  static Future<Response> deleteData({required String path, Map<String, dynamic>? queryParameters, Map<String, dynamic>? body}) async {
    await _addAuthorizationHeader();
    return await _dio!.delete(path, data: body, queryParameters: queryParameters);
  }
}
