import 'package:restaurant_tour/core/utils/result.dart';
import 'package:restaurant_tour/data/repositories/restaurant/data_sources/i_restaurant_remote_data_source.dart';
import 'package:restaurant_tour/data/repositories/restaurant/data_sources/restaurant_local_data_source.dart';
import 'package:restaurant_tour/domain/entities/restaurant/restaurant.dart';
import 'package:restaurant_tour/domain/entities/restaurant/restaurant_summary.dart';
import 'package:restaurant_tour/domain/repositories/restaurant_repository.dart';

/// Implementation of [RestaurantRepository] using remote and local data sources.
///
/// Uses [IRestaurantRemoteDataSource] for API calls and [RestaurantLocalDataSource] 
/// for favorites management. Handles data model to domain entity conversion.
class RestaurantRepositoryImpl implements RestaurantRepository {
  final IRestaurantRemoteDataSource _remoteDataSource;
  final RestaurantLocalDataSource _localDataSource;

  const RestaurantRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Result<List<RestaurantSummary>>> fetchAllRestaurants({
    int limit = 20,
    int offset = 0,
  }) async {
    final result = await _remoteDataSource.getRestaurantSummaries(
      limit: limit,
      offset: offset,
    );

    switch (result) {
      case Ok():
        final entities = result.value.map((model) => model.toEntity()).toList();
        return Result.ok(entities);
      case Error():
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<List<RestaurantSummary>>> fetchFavorites() async {
    // Get favorite IDs in historical order
    final idsResult = await _localDataSource.getFavoriteIds();

    switch (idsResult) {
      case Ok():
        if (idsResult.value.isEmpty) {
          return const Result.ok([]);
        }

        // Fetch fresh data from remote API
        final restaurantsResult = await _remoteDataSource.getRestaurantSummariesWithIds(
          idsResult.value,
        );

        switch (restaurantsResult) {
          case Ok():
            final entities = restaurantsResult.value.map((model) => model.toEntity()).toList();
            return Result.ok(entities);
          case Error():
            return Result.error(restaurantsResult.error);
        }

      case Error():
        return Result.error(idsResult.error);
    }
  }

  @override
  Future<Result<Restaurant?>> fetchRestaurantDetail(String id) async {
    final result = await _remoteDataSource.getRestaurantDetail(id);

    switch (result) {
      case Ok():
        if (result.value != null) {
          final entity = result.value!.toEntity();
          return Result.ok(entity);
        }
        return const Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  /// Toggles a restaurant's favorite status.
  ///
  /// Adds to favorites if not currently favorited, removes if already favorited.
  /// Returns [Result.ok] on success or [Result.error] on failure.
  Future<Result<void>> toggleFavorite(String restaurantId) async {
    final isFavoriteResult = await _localDataSource.isFavorite(restaurantId);

    switch (isFavoriteResult) {
      case Ok():
        if (isFavoriteResult.value) {
          // Currently favorited, so remove it
          return await _localDataSource.removeFromFavorites(restaurantId);
        } else {
          // Not favorited, so add it
          return await _localDataSource.addToFavorites(restaurantId);
        }
      case Error():
        return Result.error(isFavoriteResult.error);
    }
  }

  /// Checks if a restaurant is currently favorited.
  ///
  /// Returns [Result] containing true if favorited, false otherwise.
  /// Used for updating heart icon states in the UI.
  Future<Result<bool>> isRestaurantFavorited(String restaurantId) async {
    return await _localDataSource.isFavorite(restaurantId);
  }

  /// Clears all favorites.
  ///
  /// Returns [Result.ok] on success or [Result.error] on failure.
  Future<Result<void>> clearAllFavorites() async {
    return await _localDataSource.clearFavorites();
  }
}