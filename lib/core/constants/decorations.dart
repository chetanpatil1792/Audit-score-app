import 'package:flutter/material.dart';

import 'appcolors.dart';

InputDecoration buildDropdownDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(
        color: primaryColor, fontWeight: FontWeight.w600, fontSize: 13),
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: borderColor, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: accentColor, width: 2),
    ),
    contentPadding:
    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
  );
}

BoxDecoration buildTableDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: primaryColor.withOpacity(0.08),
        spreadRadius: 1,
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ],
  );
}