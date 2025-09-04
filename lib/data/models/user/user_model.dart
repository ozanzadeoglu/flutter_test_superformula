import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_tour/domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String? id;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final String? name;

  const UserModel({
    this.id,
    this.imageUrl,
    this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() {
    return User(
      id: id,
      imageUrl: imageUrl,
      name: name,
    );
  }

  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      imageUrl: entity.imageUrl,
      name: entity.name,
    );
  }
}