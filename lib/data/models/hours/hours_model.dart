import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_tour/domain/entities/hours.dart';

part 'hours_model.g.dart';

@JsonSerializable()
class HoursModel {
  @JsonKey(name: 'is_open_now')
  final bool? isOpenNow;

  const HoursModel({
    this.isOpenNow,
  });

  factory HoursModel.fromJson(Map<String, dynamic> json) => _$HoursModelFromJson(json);

  Map<String, dynamic> toJson() => _$HoursModelToJson(this);

  Hours toEntity() {
    return Hours(
      isOpenNow: isOpenNow,
    );
  }

  factory HoursModel.fromEntity(Hours entity) {
    return HoursModel(
      isOpenNow: entity.isOpenNow,
    );
  }
}