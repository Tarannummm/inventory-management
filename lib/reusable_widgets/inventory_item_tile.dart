import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

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
      color: AppColors.card,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.accent),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: AppColors.danger),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.category_outlined,
                    size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text('Category: $category'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined,
                    size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Quantity: $quantity',
                  style: TextStyle(
                    color: lowStock ? AppColors.danger : Colors.black87,
                    fontWeight: lowStock ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text('Price: ৳$price'),
              ],
            ),
            if (lowStock) ...[
              const SizedBox(height: 8),
              const Text(
                '⚠ Low stock! Please restock soon.',
                style: TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
