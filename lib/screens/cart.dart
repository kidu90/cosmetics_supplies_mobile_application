import 'package:flutter/material.dart';
import 'package:cosmetic_supplies_application/widgets/bottom_nav.dart';
import 'package:cosmetic_supplies_application/services/api_service.dart';
import 'package:cosmetic_supplies_application/screens/check_out_screen.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool _isLoading = true;
  List<dynamic> _cartItems = [];
  double _subtotal = 0;
  double _shipping = 500;
  double _tax = 0;
  double _total = 0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.getCart();
      if (!mounted) return;

      setState(() {
        _cartItems = response['items'];
        _subtotal = double.parse(response['total'].toString());
        _calculateTotals();
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _calculateTotals() {
    _tax = _subtotal * 0.1;
    _total = _subtotal + _shipping + _tax;
  }

  Future<void> _updateQuantity(int cartId, int quantity) async {
    try {
      await ApiService.updateCartItem(cartId, quantity);
      await _loadCartItems(); // Reload cart items after update
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating quantity: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeItem(int cartId) async {
    try {
      await ApiService.removeFromCart(cartId);
      await _loadCartItems(); // Reload cart items after removal
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          'Cart',
          style: TextStyle(color: Colors.grey[800]),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.grey[700]!),
                    ),
                  )
                : _cartItems.isEmpty
                    ? Center(
                        child: Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cart',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 16),
                            ..._cartItems.map((item) => _buildCartItem(item)),
                            const SizedBox(height: 24),
                            _buildCartSummary(),
                          ],
                        ),
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _cartItems.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutScreen(),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    final price = double.parse(item['price'].toString());
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item['product']['image'] ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(Icons.image, size: 32, color: Colors.grey[400]),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['product']['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs. ${price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (item['quantity'] > 1) {
                            _updateQuantity(item['id'], item['quantity'] - 1);
                          }
                        },
                        icon: Icon(Icons.remove_circle_outline,
                            color: Colors.grey[700]),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          item['quantity'].toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _updateQuantity(item['id'], item['quantity'] + 1);
                        },
                        icon: Icon(Icons.add_circle_outline,
                            color: Colors.grey[700]),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => _removeItem(item['id']),
                        icon:
                            Icon(Icons.delete_outline, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal:', style: TextStyle(color: Colors.grey[700])),
                Text(
                  'Rs. ${_subtotal.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shipping:', style: TextStyle(color: Colors.grey[700])),
                Text(
                  'Rs. ${_shipping.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tax (10%):', style: TextStyle(color: Colors.grey[700])),
                Text(
                  'Rs. ${_tax.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  'Rs. ${_total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
