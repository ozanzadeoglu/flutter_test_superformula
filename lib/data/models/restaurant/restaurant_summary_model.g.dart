// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantSummaryModel _$RestaurantSummaryModelFromJson(
        Map<String, dynamic> json) =>
    RestaurantSummaryModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      price: json['price'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hours: (json['hours'] as List<dynamic>?)
          ?.map((e) => HoursModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RestaurantSummaryModelToJson(
        RestaurantSummaryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'rating': instance.rating,
      'photos': instance.photos,
      'categories': instance.categories,
      'hours': instance.hours,
    };
