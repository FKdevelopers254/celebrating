import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:celebrate/AuthService.dart';
import '../services/navigation_service.dart';

class AdaptiveBottomNav extends StatelessWidget {
  final int currentIndex;

  const AdaptiveBottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isCelebrity = authService.role?.toLowerCase() == 'celebrity';

    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        if (isCelebrity)
          const BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Profile',
          )
        else
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Create',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        if (!isCelebrity)
          const BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Compare',
          ),
      ],
      onTap: (index) async {
        switch (index) {
          case 0:
            await NavigationService.navigateToFeed(
                context, authService.role ?? 'user');
            break;
          case 1:
            await NavigationService.navigateToProfile(
                context, authService.role ?? 'user');
            break;
          case 2:
            await NavigationService.navigateToPostCreation(context);
            break;
          case 3:
            await NavigationService.navigateToNotifications(context);
            break;
          case 4:
            if (!isCelebrity) {
              await NavigationService.navigateToCompare(context);
            }
            break;
        }
      },
    );
  }
}
