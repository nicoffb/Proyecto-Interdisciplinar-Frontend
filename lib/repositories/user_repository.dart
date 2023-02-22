import 'dart:convert';

import 'package:flutter_bloc_authentication/config/locator.dart';
import 'package:flutter_bloc_authentication/models/login.dart';
import 'package:flutter_bloc_authentication/models/user.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_bloc_authentication/rest/rest.dart';

@Order(-1)
@singleton
class UserRepository {
  late RestClient _client;

  UserRepository() {
    _client = getIt<RestClient>();
  }

  Future<dynamic> me() async {
    String url = "/me";

    var jsonResponse = await _client.get(url);
    return UserResponse.fromJson(jsonDecode(jsonResponse));
  }
}
