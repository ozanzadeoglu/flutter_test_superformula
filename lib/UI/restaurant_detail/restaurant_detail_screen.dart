import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_tour/core/theme/app_colors.dart';
import 'package:restaurant_tour/UI/restaurant_detail/view_model/restaurant_detail_view_model.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;
  
  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Load restaurant detail when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantDetailViewModel>().loadRestaurantDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantDetailViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              viewModel.restaurant?.name ?? 'Restaurant Details',
              style: const TextStyle(
                fontFamily: 'Lora',
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: viewModel.isTogglingFavorite 
                    ? null 
                    : () => viewModel.toggleFavorite(),
                icon: viewModel.isTogglingFavorite
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        viewModel.isFavorited 
                            ? Icons.favorite 
                            : Icons.favorite_border,
                        color: viewModel.isFavorited 
                            ? AppColors.closed 
                            : null,
                      ),
              ),
            ],
          ),
          body: _buildBody(viewModel),
        );
      },
    );
  }

  Widget _buildBody(RestaurantDetailViewModel viewModel) {
    if (viewModel.isLoading && !viewModel.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewModel.errorMessage != null && !viewModel.hasData) {
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

    if (!viewModel.hasData) {
      return const Center(
        child: Text('Restaurant not found'),
      );
    }

    final restaurant = viewModel.restaurant!;

    return RefreshIndicator(
      onRefresh: () => viewModel.refresh(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant hero image - full width maintaining aspect ratio
            _buildHeroImage(restaurant.photos),
            
            // Rest of the content with padding
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic restaurant info for testing
                  Text(
                    'Restaurant ID: ${restaurant.id}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  
                  // Rating
                  if (restaurant.rating != null) ...[
                    Text(
                      'Rating: ${restaurant.rating}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  // Price
                  if (restaurant.price != null) ...[
                    Text(
                      'Price: ${restaurant.price}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  // Location
                  if (restaurant.location != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Location:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    if (restaurant.location!.formattedAddress != null)
                      Text(restaurant.location!.formattedAddress!),
                  ],
                  
                  // Categories
                  if (restaurant.categories != null && restaurant.categories!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Categories:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      restaurant.categories!
                          .map((c) => c.title)
                          .where((title) => title != null)
                          .join(', '),
                    ),
                  ],
                  
                  // Reviews count
                  if (restaurant.reviews != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Reviews: ${restaurant.reviews!.length}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                  
                  // Favorite status for testing
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Debug Info:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text('Is Favorited: ${viewModel.isFavorited}'),
                        Text('Is Loading: ${viewModel.isLoading}'),
                        Text('Is Toggling Favorite: ${viewModel.isTogglingFavorite}'),
                        if (viewModel.errorMessage != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Error: ${viewModel.errorMessage}',
                            style: const TextStyle(color: Colors.red),
                          ),
                          ElevatedButton(
                            onPressed: () => viewModel.clearError(),
                            child: const Text('Clear Error'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage(List<String>? photos) {
    // Get the first photo URL, or use placeholder
    final imageUrl = photos?.isNotEmpty == true 
        ? photos!.first 
        : 'https://picsum.photos/400/240'; // Placeholder image

    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 16 / 9, // You can adjust this ratio as needed
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.placeholder,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.placeholder,
            child: const Icon(
              Icons.error,
              size: 50,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}