import 'package:flutter/material.dart';

class InventoryItemTile extends StatelessWidget {
  final String name;
  final String category;
  final int quantity;
  final int price;
  final VoidCallback onDelete;

  const InventoryItemTile({
    super.key,
    required this.name,
    required this.category,
    required this.quantity,
    required this.price,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text(
          'Category: $category | Qty: $quantity | Price: $price',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
