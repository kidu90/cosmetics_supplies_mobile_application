import 'package:flutter/material.dart';
import 'package:cosmetic_supplies_application/screens/home_screen.dart';
import 'package:cosmetic_supplies_application/screens/cart.dart';
import 'package:cosmetic_supplies_application/screens/favourite_screen.dart';
import 'package:cosmetic_supplies_application/screens/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _selectedIndex;

  final List<Widget> _screens = [
    HomeScreen(),
    Cart(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _screens[index]),
      ).then((_) {
        setState(() {
          _selectedIndex = index;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: isDarkMode ? Colors.white : Colors.black,
      unselectedItemColor: isDarkMode ? Colors.grey : Colors.black45,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
