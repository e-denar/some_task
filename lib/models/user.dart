import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(nullable: false)
class UserModel {
  String displayName;
  String email;
  String uid;
  String photoUrl;
  String birthDate;
  String address;
  String contact;
  String name;

  UserModel({
    this.contact,
    this.name,
    this.displayName,
    this.email,
    this.uid,
    this.photoUrl,
    this.birthDate,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.copy(UserModel other) => UserModel(
        address: other.address,
        name: other.name,
        displayName: other.displayName,
        email: other.email,
        uid: other.uid,
        photoUrl: other.photoUrl,
        birthDate: other.birthDate,
        contact: other.contact,
      );
}
