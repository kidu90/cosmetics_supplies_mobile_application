import 'package:flutter/material.dart';
import 'package:cosmetic_supplies_application/screens/product_detailed_screen.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final double price;
  final double originalPrice;
  final String description; // Add description

  const ProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.description, // Add description to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 8.0), // Add horizontal spacing
      child: GestureDetector(
        onTap: () {
          // Navigate to the product detail screen when the card is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailedScreen(
                      image: image,
                      name: name,
                      price: price,
                      originalPrice: originalPrice,
                      description: description, // Pass description
                    )),
          );
        },
        child: Container(
          width: 200,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "\Rs.$price",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "\Rs.$originalPrice",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
