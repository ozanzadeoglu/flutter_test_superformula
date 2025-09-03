import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_tour/core/errors/app_error.dart';
import 'package:restaurant_tour/models/restaurant.dart';
import 'package:restaurant_tour/query.dart';
import 'package:restaurant_tour/core/utils/result.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<Result<RestaurantQueryResult?>> getRestaurants({
    int offset = 0,
  }) async {
    try {
      final response = await _dio.post(
        "",
        data: query(offset),
      );

      if (response.statusCode == 200) {
        return Result.ok(
          RestaurantQueryResult.fromJson(
            response.data["data"]['search'],
          ),
        );
      } else {
        return const Result.error(AppError.unknown);
      }
    } on DioException catch (e) {
      return Result.error(_handleDioException(e));
    } on Exception catch (_) {
      return const Result.error(AppError.unknown);
    }
  }

  Future<Result<RestaurantQueryResult?>> getMockRestaurants({
    int offset = 0,
  }) async {
    try {
      final String mockResponse =
          await rootBundle.loadString('assets/mock.json');
      final Map<String, dynamic> mockData = json.decode(mockResponse);

      // Simulate network delay F
      await Future.delayed(const Duration(milliseconds: 200));

      return Result.ok(
        RestaurantQueryResult.fromJson(
          mockData["data"]['search'],
        ),
      );
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
