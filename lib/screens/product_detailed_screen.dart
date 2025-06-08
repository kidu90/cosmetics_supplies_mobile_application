import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductDetailedScreen extends StatefulWidget {
  final int productId;
  final String name;
  final String price;
  final String description;
  final String image;

  const ProductDetailedScreen({
    super.key,
    required this.productId,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });

  @override
  State<ProductDetailedScreen> createState() => _ProductDetailedScreenState();
}

class _ProductDetailedScreenState extends State<ProductDetailedScreen> {
  final _commentController = TextEditingController();
  final _imagePicker = ImagePicker();
  File? _reviewImage;
  int _rating = 0;
  bool _isSubmitting = false;
  List<dynamic> _reviews = [];
  bool _isLoadingReviews = true;
  int _quantity = 1;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadReviews() async {
    try {
      final reviews = await ApiService.getProductReviews(widget.productId);
      setState(() {
        _reviews = reviews;
        _isLoadingReviews = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingReviews = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading reviews: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 800,
      );
      if (image != null) {
        setState(() {
          _reviewImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a comment')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ApiService.submitReview(
        productId: widget.productId,
        rating: _rating,
        comment: _commentController.text.trim(),
        photo: _reviewImage,
      );

      // Reset form
      setState(() {
        _rating = 0;
        _commentController.clear();
        _reviewImage = null;
        _isSubmitting = false;
      });

      // Reload reviews
      await _loadReviews();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting review: $e')),
        );
      }
    }
  }

  Future<void> _addToCart() async {
    setState(() {
      _isAddingToCart = true;
    });

    try {
      await ApiService.addToCart(widget.productId, _quantity);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added to cart successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding to cart: $e')),
        );
      }
    } finally {
      setState(() {
        _isAddingToCart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Image.network(
              widget.image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Price
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.price}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Product Description
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  // Quantity Selector and Add to Cart
                  Row(
                    children: [
                      // Quantity Selector
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _quantity > 1
                                  ? () {
                                      setState(() {
                                        _quantity--;
                                      });
                                    }
                                  : null,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Add to Cart Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isAddingToCart ? null : _addToCart,
                          icon: _isAddingToCart
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.shopping_cart),
                          label: Text(
                            _isAddingToCart ? 'Adding...' : 'Add to Cart',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Review Section
                  const Text(
                    'Write a Review',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Rating Stars
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  // Review Comment
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Write your review here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Image Upload
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Add Photo'),
                      ),
                      if (_reviewImage != null) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: Stack(
                            children: [
                              Image.file(
                                _reviewImage!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _reviewImage = null;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitReview,
                      child: _isSubmitting
                          ? const CircularProgressIndicator()
                          : const Text('Submit Review'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Reviews List
                  const Text(
                    'Customer Reviews',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoadingReviews)
                    const Center(child: CircularProgressIndicator())
                  else if (_reviews.isEmpty)
                    const Center(
                      child: Text('No reviews yet. Be the first to review!'),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _reviews.length,
                      itemBuilder: (context, index) {
                        final review = _reviews[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      child: Text(
                                        review['user']['name'][0].toUpperCase(),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      review['user']['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: List.generate(5, (index) {
                                        return Icon(
                                          index < review['rating']
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 16,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                if (review['image'] != null) ...[
                                  const SizedBox(height: 8),
                                  Image.network(
                                    review['image'],
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Text(review['comment']),
                                const SizedBox(height: 8),
                                Text(
                                  DateTime.parse(review['created_at'])
                                      .toString()
                                      .split('.')[0],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
