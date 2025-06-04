import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({super.key});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  int _selectedIndex = 0;
  final List<String> _categories = ['All', 'Makeup', 'Skincare', 'Haircare'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 50),
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = index),
              child: Column(
                children: [
                  Text(
                    _categories[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: _selectedIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  // const SizedBox(height: 4),
                  // if (_selectedIndex == index)
                  //   Container(
                  //     height: 2,
                  //     width: 20,
                  //     color: Colors.black,
                  //   ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
