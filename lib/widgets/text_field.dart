import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller; // Added controller

  const CustomTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller, // Required controller
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller, // Assign controller to TextFormField
          decoration: InputDecoration(
            hintText: placeholder,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          obscureText: obscureText,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
