import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  final Dio _dio = Dio();
  static ApiClient? _instance;

  ApiClient._() {
    _dio
      ..options.contentType = Headers.jsonContentType
      ..options.headers[Headers.acceptHeader] = Headers.jsonContentType
      ..options.connectTimeout = const Duration(seconds: 20)
      ..options.receiveTimeout = const Duration(seconds: 10);

    /// Add an interceptor to log requests and responses in debug mode.
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
        ),
      );
    }
  }

  factory ApiClient() => _instance ??= ApiClient._();

  Future<Response> get(String url, {Map<String, dynamic>? query}) async {
    return _dio.get(url, queryParameters: query);
  }

  Future<Response> post(String url, {dynamic body, Map<String, dynamic>? headers}) async {
    return _dio.post(
      url,
      data: body,
      options: Options(headers: headers),
    );
  }

  Future<Response> put(String url, {dynamic body, Map<String, dynamic>? headers}) async {
    return _dio.put(
      url,
      data: body,
      options: Options(headers: headers),
    );
  }

  Future<Response> delete(String url, {Map<String, dynamic>? body, Map<String, dynamic>? headers}) async {
    return _dio.delete(
      url,
      data: body,
      options: Options(headers: headers),
    );
  }
}

final apiClient = ApiClient();
