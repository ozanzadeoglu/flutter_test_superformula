import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home shell widget that provides tab navigation between restaurants and favorites.
class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: 2,
      initialIndex: _getCurrentTabIndex(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'RestaurantTour',
            style: TextStyle(
              fontFamily: 'Lora',
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
            dividerHeight: 0,
            onTap: (index) => _onTabTapped(context, index),
            tabAlignment: TabAlignment.center,
            labelStyle: const TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.7,
              color: Colors.black,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.7,
              color: Color.fromARGB(255, 96, 96, 96),
            ),
            tabs: const [ 
              Tab(text: 'All Restaurants',),
              Tab(text: 'My Favorites'),
            ],
          ),
        ),
        body: child,
      ),
    );
  }

  /// Gets the current tab index based on the current route.
  int _getCurrentTabIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location == '/favorites') {
      return 1;
    }
    return 0; // Default to restaurants tab
  }

  /// Handles tab tap events by navigating to the appropriate route.
  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/restaurants');
        break;
      case 1:
        context.go('/favorites');
        break;
    }
  }
}