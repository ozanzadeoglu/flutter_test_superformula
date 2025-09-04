import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_tour/data/models/category/category_model.dart';
import 'package:restaurant_tour/data/models/hours/hours_model.dart';
import 'package:restaurant_tour/data/models/location/location_model.dart';
import 'package:restaurant_tour/data/models/review/review_model.dart';
import 'package:restaurant_tour/domain/entities/restaurant/restaurant.dart';

part 'restaurant_model.g.dart';

@JsonSerializable()
class RestaurantModel {
  final String? id;
  final String? name;
  final String? price;
  final double? rating;
  final List<String>? photos;
  final List<CategoryModel>? categories;
  final List<HoursModel>? hours;
  final List<ReviewModel>? reviews;
  final LocationModel? location;

  const RestaurantModel({
    this.id,
    this.name,
    this.price,
    this.rating,
    this.photos,
    this.categories,
    this.hours,
    this.reviews,
    this.location,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  Restaurant toEntity() {
    return Restaurant(
      id: id,
      name: name,
      price: price,
      rating: rating,
      photos: photos,
      categories: categories?.map((c) => c.toEntity()).toList(),
      hours: hours?.map((h) => h.toEntity()).toList(),
      reviews: reviews?.map((r) => r.toEntity()).toList(),
      location: location?.toEntity(),
    );
  }

  factory RestaurantModel.fromEntity(Restaurant entity) {
    return RestaurantModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      rating: entity.rating,
      photos: entity.photos,
      categories: entity.categories?.map((c) => CategoryModel.fromEntity(c)).toList(),
      hours: entity.hours?.map((h) => HoursModel.fromEntity(h)).toList(),
      reviews: entity.reviews?.map((r) => ReviewModel.fromEntity(r)).toList(),
      location: entity.location != null ? LocationModel.fromEntity(entity.location!) : null,
    );
  }
}