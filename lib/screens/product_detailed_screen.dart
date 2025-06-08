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
  String? _reviewError;

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
      setState(() {
        _isLoadingReviews = true;
        _reviewError = null;
      });

      final response = await ApiService.getProductReviews(widget.productId);
      setState(() {
        _reviews = response['reviews'] ?? [];
        _isLoadingReviews = false;
      });
    } catch (e) {
      setState(() {
        _reviewError = e.toString();
        _isLoadingReviews = false;
      });
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

    try {
      setState(() {
        _isSubmitting = true;
        _reviewError = null;
      });

      await ApiService.submitReview(
        productId: widget.productId,
        rating: _rating,
        comment: _commentController.text,
        photo: _reviewImage,
      );

      // Clear form
      _rating = 0;
      _commentController.clear();
      setState(() {
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
        _reviewError = e.toString();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(widget.name),
        elevation: 0,
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
            Container(
              color: Colors.grey[100],
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
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.price}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Product Description
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Quantity Selector and Add to Cart
                  Row(
                    children: [
                      // Quantity Selector
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: Colors.grey[700]),
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
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.grey[700]),
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Icon(Icons.shopping_cart),
                          label: Text(
                            _isAddingToCart ? 'Adding...' : 'Add to Cart',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Review Section
                  Text(
                    'Write a Review',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Rating Stars
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
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
                    decoration: InputDecoration(
                      hintText: 'Write your review here...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Image Upload
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.image, color: Colors.grey[700]),
                        label: Text(
                          'Add Photo',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                        ),
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
                                  icon: Icon(Icons.close,
                                      color: Colors.grey[700]),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('Submit Review'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Reviews List
                  Text(
                    'Customer Reviews',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoadingReviews)
                    Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.grey[700]!),
                      ),
                    )
                  else if (_reviews.isEmpty)
                    Center(
                      child: Text(
                        'No reviews yet. Be the first to review!',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _reviews.length,
                      itemBuilder: (context, index) {
                        final review = _reviews[index];
                        return _buildReviewItem(review);
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

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, size: 24, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['user_name'] ?? 'Anonymous User',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
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
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      size: 20,
                      color: index < review['rating']
                          ? Colors.yellow
                          : Colors.yellow[200],
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review['comment'],
              style: TextStyle(color: Colors.grey[700]),
            ),
            if (review['image'] != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  '${ApiService.baseUrl}/review/image/${review['image']}',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: Icon(Icons.error_outline, color: Colors.grey[400]),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
