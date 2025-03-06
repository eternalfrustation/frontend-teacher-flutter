// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cred _$CredFromJson(Map<String, dynamic> json) => Cred(
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$CredToJson(Cred instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

TokenPair _$TokenPairFromJson(Map<String, dynamic> json) => TokenPair(
      access: json['access'] as String,
      refresh: json['refresh'] as String,
    );

Map<String, dynamic> _$TokenPairToJson(TokenPair instance) => <String, dynamic>{
      'access': instance.access,
      'refresh': instance.refresh,
    };

AccountType _$AccountTypeFromJson(Map<String, dynamic> json) => AccountType(
      type: json['type'] as String,
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$AccountTypeToJson(AccountType instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      username: json['username'] as String,
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      isActive: json['is_active'] as bool,
      isApproved: json['is_approved'] as bool,
      isStaff: json['is_staff'] as bool,
      isSuperuser: json['is_superuser'] as bool,
      accounts: (json['accounts'] as List<dynamic>)
          .map((e) => AccountType.fromJson(e as Map<String, dynamic>))
          .toList(),
      school: (json['school'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'is_active': instance.isActive,
      'is_approved': instance.isApproved,
      'is_staff': instance.isStaff,
      'is_superuser': instance.isSuperuser,
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
      'school': instance.school,
    };
