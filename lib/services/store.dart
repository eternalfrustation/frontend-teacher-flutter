import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:shared_preferences/shared_preferences.dart';

part 'store.g.dart';

class Store {
  static final store = SharedPreferencesAsync();

  static final dio = Dio(BaseOptions(
    baseUrl: "http://school1.localhost:8000/api/",
    contentType: "application/json",
  ));

  static Future<String?> get access async => store.getString("access");
  static Future<String?> get refresh async => store.getString("refresh");
  static Future<bool?> get isAuth async => (await access != null);
  static Future<User?> get user async =>
      User.fromJson(jsonDecode(await store.getString("user") ?? ""));
  static Future<Map<String, dynamic>?> get account async =>
      jsonDecode(await store.getString("account") ?? "");

  static Future<bool> hasPermission(String permission) async =>
      (await account)?["group_details"]?["permissions"]
          ?.any((perm) => perm.codename == permission) ||
      false;


  static Future login(Cred credentials) async {
    final response = await dio
        .post("token/", data: credentials.toJson())
        .then((v) => TokenPair.fromJson(v.data));
    setTokens(response.access, response.refresh);
    final userResponse =
        await dio.get("/users/self/").then((v) => User.fromJson(v.data));

    setUser(userResponse);
    final account = userResponse.accounts.firstOrNull;
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
  }

  static setUser(User user) {
    store.setString("user", jsonEncode(user));
  }

  static Future<void> init() async {
    dio.interceptors.add(LogInterceptor());
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final accessToken = await access;
      if (accessToken != null) {
        options.headers["Authorization"] = "Bearer $accessToken";
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

@JsonSerializable()
class Cred {
  final String username;
  final String password;

  Cred({required this.username, required this.password});

  factory Cred.fromJson(Map<String, dynamic> json) => _$CredFromJson(json);

  /// Connect the generated [_$CredToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CredToJson(this);
}

@JsonSerializable()
class TokenPair {
  final String access;
  final String refresh;

  TokenPair({required this.access, required this.refresh});
  factory TokenPair.fromJson(Map<String, dynamic> json) =>
      _$TokenPairFromJson(json);

  /// Connect the generated [_$TokenPairToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TokenPairToJson(this);
}

@JsonSerializable()
class AccountType {
  final String type;
  final int id;

  AccountType({required this.type, required this.id});

  factory AccountType.fromJson(Map<String, dynamic> json) =>
      _$AccountTypeFromJson(json);

  /// Connect the generated [_$AccountTypeToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AccountTypeToJson(this);
}

@JsonSerializable()
class User {
  final String username;
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isActive;
  final bool isApproved;
  final bool isStaff;
  final bool isSuperuser;
  final List<AccountType> accounts;
  final int? school;

  User({
    required this.username,
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.isApproved,
    required this.isStaff,
    required this.isSuperuser,
    required this.accounts,
    required this.school,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Connect the generated [_$UserToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
