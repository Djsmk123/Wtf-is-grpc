import 'dart:developer';

import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/pb/empty_request.pb.dart';
import 'package:flutter_app/pb/rpc_login.pb.dart';
import 'package:flutter_app/pb/rpc_signup.pb.dart';
import 'package:flutter_app/pb/rpc_users.pb.dart';
import 'package:flutter_app/services/grpc_services.dart';
import 'package:grpc/service_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String? authToken;
  static UserModel? user;

  static Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  static Future<bool> isAuthAvailable() async {
    final sharedPreferences = await getSharedPreferences();
    authToken = sharedPreferences.getString('token');
    return authToken != null;
  }

  static Future<bool?> updateToken(String token) async {
    final sharedPreferences = await getSharedPreferences();
    authToken = token;
    return sharedPreferences.setString('token', token);
  }

  static Future<bool?> logout() async {
    final sharedPreferences = await getSharedPreferences();
    authToken = null;
    user = null;
    return sharedPreferences.remove('token');
  }

  static Future<UserModel?> login(String username, String password) async {
    try {
      final request =
          LoginRequestMessage(username: username, password: password);
      final response = await GrpcService.client.login(request);
      await updateToken(response.accessToken);
      user = UserModel(
          response.user.id, response.user.username, response.user.name);
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<UserModel?> signup(
      String username, String password, String name) async {
    try {
      final request = SignupRequestMessage(
          username: username, password: password, name: name);
      final response = await GrpcService.client.signUp(request);
      return UserModel(
          response.user.id, response.user.username, response.user.name);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<UserModel?> getUser() async {
    try {
      final response = await GrpcService.client.getUser(
        EmptyRequest(),
        options: CallOptions(metadata: {'authorization': 'bearer $authToken'}),
      );
      user = UserModel(
          response.user.id, response.user.username, response.user.name);
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<List<UserModel>> getUsers(
      {int pageNumber = 1, String? search}) async {
    final res = await GrpcService.client.getUsers(
        UsersListRequest(pageSize: 10, pageNumber: pageNumber, name: search),
        options: CallOptions(metadata: {'authorization': 'bearer $authToken'}));
    return res.users.map((e) => UserModel(e.id, e.username, e.name)).toList();
  }
}
