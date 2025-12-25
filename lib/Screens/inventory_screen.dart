import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class InventoryScreen extends StatefulWidget {
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  List inventoryItems = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  // READ ITEMS
  Future<void> fetchItems() async {
    final data = await SupabaseService.client
        .from('inventory_items')
        .select()
        .order('item_name');

    setState(() {
      inventoryItems = data;
    });
  }

  // ADD ITEM
  Future<void> addItem() async {
    await SupabaseService.client.from('inventory_items').insert({
      'item_name': nameController.text.trim(),
      'category': categoryController.text.trim(),
      'quantity': int.parse(quantityController.text),
      'price': int.parse(priceController.text),
    });

    nameController.clear();
    categoryController.clear();
    quantityController.clear();
    priceController.clear();

    fetchItems(); // refresh list

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // INPUT FIELDS
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: addItem,
              child: const Text('Add Item'),
            ),

            const SizedBox(height: 30),

            // ITEM LIST
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: inventoryItems.length,
              itemBuilder: (context, index) {
                final item = inventoryItems[index];

                return Card(
                  child: ListTile(
                    title: Text(item['item_name']),
                    subtitle: Text(
                      'Category: ${item['category']} | Qty: ${item['quantity']} | Price: ${item['price']}',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
