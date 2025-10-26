import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couldai_user_app/providers/sales_provider.dart';
import 'package:couldai_user_app/providers/inventory_provider.dart';
import 'package:couldai_user_app/models/sale.dart';
import 'package:uuid/uuid.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final salesProvider = context.watch<SalesProvider>();
    final inventoryProvider = context.watch<InventoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddSaleDialog(context, inventoryProvider.products),
          ),
        ],
      ),
      body: salesProvider.sales.isEmpty
          ? const Center(child: Text('No hay ventas registradas.'))
          : ListView.builder(
              itemCount: salesProvider.sales.length,
              itemBuilder: (context, index) {
                final sale = salesProvider.sales[index];
                return ListTile(
                  title: Text('${sale.product.name} (x${sale.quantity})'),
                  subtitle: Text('Fecha: ${sale.date.toString().split(' ')[0]}'),
                  trailing: Text('\$${sale.totalPrice.toStringAsFixed(2)}'),
                );
              },
            ),
    );
  }

  void _showAddSaleDialog(BuildContext context, List products) {
    String? selectedProductId;
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar Venta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedProductId,
              hint: const Text('Seleccionar Producto'),
              items: products.map((product) {
                return DropdownMenuItem<String>(
                  value: product.id,
                  child: Text('${product.name} - Stock: ${product.stock}'),
                );
              }).toList(),
              onChanged: (value) {
                selectedProductId = value;
              },
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final quantity = int.tryParse(quantityController.text) ?? 0;
              if (selectedProductId != null && quantity > 0) {
                final product = products.firstWhere((p) => p.id == selectedProductId);
                if (product.stock >= quantity) {
                  final totalPrice = product.price * quantity;
                  final uuid = Uuid();
                  final sale = Sale(
                    id: uuid.v4(),
                    product: product,
                    quantity: quantity,
                    totalPrice: totalPrice,
                    date: DateTime.now(),
                  );
                  await context.read<SalesProvider>().addSale(sale);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Stock insuficiente')),
                  );
                }
              }
            },
            child: const Text('Registrar'),
          ),
        ],
      ),
    );
  }
}