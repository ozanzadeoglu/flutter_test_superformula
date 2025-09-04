import 'package:restaurant_tour/core/network/api_client.dart';
import 'package:restaurant_tour/core/utils/result.dart';
import 'package:restaurant_tour/data/models/restaurant/restaurant_model.dart';
import 'package:restaurant_tour/data/models/restaurant/restaurant_summary_model.dart';
import 'package:restaurant_tour/data/repositories/restaurant/data_sources/i_restaurant_remote_data_source.dart';

/// Mock implementation of restaurant remote data source.
///
/// Uses [ApiClient] mock methods to fetch restaurant data from local JSON assets.
/// Perfect for development without consuming API rate limits.
class RestaurantMockDataSource implements IRestaurantRemoteDataSource {
  final ApiClient _apiClient;

  const RestaurantMockDataSource(this._apiClient);

  @override
  Future<Result<List<RestaurantSummaryModel>>> getRestaurantSummaries({
    int limit = 20,
    int offset = 0,
  }) async {
    return await _apiClient.fetchMockRestaurantSummaries(
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Result<List<RestaurantSummaryModel>>> getRestaurantSummariesWithIds(
    List<String> ids,
  ) async {
    return await _apiClient.fetchMockRestaurantSummariesWithIds(ids);
  }

  @override
  Future<Result<RestaurantModel?>> getRestaurantDetail(String id) async {
    return await _apiClient.fetchMockRestaurant(id);
  }
}