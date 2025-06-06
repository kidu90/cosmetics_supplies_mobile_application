import 'package:flutter/material.dart';
import 'package:cosmetic_supplies_application/services/api_service.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({super.key});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  int _selectedIndex = 0;
  late Future<List<dynamic>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = ApiService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: FutureBuilder<List<dynamic>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found'));
          } else {
            final categories = [
              'All',
              ...snapshot.data!.map((c) => c['name'].toString()).toList()
            ];

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: Column(
                      children: [
                        Text(
                          categories[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: _selectedIndex == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        if (_selectedIndex == index)
                          Container(
                            height: 2,
                            width: 20,
                            color: Colors.black,
                            margin: const EdgeInsets.only(top: 4),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
