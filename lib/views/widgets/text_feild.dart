import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final Widget? suffixIcon;
  final String image;
  final String hintText;
  final String? Function(String?) validator;
  // final String? Function(String?) onSaved;
  bool obscureText;

  TextFieldWidget({
    super.key,
    required this.controller,
    this.suffixIcon,
    required this.image,
    required this.hintText,
    required this.validator,
    this.obscureText = false,
    // required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // onSaved: onSaved,
      obscureText: obscureText,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "images/$image.png",
            width: 30,
            height: 30,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xff9747FF),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xff471AA0),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
