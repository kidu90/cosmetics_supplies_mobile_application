import 'package:flutter/material.dart';
import 'package:cosmetic_supplies_application/shared/bottom_nav.dart';
import 'package:cosmetic_supplies_application/shared/cart_item.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.all(16.0), // Added padding for proper alignment
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Aligns text to the left
          children: [
            Text(
              'Cart',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10), // Added spacing below the title
            CartItem(
              name: 'Lipstick',
              price: 200,
              quantity: 1,
              image: 'assets/images/mattlips.webp',
            ),
            CartItem(
              name: 'Eyeliner',
              price: 150,
              quantity: 2,
              image: 'assets/images/body lotion.jpeg',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
