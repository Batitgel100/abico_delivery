// ignore_for_file: library_private_types_in_public_api

import 'package:abico_delivery_start/constant/constant.dart';
import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const CustomPasswordField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.white,
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        obscureText: _obscureText,
        decoration: InputDecoration(
          fillColor: AppColors.mainColor,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.mainColor,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          labelText: widget.labelText,
          hintText: widget.hintText,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        obscureText: _obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.mainColor,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          fillColor: AppColors.mainColor,
          labelText: widget.labelText,
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
