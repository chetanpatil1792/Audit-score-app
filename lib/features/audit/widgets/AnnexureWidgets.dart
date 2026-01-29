import 'package:flutter/material.dart';
import '../../../core/constants/appcolors.dart';

BoxDecoration buildTableDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: primaryDarkBlue.withOpacity(0.08),
        spreadRadius: 1,
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ],
  );
}



Color getRiskColor(String? risk) {
  switch (risk?.toLowerCase()) {
    case 'high risk':
      return Colors.redAccent;
    case 'medium risk':
      return Colors.orangeAccent;
    case 'low risk':
      return Colors.green;
    default:
      return Colors.grey;
  }
}