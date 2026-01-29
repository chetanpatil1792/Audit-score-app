import 'package:flutter/material.dart';
import '../../../core/constants/appcolors.dart';



// Compact Input Decoration
InputDecoration buildInputDecoration({String? hintText, bool isLabeled = false, String label = ''}) {
  return InputDecoration(
    labelText: isLabeled ? label : null,
    labelStyle: const TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 13, // Reduced font size
    ),
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.grey[400]),
    suffixIcon: const Icon(Icons.calendar_today, color: primaryColor, size: 18), // Reduced icon size
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), // Slightly smaller border radius
      borderSide: const BorderSide(color: borderColor, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: accentColor, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12), // Reduced padding
    floatingLabelBehavior: isLabeled ? FloatingLabelBehavior.auto : FloatingLabelBehavior.never,
  );
}

// Compact Dropdown Decoration
InputDecoration buildDropdownDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 13, // Reduced font size
    ),
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
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12), // Reduced padding
  );
}

// Common Container Decoration for tables
BoxDecoration buildTableDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(8), // Reduced border radius
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: primaryColor.withOpacity(0.08),
        spreadRadius: 1, // Reduced spread
        blurRadius: 5, // Reduced blur
        offset: const Offset(0, 3),
      ),
    ],
  );
}