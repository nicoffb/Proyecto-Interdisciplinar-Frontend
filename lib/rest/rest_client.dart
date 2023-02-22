import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_authentication/config/locator.dart';
import 'package:flutter_bloc_authentication/main.dart';
import 'package:flutter_bloc_authentication/services/localstorage_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

import '../models/login.dart';

class ApiConstants {
  static String baseUrl = "http://localhost:8080";
}

class AuthorizationInterceptor implements InterceptorContract {
  late LocalStorageService _localStorageService;

  AuthorizationInterceptor() {
    //_localStorageService = getIt<LocalStorageService>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      String? loggedUser = _localStorageService.getFromDisk("user_token");
      if (loggedUser != null) {
        data.headers["Authorization"] = "Bearer " + loggedUser;
      }
    } catch (e) {
      print(e);
    }

    return Future.value(data);
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401 || data.statusCode == 403) {
      Future.delayed(Duration(seconds: 1), () {});
    }

    return Future.value(data);
  }
}

class HeadersApiInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      data.headers["Content-Type"] = "application/json";
      data.headers["Accept"] = "application/json";
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;
}

@Order(-10)
@singleton
class RestClient {
  InterceptedClient? _httpClient = null;

  RestClient() {
    _httpClient = InterceptedClient.build(
        interceptors: [HeadersApiInterceptor(), AuthorizationInterceptor()]);
  }

  RestClient.withInterceptors(List<InterceptorContract> interceptors) {
    // El interceptor con los encabezados sobre JSON se añade si no está incluido en la lista
    if (interceptors
        .where((element) => element is HeadersApiInterceptor)
        .isEmpty) interceptors..add(HeadersApiInterceptor());
    _httpClient = InterceptedClient.build(interceptors: interceptors);
  }

  Future<dynamic> get(String url) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      final response = await _httpClient!.get(uri);
      var responseJson = _response(response);
      return responseJson;
    } on SocketException catch (ex) {
      throw Exception('No internet connection: ${ex.message}');
    }
  }

  Future<dynamic> post(String url, dynamic body) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      Map<String, String> headers = Map();
      headers.addAll({"Content-Type": 'application/json'});

      final response = await _httpClient!
          .post(uri, body: jsonEncode(body), headers: headers);
      var responseJson = _response(response);
      return responseJson;
    } on SocketException catch (ex) {
      throw Exception('No internet connection: ${ex.message}');
    }
  }

  Future<dynamic> put(String url, dynamic body) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      Map<String, String> headers = Map();
      headers.addAll({"Content-Type": 'application/json'});

      final response =
          await _httpClient!.put(uri, body: jsonEncode(body), headers: headers);
      var responseJson = _response(response);
      return responseJson;
    } on SocketException catch (ex) {
      throw Exception('No internet connection: ${ex.message}');
    }
  }

  Future<dynamic> delete(String url) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      final response = await _httpClient!.delete(uri);
      var responseJson = _response(response);
      return responseJson;
    } on SocketException catch (ex) {
      throw Exception('No internet connection: ${ex.message}');
    }
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 204:
        return;
      case 400:
        throw Exception(utf8.decode(response.bodyBytes));
      case 401:
        throw Exception(utf8.decode(response.bodyBytes));
      case 403:
        throw Exception(utf8.decode(response.bodyBytes));
      case 404:
        throw Exception(utf8.decode(response.bodyBytes));
      case 500:
      default:
        throw Exception(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
