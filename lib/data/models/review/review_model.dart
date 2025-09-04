import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_tour/data/models/user/user_model.dart';
import 'package:restaurant_tour/domain/entities/review.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel {
  final String? id;
  final int? rating;
  final String? text;
  final UserModel? user;

  const ReviewModel({
    this.id,
    this.rating,
    this.user,
    this.text,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  Review toEntity() {
    return Review(
      id: id,
      rating: rating,
      text: text,
      user: user?.toEntity(),
    );
  }

  factory ReviewModel.fromEntity(Review entity) {
    return ReviewModel(
      id: entity.id,
      rating: entity.rating,
      text: entity.text,
      user: entity.user != null ? UserModel.fromEntity(entity.user!) : null,
    );
  }
}