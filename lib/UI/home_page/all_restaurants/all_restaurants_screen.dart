import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_tour/UI/home_page/all_restaurants/view_model/all_restaurants_view_model.dart';
import 'package:restaurant_tour/UI/home_page/common/restaurant_summary_card.dart';
import 'package:restaurant_tour/core/theme/app_paddings.dart';

class AllRestaurantsScreen extends StatefulWidget {
  const AllRestaurantsScreen({super.key});

  @override
  State<AllRestaurantsScreen> createState() => _AllRestaurantsScreenState();
}

class _AllRestaurantsScreenState extends State<AllRestaurantsScreen> {
  @override
  void initState() {
    super.initState();
    // Load restaurants when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AllRestaurantsViewModel>().loadRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AllRestaurantsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading && viewModel.restaurants.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (viewModel.errorMessage != null && viewModel.restaurants.isEmpty) {
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
            child: Text('No restaurants found'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal:  AppPaddings.sm),
            itemCount: viewModel.restaurants.length + (viewModel.hasMoreData ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: AppPaddings.sm),
            itemBuilder: (context, index) {
              // Show loading indicator at the end if there's more data
              if (index == viewModel.restaurants.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final restaurant = viewModel.restaurants[index];
              
              // Load more data when reaching near the end
              if (index == viewModel.restaurants.length - 3 && viewModel.hasMoreData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  viewModel.loadMoreRestaurants();
                });
              }

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