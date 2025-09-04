import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_tour/core/theme/app_colors.dart';
import 'package:restaurant_tour/core/theme/app_paddings.dart';
import 'package:restaurant_tour/domain/entities/restaurant/restaurant_summary.dart';

class RestaurantSummaryCard extends StatelessWidget {
  final RestaurantSummary restaurant;
  final VoidCallback? onTap;
  const RestaurantSummaryCard({
    super.key,
    required this.restaurant,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(AppPaddings.xs),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 88,
                height: 88,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppPaddings.xs),
                  child: Hero(
                    tag: restaurant,
                    child: CachedNetworkImage(
                      imageUrl: restaurant.heroImage,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: AppPaddings.sm,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 48,
                      child: Text(
                        restaurant.name ?? "Unknown",
                        style: Theme.of(context).textTheme.headlineSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: AppPaddings.xxs),
                    _RestaurantPriceAndTag(restaurant),
                    const SizedBox(height: AppPaddings.xxs),
                    Row(
                      children: [
                        _RestaurantRating(restaurant.rating),
                        const Spacer(),
                        _RestaurantStatus(restaurant.isOpen),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _RestaurantPriceAndTag extends StatelessWidget {
  final RestaurantSummary restaurant;
  const _RestaurantPriceAndTag(this.restaurant);

  @override
  Widget build(BuildContext context) {
    final price = restaurant.price;
    final categoriesString = categoriesToString();
    return Text(
      "$price $categoriesString",
      style: Theme.of(context).textTheme.bodySmall,
      overflow: TextOverflow.ellipsis,
    );
  }

  String categoriesToString() {
    if (restaurant.categories != null) {
      return restaurant.categories!
          .map((category) => category.title)
          .where((title) => title != null)
          .join(' ');
    }
    return "";
  }
}

class _RestaurantRating extends StatelessWidget {
  final double? rating;
  const _RestaurantRating(this.rating);

  @override
  Widget build(BuildContext context) {
    final roundedRating = rating?.round();
    return roundedRating != null
        ? SizedBox(
            height: 14,
            child: ListView.builder(
              itemCount: roundedRating,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return const Icon(Icons.star, color: AppColors.star, size: 14);
              },
            ),
          )
        : const SizedBox.shrink();
  }
}

class _RestaurantStatus extends StatelessWidget {
  final bool isOpen;
  const _RestaurantStatus(this.isOpen);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          isOpen ? "Open now" : "Closed",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(
          width: AppPaddings.xs,
        ),
        Column(
          children: [
            const SizedBox(height: 4),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isOpen ? AppColors.open : AppColors.closed,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
