import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_tour/domain/entities/category.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final String? alias;
  final String? title;

  CategoryModel({
    this.alias,
    this.title,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  Category toEntity() {
    return Category(
      alias: alias,
      title: title,
    );
  }

  factory CategoryModel.fromEntity(Category entity) {
    return CategoryModel(
      alias: entity.alias,
      title: entity.title,
    );
  }
}