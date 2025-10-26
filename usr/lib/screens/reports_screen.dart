import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couldai_user_app/providers/sales_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final salesProvider = context.watch<SalesProvider>();
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final lastWeek = today.subtract(const Duration(days: 7));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informes de Ventas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informe Diario',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ventas de Hoy (${today.toString().split(' ')[0]})',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text('Número de ventas: ${salesProvider.getSalesByDate(today).length}'),
                    Text('Total: \$${salesProvider.getTotalSalesByDate(today).toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Resumen Adicional',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ventas de Ayer: ${salesProvider.getSalesByDate(yesterday).length} - Total: \$${salesProvider.getTotalSalesByDate(yesterday).toStringAsFixed(2)}'),
                    const SizedBox(height: 5),
                    Text('Ventas de la Semana: ${salesProvider.sales.where((sale) => sale.date.isAfter(lastWeek)).length} - Total: \$${salesProvider.sales.where((sale) => sale.date.isAfter(lastWeek)).fold(0.0, (sum, sale) => sum + sale.totalPrice).toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}