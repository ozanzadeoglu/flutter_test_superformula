import 'package:flutter/material.dart';
import 'package:restaurant_tour/core/utils/result.dart';
import 'package:restaurant_tour/domain/entities/restaurant/restaurant_summary.dart';
import 'package:restaurant_tour/domain/repositories/restaurant_repository.dart';

/// ViewModel for the All Restaurants screen.
///
/// Manages the state and business logic for displaying the list of all restaurants.
/// Uses [RestaurantRepository] to fetch restaurant data and handles loading states.
class AllRestaurantsViewModel extends ChangeNotifier {
  final RestaurantRepository _repository;

  AllRestaurantsViewModel(this._repository);

  List<RestaurantSummary> _restaurants = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasMoreData = true;
  int _currentOffset = 0;
  static const int _pageSize = 20;

  // Getters
  List<RestaurantSummary> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;
  bool get isEmpty => _restaurants.isEmpty && !_isLoading;

  /// Loads the initial page of restaurants.
  ///
  /// Clears existing data and fetches the first page from the repository.
  Future<void> loadRestaurants() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    _currentOffset = 0;
    _hasMoreData = true;
    notifyListeners();

    final result = await _repository.fetchAllRestaurants(
      limit: _pageSize,
      offset: _currentOffset,
    );

    switch (result) {
      case Ok<List<RestaurantSummary>>():
        _restaurants = result.value;
        _hasMoreData = result.value.length == _pageSize;
        _currentOffset = _pageSize;
        break;
      case Error<List<RestaurantSummary>>():
        _errorMessage = result.error.toString();
        _restaurants = [];
        break;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Loads more restaurants for pagination.
  ///
  /// Appends additional restaurants to the existing list.
  Future<void> loadMoreRestaurants() async {
    if (_isLoading || !_hasMoreData) return;

    _isLoading = true;
    notifyListeners();

    final result = await _repository.fetchAllRestaurants(
      limit: _pageSize,
      offset: _currentOffset,
    );

    switch (result) {
      case Ok<List<RestaurantSummary>>():
        _restaurants.addAll(result.value);
        _hasMoreData = result.value.length == _pageSize;
        _currentOffset += result.value.length;
        break;
      case Error<List<RestaurantSummary>>():
        _errorMessage = result.error.toString();
        break;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refreshes the restaurant list.
  ///
  /// Clears existing data and reloads from the beginning.
  Future<void> refresh() async {
    await loadRestaurants();
  }

  /// Toggles a restaurant's favorite status.
  ///
  /// Updates the repository and refreshes the list to reflect changes.
  Future<void> toggleFavorite(String restaurantId) async {
    final result = await _repository.toggleFavorite(restaurantId);
    
    switch (result) {
      case Ok<void>():
        // Success - optionally refresh the list to show updated favorite status
        break;
      case Error<void>():
        _errorMessage = result.error.toString();
        notifyListeners();
        break;
    }
  }
}