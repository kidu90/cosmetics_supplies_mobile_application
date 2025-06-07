import 'package:cosmetic_supplies_application/widgets/category_card.dart';
import 'package:cosmetic_supplies_application/widgets/bottom_nav.dart';
import 'package:cosmetic_supplies_application/widgets/offers_card.dart';
import 'package:cosmetic_supplies_application/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:cosmetic_supplies_application/services/api_service.dart';
import 'package:cosmetic_supplies_application/screens/products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = ApiService.fetchProducts();
  }

  Future<String?> _getUserName() async {
    return await ApiService.getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hey",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        FutureBuilder<String?>(
                          future: _getUserName(),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? 'User',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ],
                    ),
                    Icon(
                      Icons.search,
                      size: 40,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ],
                ),
              ),
              CategoryCard(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Newest Arrivals",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductsScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "View More",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<dynamic>>(
                future: _futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return SizedBox(
                      height: 250,
                      child: Center(child: Text('Error: ${snapshot.error}')),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox(
                      height: 250,
                      child: Center(child: Text('No products found')),
                    );
                  } else {
                    final products = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: products.map((product) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, bottom: 12.0),
                            child: ProductCard(
                              id: product['id'],
                              image: product['image'],
                              name: product['name'],
                              price: product['price'].toString(),
                              description: product['description'],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
              const Padding(
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
              const SingleChildScrollView(
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
