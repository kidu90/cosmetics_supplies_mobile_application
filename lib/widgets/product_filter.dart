import 'package:flutter/material.dart';
import 'package:cosmetic_supplies_application/services/api_service.dart';

class ProductFilter extends StatefulWidget {
  final Function(int id) onCategorySelected;
  final VoidCallback onClear;

  const ProductFilter({
    super.key,
    required this.onCategorySelected,
    required this.onClear,
  });

  @override
  State<ProductFilter> createState() => _ProductFilterState();
}

class _ProductFilterState extends State<ProductFilter> {
  List<dynamic> _categories = [];
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ApiService.fetchCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: $e')),
      );
    }
  }

  void _onCategorySelected(int? id) {
    if (id != null) {
      widget.onCategorySelected(id);
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedCategoryId = null;
    });
    widget.onClear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 340,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: "Select Category",
                border: OutlineInputBorder(),
              ),
              value: _selectedCategoryId,
              items: _categories.map<DropdownMenuItem<int>>((category) {
                return DropdownMenuItem<int>(
                  value: category['id'],
                  child: Text(category['name']),
                );
              }).toList(),
              onChanged: (id) {
                setState(() {
                  _selectedCategoryId = id;
                });
                _onCategorySelected(id);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _clearFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Clear Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
