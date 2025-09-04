import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_tour/UI/home_page/all_restaurants/all_restaurants_screen.dart';
import 'package:restaurant_tour/UI/home_page/favorite_restaurants/favorite_restaurants_screen.dart';
import 'package:restaurant_tour/UI/home_page/all_restaurants/view_model/all_restaurants_view_model.dart';
import 'package:restaurant_tour/UI/home_page/favorite_restaurants/view_model/favorite_restaurants_view_model.dart';
import 'package:restaurant_tour/UI/restaurant_detail/restaurant_detail_screen.dart';
import 'package:restaurant_tour/UI/restaurant_detail/view_model/restaurant_detail_view_model.dart';
import 'package:restaurant_tour/domain/repositories/restaurant_repository.dart';
import 'package:restaurant_tour/core/router/home_shell.dart';

/// Application router configuration using GoRouter.
///
/// Defines routes for the restaurant app with a tab-based home shell
/// containing All Restaurants and My Favorites tabs, plus restaurant detail view.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/restaurants',
    routes: [
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: '/restaurants',
            name: 'restaurants',
            builder: (context, state) => ChangeNotifierProvider(
              create: (context) => AllRestaurantsViewModel(
                context.read<RestaurantRepository>(),
              ),
              child: const AllRestaurantsScreen(),
            ),
          ),
          GoRoute(
            path: '/favorites',
            name: 'favorites',
            builder: (context, state) => ChangeNotifierProvider(
              create: (context) => FavoriteRestaurantsViewModel(
                context.read<RestaurantRepository>(),
              ),
              child: const FavoriteRestaurantsScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/restaurant/:id',
        name: 'restaurant-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ChangeNotifierProvider(
            create: (context) => RestaurantDetailViewModel(
              context.read<RestaurantRepository>(),
              id,
            ),
            child: RestaurantDetailScreen(restaurantId: id),
          );
        },
      ),
    ],
  );
}