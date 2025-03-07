import 'package:flutter/material.dart';
import 'package:lmart/core/colors/app_colors.dart';
import 'package:lmart/core/utils.dart';
import 'package:lmart/features/auth/presentation/screens/profile_screen.dart';
import 'package:lmart/features/product/presentation/screens/cart_screen.dart';
import 'package:lmart/features/product/presentation/screens/product_listing_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;  // Track the current selected tab index

  // List of screens
  final List<Widget> _screens = [
    ProductListingScreen(),
    CartScreen(),
    ProfileScreen()
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;  // Update the selected index when a tab is tapped
    });
  }

@override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false,
    child: Scaffold(
      backgroundColor: AppColors.white_1,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _screens[_selectedIndex],
      ), // Just display the selected screen
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(12),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: BottomNavigationBar(
            backgroundColor: AppColors.primaryColor, // Directly set color here
            elevation: 0, // Remove elevation
            currentIndex: _selectedIndex, // Highlight the selected tab
            onTap: _onTabTapped, // Handle tab taps
            iconSize: 24, // Shrink the icon size
            selectedFontSize: 12, // Shrink the font size for the label
            unselectedFontSize: 12, // Shrink the font size for the unselected label
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: getLoc(context).productsTitle,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: getLoc(context).cartTitle,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: getLoc(context).userProfileTitle,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
