import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:couldai_user_app/models/product.dart';

class InventoryProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getStringList('products') ?? [];
    _products = productsJson.map((json) => Product.fromJson(jsonDecode(json))).toList();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    _products.add(product);
    await _saveProducts();
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _products[index] = updatedProduct;
      await _saveProducts();
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
    await _saveProducts();
    notifyListeners();
  }

  Future<void> updateStock(String id, int newStock) async {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _products[index] = _products[index].copyWith(stock: newStock);
      await _saveProducts();
      notifyListeners();
    }
  }

  Future<void> _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = _products.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList('products', productsJson);
  }
}