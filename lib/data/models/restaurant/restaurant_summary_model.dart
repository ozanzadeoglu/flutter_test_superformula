import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_tour/data/models/category/category_model.dart';
import 'package:restaurant_tour/data/models/hours/hours_model.dart';
import 'package:restaurant_tour/domain/entities/restaurant_summary.dart';

part 'restaurant_summary_model.g.dart';

@JsonSerializable()
class RestaurantSummaryModel {
  final String? id;
  final String? name;
  final String? price;
  final double? rating;
  final List<String>? photos;
  final List<CategoryModel>? categories;
  final List<HoursModel>? hours;

  const RestaurantSummaryModel({
    this.id,
    this.name,
    this.price,
    this.rating,
    this.photos,
    this.categories,
    this.hours,
  });

  factory RestaurantSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantSummaryModelToJson(this);

  RestaurantSummary toEntity() {
    return RestaurantSummary(
      id: id,
      name: name,
      price: price,
      rating: rating,
      photos: photos,
      categories: categories?.map((c) => c.toEntity()).toList(),
      hours: hours?.map((h) => h.toEntity()).toList(),
    );
  }

  factory RestaurantSummaryModel.fromEntity(RestaurantSummary entity) {
    return RestaurantSummaryModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      rating: entity.rating,
      photos: entity.photos,
      categories: entity.categories?.map((c) => CategoryModel.fromEntity(c)).toList(),
      hours: entity.hours?.map((h) => HoursModel.fromEntity(h)).toList(),
    );
  }
}