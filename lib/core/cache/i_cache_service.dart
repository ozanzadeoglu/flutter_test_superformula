import 'package:restaurant_tour/core/utils/result.dart';

class RestaurantCache{}

/// Defines the contract for a generic key-value caching service.
///
/// This abstraction allows the underlying cache implementation
/// to be swapped without affecting the restaurant data sources that use it.
/// Used for caching restaurant lists, favorites, and other app data.
/// 
/// The type parameter [R] is used solely for dependency
/// injection and service differentiation. It has no impact on the runtime
/// behavior or the types of values stored in the cache.
abstract class ICacheService<R> {

  /// Retrieves a value of type [T] from the cache for the given [key].
  ///
  /// Returns a [Result.ok] containing the value (or `null` if not found)
  /// or [Result.error] with [AppError] on cache errors.
  Future<Result<T?>> get<T>(String key);

  /// Saves a [value] of type [T] to the cache with the given [key].
  ///
  /// Returns [Result.ok] on success or [Result.error]
  /// with [AppError] on cache write errors.
  Future<Result<void>> put<T>(String key, T value);

  /// Deletes the value associated with the given [key] from the cache.
  ///
  /// Returns [Result.ok] on success or [Result.error]
  /// with [AppError] on cache deletion errors.
  Future<Result<void>> delete(String key);
  
  /// Clears all data from the cache.
  ///
  /// Returns [Result.ok] on success or [Result.error]
  /// with [AppError] on cache clearing errors.
  Future<Result<void>> clear();

  /// Checks if the cache storage is empty.
  ///
  /// Returns true if the cache contains no data, false otherwise.
  bool isBoxEmpty();

  /// Retrieves all values from the cache.
  ///
  /// Returns [Result.ok] containing a list of all cached values
  /// or [Result.error] with [AppError] on cache errors.
  Future<Result<List<T>>> getAll<T>();

  /// Retrieves all key-value pairs from the cache.
  ///
  /// Returns [Result.ok] containing a map of all cached key-value pairs
  /// or [Result.error] with [AppError] on cache errors.
  Future<Result<Map<String, T>>> getAllEntries<T>();
}