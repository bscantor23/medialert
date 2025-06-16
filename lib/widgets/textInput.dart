import 'package:flutter/material.dart';

TextFormField buildInputText(
  String searchPlaceholder,
  Future<void> Function(String) onChanged,
) {
  return TextFormField(
    onChanged: (value) {
      if (value.isNotEmpty) {
        onChanged(value);
      } else {
        onChanged('');
      }
    },
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      hintText: searchPlaceholder,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      labelStyle: TextStyle(color: Colors.black, fontSize: 15),
      hintStyle: TextStyle(color: Colors.black, fontSize: 15),
      prefixIcon: Icon(Icons.search, color: Colors.black),
    ),
    style: const TextStyle(color: Color.fromRGBO(7, 170, 151, 1), fontSize: 15),
  );
}
