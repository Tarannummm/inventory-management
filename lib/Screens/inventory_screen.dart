import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../reusable_widgets/inventory_item_tile.dart';
import 'profile_screen.dart';

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

  // READ
  Future<void> fetchItems() async {
    final data = await SupabaseService.client
        .from('inventory_items')
        .select()
        .order('item_name');

    setState(() {
      inventoryItems = data;
    });
  }

  // CREATE
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

    fetchItems();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added successfully')),
    );
  }

  // DELETE ✅ (THIS MUST BE HERE)
  Future<void> deleteItem(String id) async {
    await SupabaseService.client.from('inventory_items').delete().eq('id', id);

    fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: inventoryItems.length,
              itemBuilder: (context, index) {
                final item = inventoryItems[index];

                return InventoryItemTile(
                  name: item['item_name'],
                  category: item['category'],
                  quantity: item['quantity'],
                  price: item['price'],
                  onDelete: () => deleteItem(item['id'].toString()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
