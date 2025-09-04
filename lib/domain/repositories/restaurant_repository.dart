import 'package:restaurant_tour/core/utils/result.dart';
import 'package:restaurant_tour/domain/entities/restaurant/restaurant.dart';
import 'package:restaurant_tour/domain/entities/restaurant/restaurant_summary.dart';

/// Repository interface for restaurant data operations.
/// 
/// This interface defines the contract for restaurant data access,
/// abstracting the underlying data sources (API, local storage, cache).
/// Implementations should handle data fetching, caching, and error management.
abstract class RestaurantRepository {
  /// Fetches a list of restaurant summaries for the main restaurant list view.
  /// 
  /// This method retrieves restaurant data suitable for displaying in list views,
  /// containing essential information like name, rating, price, and photos.
  /// Used primarily in the "All Restaurants" tab.
  /// 
  /// [limit] - Maximum number of restaurants to fetch (default: 20)
  /// [offset] - Number of restaurants to skip for pagination (default: 0)
  /// 
  /// Returns a [Result] containing either:
  /// - Success: List of [RestaurantSummary] objects
  /// - Error: [AppError] describing what went wrong
  Future<Result<List<RestaurantSummary>>> fetchAllRestaurants({
    int limit = 20,
    int offset = 0,
  });

  /// Fetches restaurant summaries for favorited restaurants.
  /// 
  /// This method retrieves restaurant data for restaurants that have been
  /// marked as favorites by the user. It fetches the current data from
  /// the remote API using stored favorite IDs, ensuring fresh information.
  /// Used primarily in the "Favorites" tab.
  /// 
  /// Returns a [Result] containing either:
  /// - Success: List of [RestaurantSummary] objects for favorited restaurants
  /// - Error: [AppError] describing what went wrong
  /// 
  /// Note: Returns empty list if no favorites are stored locally.
  Future<Result<List<RestaurantSummary>>> fetchFavorites();

  /// Fetches detailed information for a specific restaurant.
  /// 
  /// This method retrieves comprehensive restaurant data including
  /// reviews, location details, and all available information.
  /// Used for the restaurant detail view when a user taps on a restaurant.
  /// 
  /// [id] - Unique identifier of the restaurant to fetch
  /// 
  /// Returns a [Result] containing either:
  /// - Success: [Restaurant] object with complete details, or null if not found
  /// - Error: [AppError] describing what went wrong
  Future<Result<Restaurant?>> fetchRestaurantDetail(String id);

  /// Toggles a restaurant's favorite status.
  ///
  /// Adds to favorites if not currently favorited, removes if already favorited.
  /// Returns [Result.ok] on success or [Result.error] on failure.
  Future<Result<void>> toggleFavorite(String restaurantId);

  /// Checks if a restaurant is currently favorited.
  ///
  /// Returns [Result] containing true if favorited, false otherwise.
  /// Used for updating heart icon states in the UI.
  Future<Result<bool>> isRestaurantFavorited(String restaurantId);

  /// Clears all favorites.
  ///
  /// Returns [Result.ok] on success or [Result.error] on failure.
  Future<Result<void>> clearAllFavorites();
}