// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    contact: json['contact'] as String,
    name: json['name'] as String,
    displayName: json['displayName'] as String,
    email: json['email'] as String,
    uid: json['uid'] as String,
    photoUrl: json['photoUrl'] as String,
    birthDate: json['birthDate'] as String,
    address: json['address'] as String,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'displayName': instance.displayName,
      'email': instance.email,
      'uid': instance.uid,
      'photoUrl': instance.photoUrl,
      'birthDate': instance.birthDate,
      'address': instance.address,
      'contact': instance.contact,
      'name': instance.name,
    };
