import 'package:restaurant_tour/core/utils/result.dart';
import 'package:restaurant_tour/data/models/restaurant/restaurant_model.dart';
import 'package:restaurant_tour/data/models/restaurant/restaurant_summary_model.dart';

/// Interface for restaurant remote data sources.
///
/// Defines the contract for fetching restaurant data from remote sources.
/// Implementations can use real API calls or mock data.
abstract class IRestaurantRemoteDataSource {
  /// Fetches restaurant summaries.
  ///
  /// Returns [Result] containing a list of [RestaurantSummaryModel] 
  /// or an error if the operation fails.
  Future<Result<List<RestaurantSummaryModel>>> getRestaurantSummaries({
    int limit = 20,
    int offset = 0,
  });

  /// Fetches restaurant summaries by their IDs.
  ///
  /// Returns [Result] containing a list of [RestaurantSummaryModel] 
  /// or an error if the operation fails.
  Future<Result<List<RestaurantSummaryModel>>> getRestaurantSummariesWithIds(
    List<String> ids,
  );

  /// Fetches detailed restaurant data by ID.
  ///
  /// Returns [Result] containing [RestaurantModel] or an error 
  /// if the operation fails.
  Future<Result<RestaurantModel?>> getRestaurantDetail(String id);
}