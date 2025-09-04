import 'package:restaurant_tour/core/cache/i_cache_service.dart';
import 'package:restaurant_tour/core/utils/result.dart';

/// Local data source for restaurant favorites storage.
///
/// Uses [ICacheService] to store favorite restaurant IDs as individual cache entries.
/// Each restaurant ID becomes a cache key with DateTime as the value for historical ordering.
class RestaurantLocalDataSource {
  final ICacheService _cacheService;

  const RestaurantLocalDataSource(this._cacheService);

  /// Adds a restaurant to favorites with current timestamp.
  ///
  /// Returns [Result.ok] on success or [Result.error] on failure.
  Future<Result<void>> addToFavorites(String restaurantId) async {
    return await _cacheService.put(restaurantId, DateTime.now());
  }

  /// Removes a restaurant from favorites.
  ///
  /// Returns [Result.ok] on success or [Result.error] on failure.
  Future<Result<void>> removeFromFavorites(String restaurantId) async {
    return await _cacheService.delete(restaurantId);
  }

  /// Gets all favorite restaurant IDs in historical order (most recent first).
  ///
  /// Returns [Result] containing list of favorite IDs ordered by favorited date.
  Future<Result<List<String>>> getFavoriteIds() async {
    final result = await _cacheService.getAllEntries<DateTime>();
    
    switch (result) {
      case Ok<Map<String, DateTime>>():
        // Sort by DateTime values (most recent first)
        final sortedEntries = result.value.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        
        final orderedIds = sortedEntries.map((entry) => entry.key).toList();
        return Result.ok(orderedIds);
      case Error<Map<String, DateTime>>():
        return const Result.ok([]);
    }
  }

  /// Checks if a restaurant is in favorites.
  ///
  /// Returns [Result] containing true if favorite, false otherwise.
  /// This is a fast lookup operation.
  Future<Result<bool>> isFavorite(String restaurantId) async {
    final result = await _cacheService.get<DateTime>(restaurantId);
    
    switch (result) {
      case Ok<DateTime?>():
        return Result.ok(result.value != null);
      case Error<DateTime?>():
        return const Result.ok(false);
    }
  }

  /// Clears all favorites.
  ///
  /// Returns [Result.ok] on success or [Result.error] on failure.
  Future<Result<void>> clearFavorites() async {
    return await _cacheService.clear();
  }
}