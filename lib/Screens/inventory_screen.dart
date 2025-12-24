import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: const Center(
        child: Text(
          'Inventory Screen Working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
