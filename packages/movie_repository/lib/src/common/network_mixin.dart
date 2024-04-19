import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

mixin NetworkMixin {
  final _dio = Dio();
  Dio get dio => _dio;
  String get server => dotenv.env['API_URL']!;

  String get apiKey => dotenv.env['API_KEY']!;

  Future<Response<Map<String, dynamic>>> get({
    required String endpoint,
    Map<String, dynamic>? query,
    CancelToken? token,
    Options? options,
  }) =>
      _dio.get(
        "$server$endpoint",
        queryParameters: addApiKey(query),
        cancelToken: token,
        options: options,
      );

  Future<Response<Map<String, dynamic>>> post(
    String url,
    Map<String, dynamic> body,
    Map<String, dynamic>? query,
    CancelToken token,
    Options? options,
  ) =>
      _dio.post(
        url,
        data: body,
        queryParameters: addApiKey(query),
        cancelToken: token,
        options: options,
      );

  Map<String, dynamic> addApiKey(Map<String, dynamic>? queryParameter) {
    if (queryParameter == null || !queryParameter.containsKey("api_key")) {
      queryParameter ??= {};
      queryParameter["api_key"] = apiKey;
    }
    return queryParameter;
  }
}
