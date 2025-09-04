import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_tour/core/errors/app_error.dart';
import 'package:restaurant_tour/data/models/restaurant/restaurant_model.dart';
import 'package:restaurant_tour/data/models/restaurant/restaurant_summary_model.dart';
import 'package:restaurant_tour/query.dart';
import 'package:restaurant_tour/core/utils/result.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);


  /// Fetches Restaurant Summaries, this method will be used for all restaurants tab
  Future<Result<List<RestaurantSummaryModel>>> fetchRestaurantSummaries({
    int limit = 1,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.post(
        "",
        data: restaurantSummariesQuery(limit: limit, offset: offset),
      );

      if (response.statusCode == 200) {
        final businesses = response.data["data"]['search']['business'] as List?;
        if (businesses != null) {
          final restaurantSummaries = businesses
              .map((business) => RestaurantSummaryModel.fromJson(business))
              .toList();
          return Result.ok(restaurantSummaries);
        }
        return const Result.ok([]);
      } else {
        return const Result.error(AppError.unknown);
      }
    } on DioException catch (e) {
      return Result.error(_handleDioException(e));
    } on Exception catch (_) {
      return const Result.error(AppError.unknown);
    }
  }
  
  /// Fetches Restaurant Summaries by their id's, this method will be used for
  /// fetching favorites.
  Future<Result<List<RestaurantSummaryModel>>> fetchRestaurantSummariesWithIds(
    List<String> ids,
  ) async {
    try {
      if (ids.isEmpty) {
        return const Result.ok([]);
      }

      final response = await _dio.post(
        "",
        data: restaurantSummariesWithIdsQuery(ids),
      );

      if (response.statusCode == 200) {
        final data = response.data["data"] as Map<String, dynamic>;
        final restaurantSummaries = <RestaurantSummaryModel>[];
        
        for (int i = 0; i < ids.length; i++) {
          final businessKey = 'business$i';
          if (data[businessKey] != null) {
            restaurantSummaries.add(
              RestaurantSummaryModel.fromJson(data[businessKey]),
            );
          }
        }
        
        return Result.ok(restaurantSummaries);
      } else {
        return const Result.error(AppError.unknown);
      }
    } on DioException catch (e) {
      return Result.error(_handleDioException(e));
    } on Exception catch (_) {
      return const Result.error(AppError.unknown);
    }
  }

  /// Fetches Restaurant Details
  Future<Result<RestaurantModel?>> fetchRestaurant(String id) async {
    try {
      final response = await _dio.post(
        "",
        data: restaurantDetailQuery(id),
      );

      if (response.statusCode == 200) {
        final businessData = response.data["data"]['business'];
        if (businessData != null) {
          return Result.ok(RestaurantModel.fromJson(businessData));
        }
        return const Result.error(AppError.notFound);
      } else {
        return const Result.error(AppError.unknown);
      }
    } on DioException catch (e) {
      return Result.error(_handleDioException(e));
    } on Exception catch (_) {
      return const Result.error(AppError.unknown);
    }
  }

  // Mock methods for development

  Future<Result<List<RestaurantSummaryModel>>> fetchMockRestaurantSummaries({
    int limit = 1,
    int offset = 0,
  }) async {
    try {
      final String mockResponse =
          await rootBundle.loadString('assets/mock_restaurant_summaries.json');
      final Map<String, dynamic> mockData = json.decode(mockResponse);

      await Future.delayed(const Duration(milliseconds: 200));

      final businesses = mockData["data"]['search']['business'] as List?;
      if (businesses != null) {
        final restaurantSummaries = businesses
            .map((business) => RestaurantSummaryModel.fromJson(business))
            .toList();
        return Result.ok(restaurantSummaries);
      }
      return const Result.ok([]);
    } on Exception catch (_) {
      return const Result.error(AppError.unknown);
    }
  }

  Future<Result<List<RestaurantSummaryModel>>> fetchMockRestaurantSummariesWithIds(
    List<String> ids,
  ) async {
    try {
      if (ids.isEmpty) {
        return const Result.ok([]);
      }

      final String mockResponse =
          await rootBundle.loadString('assets/mock_restaurant_summaries_withID.json');
      final Map<String, dynamic> mockData = json.decode(mockResponse);

      await Future.delayed(const Duration(milliseconds: 200));

      final data = mockData["data"] as Map<String, dynamic>;
      final restaurantSummaries = <RestaurantSummaryModel>[];
      
      for (int i = 0; i < ids.length && i < data.keys.length; i++) {
        final businessKey = 'business$i';
        if (data[businessKey] != null) {
          restaurantSummaries.add(
            RestaurantSummaryModel.fromJson(data[businessKey]),
          );
        }
      }
      
      return Result.ok(restaurantSummaries);
    } on Exception catch (_) {
      return const Result.error(AppError.unknown);
    }
  }

  Future<Result<RestaurantModel?>> fetchMockRestaurant(String id) async {
    try {
      final String mockResponse =
          await rootBundle.loadString('assets/mock_restaurant_detail_withID.json');
      final Map<String, dynamic> mockData = json.decode(mockResponse);

      await Future.delayed(const Duration(milliseconds: 200));

      final businessData = mockData["data"]['business'];
      if (businessData != null) {
        return Result.ok(RestaurantModel.fromJson(businessData));
      }
      return const Result.error(AppError.notFound);
    } on Exception catch (_) {
      return const Result.error(AppError.unknown);
    }
  }

  AppError _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return AppError.noNetworkConnection;

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;

        if (statusCode == 404) {
          return AppError.notFound;
        }

        if (statusCode == 401 || statusCode == 403) {
          return AppError.unauthorized;
        }

        if (statusCode != null && statusCode >= 500) {
          return AppError.serverUnavailable;
        }

        return AppError.unknown;

      case DioExceptionType.cancel:
        return AppError.requestCancelled;

      case DioExceptionType.unknown:
      default:
        return AppError.unknown;
    }
  }
}
