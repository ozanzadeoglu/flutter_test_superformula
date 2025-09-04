import 'package:flutter/material.dart';
import 'package:restaurant_tour/core/utils/result.dart';
import 'package:restaurant_tour/domain/entities/restaurant/restaurant_summary.dart';
import 'package:restaurant_tour/domain/repositories/restaurant_repository.dart';

/// ViewModel for the Favorite Restaurants screen.
///
/// Manages the state and business logic for displaying the user's favorite restaurants.
/// Uses [RestaurantRepository] to fetch favorite restaurant data and handle favorites management.
class FavoriteRestaurantsViewModel extends ChangeNotifier {
  final RestaurantRepository _repository;

  FavoriteRestaurantsViewModel(this._repository);

  List<RestaurantSummary> _favoriteRestaurants = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<RestaurantSummary> get favoriteRestaurants => _favoriteRestaurants;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _favoriteRestaurants.isEmpty && !_isLoading;

  /// Loads all favorite restaurants.
  ///
  /// Fetches the user's favorite restaurants from the repository in historical order
  /// (most recently favorited first).
  Future<void> loadFavorites() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.fetchFavorites();

    switch (result) {
      case Ok<List<RestaurantSummary>>():
        _favoriteRestaurants = result.value;
        break;
      case Error<List<RestaurantSummary>>():
        _errorMessage = result.error.toString();
        _favoriteRestaurants = [];
        break;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refreshes the favorites list.
  ///
  /// Reloads favorites from the repository to ensure the list is up to date.
  Future<void> refresh() async {
    await loadFavorites();
  }

  /// Removes a restaurant from favorites.
  ///
  /// Updates the repository and refreshes the favorites list.
  Future<void> removeFromFavorites(String restaurantId) async {
    final result = await _repository.toggleFavorite(restaurantId);
    
    switch (result) {
      case Ok<void>():
        // After removing, refresh the list
        await loadFavorites();
        break;
      case Error<void>():
        _errorMessage = result.error.toString();
        notifyListeners();
        break;
    }
  }

  /// Toggles a restaurant's favorite status.
  ///
  /// If favorited, removes from favorites. If not favorited, adds to favorites.
  Future<void> toggleFavorite(String restaurantId) async {
    final result = await _repository.toggleFavorite(restaurantId);
    
    switch (result) {
      case Ok<void>():
        // After toggling, refresh the list
        await loadFavorites();
        break;
      case Error<void>():
        _errorMessage = result.error.toString();
        notifyListeners();
        break;
    }
  }

  /// Clears all favorites.
  ///
  /// Removes all restaurants from the user's favorites list.
  Future<void> clearAllFavorites() async {
    final result = await _repository.clearAllFavorites();
    
    switch (result) {
      case Ok<void>():
        // After clearing, refresh the list
        await loadFavorites();
        break;
      case Error<void>():
        _errorMessage = result.error.toString();
        notifyListeners();
        break;
    }
  }
}