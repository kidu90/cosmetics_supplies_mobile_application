import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  final String title;

  const ProfileMenu({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
