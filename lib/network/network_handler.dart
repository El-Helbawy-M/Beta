// ignore_for_file: prefer_final_fields

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/debug/log_printer.dart';
import 'package:flutter_project_base/handlers/shared_handler.dart';

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

  Future<dynamic> get(
      {@required String? url,
      Map<String, dynamic>? query,
      Map<String, dynamic>? headers,
      bool withToken = false}) async {
    Response? res;
    if (headers != null) {
      _dio.options.headers = headers;
    } else if (withToken) {
      String token = (await SharedHandler.instance?.getData(
          key: SharedKeys().user,
          valueType: ValueType.map) as Map<String, dynamic>)['token'];
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Accept-Language': "US"
      };
    }
    try {
      print(url);
      res = await _dio.get(url!, queryParameters: query);
      log_request(
          request: url,
          requestMethod: "GET",
          query: query ?? {},
          headers: _dio.options.headers);
      return res;
    } on DioError catch (e) {
      _errorHandler(e);
    }
  }

  Future<dynamic> delete(
      {@required String? url,
      Map<String, dynamic>? query,
      Map<String, dynamic>? headers,
      bool withToken = false}) async {
    Response? res;
    if (headers != null) {
      _dio.options.headers = headers;
    } else if (withToken) {
      String token = (await SharedHandler.instance?.getData(
          key: SharedKeys().user,
          valueType: ValueType.map) as Map<String, dynamic>)['token'];
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Accept-Language': "US"
      };
    }
    try {
      res = await _dio.delete(url!, queryParameters: query);
      log_request(
          request: url,
          requestMethod: "GET",
          query: query ?? {},
          headers: _dio.options.headers);
      return res;
    } on DioError catch (e) {
      _errorHandler(e);
    }
  }

  Future<Response?> post(
      {@required String? url,
      FormData? body,
      Map<String, dynamic>? query,
      bool withToken = false,
      Map<String, dynamic>? headers}) async {
    Response? res;
    if (headers != null) {
      _dio.options.headers = headers;
    } else if (withToken) {
      String token = (await SharedHandler.instance?.getData(
          key: SharedKeys().user,
          valueType: ValueType.map) as Map<String, dynamic>)['token'];
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Accept-Language': "US",
      };
    }

    try {
      res = await _dio.post(url!, data: body, queryParameters: query);
      log_request(
          request: url,
          requestMethod: "POST",
          query: query ?? {},
          body: {},
          headers: _dio.options.headers);
      return res;
    } on DioError catch (e) {
      _errorHandler(e);
    }
    return null;
  }
}
