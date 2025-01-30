import 'package:cosmetic_supplies_application/screens/cart.dart';
import 'package:cosmetic_supplies_application/screens/favourite_screen.dart';
import 'package:cosmetic_supplies_application/screens/profile_screen.dart';
import 'package:cosmetic_supplies_application/shared/category_card.dart';
import 'package:cosmetic_supplies_application/shared/bottom_nav.dart';
import 'package:cosmetic_supplies_application/shared/offers_card.dart';
import 'package:cosmetic_supplies_application/shared/product_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    Cart(),
    FavouriteScreen(),
    ProfileScreen(),

    // Your profile screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hey",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Masha",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.search,
                      size: 40,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              CategoryCard(),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Newest Arrivals",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Icon(
                      Icons.tune,
                      size: 25,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ProductCard(
                        image: 'assets/body lotion.jpeg',
                        name: 'Body Loaction',
                        price: 200,
                        originalPrice: 250),
                    ProductCard(
                        image: 'assets/body lotion.jpeg',
                        name: 'Face Cream',
                        price: 150,
                        originalPrice: 200),
                    ProductCard(
                        image: 'assets/body lotion.jpeg',
                        name: 'Face Cream',
                        price: 150,
                        originalPrice: 200),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Seasonal offers",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    OffersCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(), // Fixed at the bottom
    );
  }
}
