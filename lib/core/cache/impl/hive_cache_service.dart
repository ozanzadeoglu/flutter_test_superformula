import 'package:hive/hive.dart';
import 'package:restaurant_tour/core/cache/i_cache_service.dart';
import 'package:restaurant_tour/core/errors/app_error.dart';
import 'package:restaurant_tour/core/utils/result.dart';

/// Local storage implementation for restaurant app caching.
/// 
/// An implementation of [ICacheService] that uses a Hive [Box] for storage,
/// wrapping results in [Result] to standardize success/failure handling.
///
/// Used for caching restaurant data, favorites, and other app information
/// to improve performance and enable offline functionality.
/// 
/// Check [ICacheService] doc strings to learn about [R] type.
class HiveCacheService<R> implements ICacheService<R> {
  final Box _box;

  /// Creates a [HiveCacheService] using the given Hive [Box].
  ///
  /// The [_box] parameter should be an initialized Hive box instance.
  HiveCacheService(this._box);

  /// Retrieves a value of type [T] from the cache for the given [key].
  ///
  /// Returns [Result.ok] containing the value (or `null` if not found),
  /// or [Result.error] with [AppError.cacheReadFailed] on Hive errors,
  /// or [AppError.unknown] on any other exceptions.
  @override
  Future<Result<T?>> get<T>(String key) async {
    try {
      final raw = await _box.get(key);
      return Result.ok(raw as T?);
    } on HiveError catch (_) {
      return const Result.error(AppError.cacheReadFailed);
    } catch (e) {
      return const Result.error(AppError.unknown);
    }
  }

  /// Saves a [value] of type [T] to the cache with the given [key].
  ///
  /// Returns [Result.ok] on success or [Result.error]
  /// with [AppError.cacheWriteFailed] on Hive errors,
  /// or [AppError.unknown] on any other exceptions.
  @override
  Future<Result<void>> put<T>(String key, T value) async {
    try {
      await _box.put(key, value);
      return const Result.ok(null);
    } on HiveError catch (_) {
      return const Result.error(AppError.cacheWriteFailed);
    } catch (e) {
      return const Result.error(AppError.unknown);
    }
  }

  /// Deletes the value associated with the given [key] from the cache.
  ///
  /// Returns [Result.ok] on success or [Result.error]
  /// with [AppError.cacheWriteFailed] on Hive errors,
  /// or [AppError.unknown] on any other exceptions.
  @override
  Future<Result<void>> delete(String key) async {
    try {
      await _box.delete(key);
      return const Result.ok(null);
    } on HiveError catch (_) {
      return const Result.error(AppError.cacheWriteFailed);
    } catch (e) {
      return const Result.error(AppError.unknown);
    }
  }

  /// Clears all data from the cache.
  ///
  /// Returns [Result.ok] on success or [Result.error]
  /// with [AppError.cacheWriteFailed] on Hive errors,
  /// or [AppError.unknown] on any other exceptions.
  @override
  Future<Result<void>> clear() async {
    try {
      await _box.clear();
      return const Result.ok(null);
    } on HiveError catch (_) {
      return const Result.error(AppError.cacheWriteFailed);
    } catch (e) {
      return const Result.error(AppError.unknown);
    }
  }

  @override
  bool isBoxEmpty() {
    return _box.isEmpty;
  }

  /// Retrieves all values from the cache.
  ///
  /// Returns [Result.ok] containing a list of all cached values
  /// or [Result.error] with [AppError.cacheReadFailed] on Hive errors,
  /// or [AppError.unknown] on any other exceptions.
  @override
  Future<Result<List<T>>> getAll<T>() async {
    try {
      final values = _box.values.cast<T>().toList();
      return Result.ok(values);
    } on HiveError catch (_) {
      return const Result.error(AppError.cacheReadFailed);
    } catch (e) {
      return const Result.error(AppError.unknown);
    }
  }

  /// Retrieves all key-value pairs from the cache.
  ///
  /// Returns [Result.ok] containing a map of all cached key-value pairs
  /// or [Result.error] with [AppError.cacheReadFailed] on Hive errors,
  /// or [AppError.unknown] on any other exceptions.
  @override
  Future<Result<Map<String, T>>> getAllEntries<T>() async {
    try {
      final Map<String, T> entries = {};
      for (final key in _box.keys) {
        final value = _box.get(key);
        if (value is T) {
          entries[key.toString()] = value;
        }
      }
      return Result.ok(entries);
    } on HiveError catch (_) {
      return const Result.error(AppError.cacheReadFailed);
    } catch (e) {
      return const Result.error(AppError.unknown);
    }
  }
  
}