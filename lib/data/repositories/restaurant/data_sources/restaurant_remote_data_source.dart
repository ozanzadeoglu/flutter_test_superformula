import 'package:restaurant_tour/core/network/api_client.dart';
import 'package:restaurant_tour/core/utils/result.dart';
import 'package:restaurant_tour/data/models/restaurant/restaurant_model.dart';
import 'package:restaurant_tour/data/models/restaurant/restaurant_summary_model.dart';
import 'package:restaurant_tour/data/repositories/restaurant/data_sources/i_restaurant_remote_data_source.dart';

/// Real API implementation of restaurant remote data source.
///
/// Uses [ApiClient] to fetch restaurant data from the actual Yelp GraphQL API.
/// Returns data models that will be converted to domain entities by the repository.
class RestaurantRemoteDataSource implements IRestaurantRemoteDataSource {
  final ApiClient _apiClient;

  const RestaurantRemoteDataSource(this._apiClient);

  @override
  Future<Result<List<RestaurantSummaryModel>>> getRestaurantSummaries({
    int limit = 20,
    int offset = 0,
  }) async {
    return await _apiClient.fetchRestaurantSummaries(
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Result<List<RestaurantSummaryModel>>> getRestaurantSummariesWithIds(
    List<String> ids,
  ) async {
    return await _apiClient.fetchRestaurantSummariesWithIds(ids);
  }

  @override
  Future<Result<RestaurantModel?>> getRestaurantDetail(String id) async {
    return await _apiClient.fetchRestaurant(id);
  }
}