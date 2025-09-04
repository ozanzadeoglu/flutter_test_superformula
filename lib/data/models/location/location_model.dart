import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_tour/domain/entities/location/location.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationModel {
  @JsonKey(name: 'formatted_address')
  final String? formattedAddress;

  LocationModel({
    this.formattedAddress,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  Location toEntity() {
    return Location(
      formattedAddress: formattedAddress,
    );
  }

  factory LocationModel.fromEntity(Location entity) {
    return LocationModel(
      formattedAddress: entity.formattedAddress,
    );
  }
}