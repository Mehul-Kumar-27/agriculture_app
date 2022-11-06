// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key? key,
    required this.controller,
    required this.iconData,
    required this.hintText,
    required this.isObscure,
    required this.enabled,
  }) : super(key: key);

  final TextEditingController controller;
  final IconData iconData;
  final String hintText;
  final bool isObscure;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[600],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.blue)),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      child: TextFormField(
        enabled: enabled,
        obscureText: isObscure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              iconData,
              color: Colors.white,
            ),
            focusColor: Theme.of(context).primaryColor,
            hintText: hintText,
            hintStyle: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
