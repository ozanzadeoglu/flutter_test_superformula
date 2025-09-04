import 'package:flutter/material.dart';
import 'package:restaurant_tour/core/utils/result.dart';
import 'package:restaurant_tour/domain/entities/restaurant/restaurant.dart';
import 'package:restaurant_tour/domain/repositories/restaurant_repository.dart';

/// ViewModel for the Restaurant Detail screen.
///
/// Manages the state and business logic for displaying detailed restaurant information.
/// Uses [RestaurantRepository] to fetch restaurant details and handle favorites.
class RestaurantDetailViewModel extends ChangeNotifier {
  final RestaurantRepository _repository;
  final String restaurantId;

  RestaurantDetailViewModel(this._repository, this.restaurantId);

  Restaurant? _restaurant;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isFavorited = false;
  bool _isTogglingFavorite = false;

  // Getters
  Restaurant? get restaurant => _restaurant;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isFavorited => _isFavorited;
  bool get isTogglingFavorite => _isTogglingFavorite;
  bool get hasData => _restaurant != null;

  /// Loads the restaurant details and favorite status.
  Future<void> loadRestaurantDetail() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Load restaurant detail and favorite status in parallel
    final results = await Future.wait([
      _repository.fetchRestaurantDetail(restaurantId),
      _repository.isRestaurantFavorited(restaurantId),
    ]);

    final detailResult = results[0] as Result<Restaurant?>;
    final favoriteResult = results[1] as Result<bool>;

    // Handle restaurant detail result
    switch (detailResult) {
      case Ok<Restaurant?>():
        _restaurant = detailResult.value;
        break;
      case Error<Restaurant?>():
        _errorMessage = detailResult.error.toString();
        break;
    }

    // Handle favorite status result
    switch (favoriteResult) {
      case Ok<bool>():
        _isFavorited = favoriteResult.value;
        break;
      case Error<bool>():
        // Don't show error for favorite status, just default to false
        _isFavorited = false;
        break;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Toggles the restaurant's favorite status.
  ///
  /// Updates the repository and local state to reflect the change.
  Future<void> toggleFavorite() async {
    if (_isTogglingFavorite) return;

    _isTogglingFavorite = true;
    notifyListeners();

    final result = await _repository.toggleFavorite(restaurantId);

    switch (result) {
      case Ok<void>():
        // Toggle the local state
        _isFavorited = !_isFavorited;
        break;
      case Error<void>():
        // Show error but keep current state
        _errorMessage = 'Failed to update favorite: ${result.error}';
        break;
    }

    _isTogglingFavorite = false;
    notifyListeners();
  }

  /// Refreshes the restaurant detail.
  Future<void> refresh() async {
    await loadRestaurantDetail();
  }

  /// Clears any error messages.
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}