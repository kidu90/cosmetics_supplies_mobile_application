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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, bottom: 12.0),
                      child: ProductCard(
                        image: 'assets/images/faceCream.jpg',
                        name: 'Face Cream',
                        price: 200,
                        originalPrice: 250,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, bottom: 12.0),
                      child: ProductCard(
                        image: 'assets/images/mattlips.webp',
                        name: 'Matt Lipstick',
                        price: 150,
                        originalPrice: 200,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, bottom: 12.0),
                      child: ProductCard(
                        image: 'assets/images/body lotion.jpeg',
                        name: 'Body Lotion',
                        price: 150,
                        originalPrice: 200,
                      ),
                    ),
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
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    OffersCard(
                      image: 'assets/images/banner3.jpg',
                      name: 'Face serum',
                      subtitle: '50% OFF Today',
                    ),
                    OffersCard(
                      image: 'assets/images/banner2.jpg',
                      name: 'Makeup set',
                      subtitle: 'Get 30% OFF on your first order',
                    ),
                    OffersCard(
                      image: 'assets/images/banner.jpg',
                      name: 'Acure Body Lotion',
                      subtitle: '30% off',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
