import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static final store = SharedPreferencesAsync();

  static final dio = Dio(BaseOptions(
    baseUrl: "http://school1.localhost:8000/api/",
    contentType: "application/json",
  ));

  static final cookies = CookieJar();

  static Future<String?> get access async => store.getString("access");
  static Future<String?> get refresh async => store.getString("refresh");
  static Future<bool?> get isAuth async => (await access != null);
  static Future<Map<String, dynamic>?> get user async =>
      jsonDecode(await store.getString("user") ?? "");
  static Future<Map<String, dynamic>?> get account async =>
      jsonDecode(await store.getString("account") ?? "");

  static Future<bool> hasPermission(String permission) async =>
      (await account)?["group_details"]?["permissions"]
          ?.any((perm) => perm.codename == permission) ||
      false;

  static login(Cred credentials) async {
    final response = await dio.post("token/", data: credentials);
    setTokens(response.data.access, response.data.refresh);
    final userResponse = await dio.get("/api/users/self/");
    setUser(userResponse.data);
    final account = userResponse.data.account;
    if (account != null) {
      setActiveAccount(account.type, account.id);
    }
  }

  static setActiveAccount(String type, int id) async {
    final accountResponse =
        await dio.get("/accounts/${type.toLowerCase()}s/$id/");
    store.setString("account", jsonEncode(accountResponse.data));
  }

  static logout() async {
    store.remove("access");
    store.remove("refresh");
    store.remove("user");
    store.remove("account");
  }

  static setTokens(String accessToken, String refreshToken) {
    store.setString("access", accessToken);
    store.setString("refresh", refreshToken);
    // TODO: Implement Cookies if needed
  }

  static setUser(Map<String, dynamic> user) {
    store.setString("user", jsonEncode(user));
  }

  static Future<void> init() async {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final accessToken = await access;
      if (accessToken != null) {
        options.headers["Authorization"] = "Bearer $access";
      }
      return handler.next(options);
    }, onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        final refreshToken = await refresh;
        if (refreshToken != null) {
          final response = await dio.post("token/refresh/", data: {
            "refresh": refreshToken,
          });
          setTokens(response.data.access, response.data.refresh);
          return handler.next(error);
        }
      }
      return handler.next(error);
    }));
  }
}

class Cred {
  final String username;
  final String password;

  Cred({required this.username, required this.password});
}
