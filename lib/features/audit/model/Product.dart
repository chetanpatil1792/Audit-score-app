// product_response.dart

import 'dart:convert';

// --- Individual Product Model ---
class Product {
  final int productId;
  final String productName;
  
  // State for the UI (not from the API response)
  bool selected; 

  Product({
    required this.productId,
    required this.productName,
    this.selected = false, // Initialize selected as false
  });

  // Factory constructor to create a Product from a JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'] as int,
      productName: json['productName'] as String,
      selected: false, // Default to unselected when loaded from API
    );
  }
}

// --- Main Response Model ---
class ProductResponse {
  final List<Product> result;

  ProductResponse({
    required this.result,
  });

  // Factory constructor to create the response model from the overall JSON map
  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    // Check if 'result' is present and is a List
    if (json['result'] is! List) {
      return ProductResponse(result: []); 
    }
    
    final List<dynamic> resultList = json['result'] as List<dynamic>;

    // Map each item in the list to a Product object
    final List<Product> products = resultList
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();

    return ProductResponse(
      result: products,
    );
  }
}