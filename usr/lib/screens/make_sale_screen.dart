import 'package:flutter/material.dart';

class MakeSaleScreen extends StatelessWidget {
  const MakeSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Venta'),
      ),
      body: const Center(
        child: Text('Pantalla para registrar venta'),
      ),
    );
  }
}