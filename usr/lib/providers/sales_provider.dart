import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:couldai_user_app/models/sale.dart';
import 'package:couldai_user_app/models/product.dart';
import 'package:couldai_user_app/providers/inventory_provider.dart';

class SalesProvider with ChangeNotifier {
  List<Sale> _sales = [];
  final InventoryProvider _inventoryProvider;

  SalesProvider(this._inventoryProvider);

  List<Sale> get sales => _sales;

  Future<void> loadSales() async {
    final prefs = await SharedPreferences.getInstance();
    final salesJson = prefs.getStringList('sales') ?? [];
    _sales = [];
    for (final json in salesJson) {
      final saleData = jsonDecode(json);
      final productId = saleData['productId'];
      final product = _inventoryProvider.products.firstWhere((p) => p.id == productId, orElse: () => null);
      if (product != null) {
        _sales.add(Sale.fromJson(saleData, product));
      }
    }
    notifyListeners();
  }

  Future<void> addSale(Sale sale) async {
    _sales.add(sale);
    await _inventoryProvider.updateStock(sale.product.id, sale.product.stock - sale.quantity);
    await _saveSales();
    notifyListeners();
  }

  Future<void> _saveSales() async {
    final prefs = await SharedPreferences.getInstance();
    final salesJson = _sales.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList('sales', salesJson);
  }

  List<Sale> getSalesByDate(DateTime date) {
    return _sales.where((sale) => 
      sale.date.year == date.year && 
      sale.date.month == date.month && 
      sale.date.day == date.day
    ).toList();
  }

  double getTotalSalesByDate(DateTime date) {
    final dailySales = getSalesByDate(date);
    return dailySales.fold(0, (sum, sale) => sum + sale.totalPrice);
  }
}