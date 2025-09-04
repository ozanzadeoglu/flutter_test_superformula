import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_tour/core/cache/i_cache_service.dart';
import 'package:restaurant_tour/core/cache/impl/hive_cache_service.dart';
import 'package:restaurant_tour/core/network/api_client.dart';
import 'package:restaurant_tour/core/network/dio_client.dart';
import 'package:restaurant_tour/core/router/app_router.dart';
import 'package:restaurant_tour/core/theme/app_theme.dart';
import 'package:restaurant_tour/data/repositories/restaurant/data_sources/i_restaurant_remote_data_source.dart';
import 'package:restaurant_tour/data/repositories/restaurant/data_sources/restaurant_local_data_source.dart';
import 'package:restaurant_tour/data/repositories/restaurant/data_sources/restaurant_mock_data_source.dart';
import 'package:restaurant_tour/data/repositories/restaurant/impl/restaurant_repository_impl.dart';
import 'package:restaurant_tour/domain/repositories/restaurant_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  // Initialize Hive
  await Hive.initFlutter();
  final favoritesBox = await Hive.openBox('favorites');

  runApp(
    MultiProvider(
      providers: [
        // Core dependencies
        Provider<ApiClient>(
          create: (_) => ApiClient(DioClient.instance.dio),
        ),
        
        // Cache service for favorites
        Provider<ICacheService<RestaurantCache>>(
          create: (_) => HiveCacheService<RestaurantCache>(favoritesBox),
        ),
        
        // Data sources
        Provider<IRestaurantRemoteDataSource>(
          create: (context) => RestaurantMockDataSource(
            context.read<ApiClient>(),
          ), // Change to RestaurantRemoteDataSource for real API
        ),
        Provider<RestaurantLocalDataSource>(
          create: (context) => RestaurantLocalDataSource(
            context.read<ICacheService<RestaurantCache>>(),
          ),
        ),
        
        // Repository (using abstract type for testability)
        Provider<RestaurantRepository>(
          create: (context) => RestaurantRepositoryImpl(
            context.read<IRestaurantRemoteDataSource>(),
            context.read<RestaurantLocalDataSource>(),
          ),
        ),
      ],
      child: const RestaurantTour(),
    ),
  );
}

class RestaurantTour extends StatelessWidget {
  const RestaurantTour({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Restaurant Tour',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}

