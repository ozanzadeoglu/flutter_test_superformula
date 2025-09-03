import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static const _baseUrl = "https://api.yelp.com/v3/graphql";
  static const _authorizationHeader = "Authorization";
  static const _headerContentType = "Content-Type";
  static const _contentTypeJson = "application/graphql";
  static final String _apiKey2 = "Bearer ${dotenv.env['YELP_API_KEY']}";


  static final Dio _dio = Dio(
    BaseOptions(

      baseUrl: _baseUrl,
      headers: {
        _authorizationHeader: _apiKey2,
        _headerContentType: _contentTypeJson,
      },
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  DioClient._internal();

  static final DioClient instance = DioClient._internal();

  Dio get dio => _dio;


}