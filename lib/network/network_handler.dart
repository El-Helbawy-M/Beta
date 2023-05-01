import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/debug/log_printer.dart';
import '../config/api_names.dart';

class NetworkHandler {
  static NetworkHandler? instance;
  Dio _dio = Dio();
  NetworkHandler._internal();

  factory NetworkHandler.init() {
    if (instance == null) {
      instance = NetworkHandler._internal();
      instance!._dio.options.baseUrl = domainUrl;
    }

    return instance!;
  }

  _errorHandler(DioError error) {
    log_error(type: error.type.name, message: error.message);
    throw error;
  }

  Future<dynamic> get({@required String? url, Map<String, dynamic>? query, Map<String, dynamic>? headers, bool withToken = false}) async {
    Response? res;
    if (headers != null) {
      _dio.options.headers = headers;
    } else if (withToken) {
      String token = ""; // get the token
      // await SharedHelper.sharedHelper!.readString(CachingKey.TOKEN);
      _dio.options.headers = {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Accept-Language': "US"};
    }
    try {
      res = await _dio.get(url!, queryParameters: query);
      log_request(request: url, requestMethod: "GET", query: query ?? {}, headers: _dio.options.headers);
      return res;
    } on DioError catch (e) {
      _errorHandler(e);
    }
  }

  Future<dynamic> post({@required String? url, Map<String, dynamic>? body, Map<String, dynamic>? query, bool withToken = false, Map<String, dynamic>? headers}) async {
    Response? res;
    if (headers != null) {
      _dio.options.headers = headers;
    } else if (withToken) {
      String token = ""; // get the token
      // await SharedHelper.sharedHelper!.readString(CachingKey.TOKEN);
      _dio.options.headers = {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Accept-Language': "US"};
    }

    try {
      res = await _dio.post(url!, data: body, queryParameters: query);
      log_request(request: url, requestMethod: "POST", query: query ?? {}, body: body ?? {}, headers: _dio.options.headers);
      return res;
    } on DioError catch (e) {
      _errorHandler(e);
    }
  }
}
