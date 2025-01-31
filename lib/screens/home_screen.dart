import 'package:cosmetic_supplies_application/widgets/category_card.dart';
import 'package:cosmetic_supplies_application/widgets/bottom_nav.dart';
import 'package:cosmetic_supplies_application/widgets/offers_card.dart';
import 'package:cosmetic_supplies_application/widgets/product_card.dart';
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
                    const Column(
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
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ],
                ),
              ),
              CategoryCard(),
              const Padding(
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
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, bottom: 12.0),
                      child: ProductCard(
                        image: 'assets/images/faceCream.jpg',
                        name: 'Face Cream',
                        price: 2000,
                        originalPrice: 2500,
                        description:
                            "A luxurious face cream that deeply hydrates and nourishes your skin. Enriched with vitamins and antioxidants, it helps to reduce the appearance of fine lines and wrinkles, leaving your skin looking smooth and radiant. Suitable for all skin types, this cream is perfect for daily use to keep your skin healthy and glowing.",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, bottom: 12.0),
                      child: ProductCard(
                        image: 'assets/images/mattlips.webp',
                        name: 'Matt Lipstick',
                        price: 1500,
                        originalPrice: 2000,
                        description:
                            "A creamy and highly-pigmented lipstick that delivers rich, bold color in just one swipe. Its moisturizing formula keeps your lips hydrated while providing long-lasting wear. Available in a variety of shades, it adds a touch of glamour and confidence to your look.",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, bottom: 12.0),
                      child: ProductCard(
                        image: 'assets/images/eyeliner.jpg',
                        name: 'Eyeliner',
                        price: 650,
                        originalPrice: 800,
                        description:
                            "This smooth and creamy eyeliner delivers bold, defined lines with precision. Its long-lasting formula is resistant to smudging, ensuring that your eye makeup stays in place throughout the day or night. ",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, bottom: 12.0),
                      child: ProductCard(
                        image: 'assets/images/shadow.jpg',
                        name: 'Eye Shadow',
                        price: 1500,
                        originalPrice: 1800,
                        description:
                            "his versatile eyeshadow palette offers a wide range of vibrant, blendable shades perfect for creating any eye look. The formula is smooth and highly pigmented, allowing for rich, long-lasting color that won’t fade throughout the day.",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, bottom: 12.0),
                      child: ProductCard(
                        image: 'assets/images/body lotion.jpeg',
                        name: 'Body Lotion',
                        price: 800,
                        originalPrice: 900,
                        description:
                            "A rich, nourishing body lotion that moisturizes and softens your skin all day long. Enriched with vitamin E and natural oils, it provides deep hydration, leaving your skin feeling silky smooth and rejuvenated. Perfect for daily use to keep your skin soft and glowing",
                      ),
                    ),
                  ],
                ),
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
