import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_tour/UI/home_page/favorite_restaurants/view_model/favorite_restaurants_view_model.dart';
import 'package:restaurant_tour/UI/home_page/common/restaurant_summary_card.dart';
import 'package:restaurant_tour/core/theme/app_paddings.dart';

class FavoriteRestaurantsScreen extends StatefulWidget {
  const FavoriteRestaurantsScreen({super.key});

  @override
  State<FavoriteRestaurantsScreen> createState() => _FavoriteRestaurantsScreenState();
}

class _FavoriteRestaurantsScreenState extends State<FavoriteRestaurantsScreen> {
  @override
  void initState() {
    super.initState();
    // Load favorites when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteRestaurantsViewModel>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteRestaurantsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading && viewModel.favoriteRestaurants.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (viewModel.errorMessage != null && viewModel.favoriteRestaurants.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${viewModel.errorMessage}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => viewModel.refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (viewModel.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap the heart icon on restaurants to add them to favorites',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal:  AppPaddings.sm),
            itemCount: viewModel.favoriteRestaurants.length,
            separatorBuilder: (context, index) => const SizedBox(height: AppPaddings.sm),
            itemBuilder: (context, index) {
              final restaurant = viewModel.favoriteRestaurants[index];
              
              return RestaurantSummaryCard(
                restaurant: restaurant,
                onTap: () {
                  context.push('/restaurant/${restaurant.id}');
                },
              );
            },
          ),
        );
      },
    );
  }
}
