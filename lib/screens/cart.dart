import 'package:cosmetic_supplies_application/widgets/cart_summary.dart';
import 'package:flutter/material.dart';
import 'package:cosmetic_supplies_application/widgets/bottom_nav.dart';
import 'package:cosmetic_supplies_application/widgets/cart_item.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cart',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
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
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: CartSummary(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
