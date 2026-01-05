import 'package:flutter/material.dart';

class InventoryItemTile extends StatelessWidget {
  final String name;
  final String category;
  final int quantity;
  final int price;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const InventoryItemTile({
    super.key,
    required this.name,
    required this.category,
    required this.quantity,
    required this.price,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final bool lowStock = quantity <= 5;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: $category'),
            Text('Quantity: $quantity'),
            Text('Price: ৳$price'),
            if (lowStock)
              const Text(
                '⚠ Low Stock',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
