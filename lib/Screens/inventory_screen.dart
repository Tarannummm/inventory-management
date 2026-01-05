import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../reusable_widgets/inventory_item_tile.dart';
import 'profile_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  List inventoryItems = [];
  List filteredItems = []; // 🔍 for search

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
      filteredItems = data; // important for search
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

    clearFields();
    fetchItems();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added successfully')),
    );
  }

  // DELETE
  Future<void> deleteItem(String id) async {
    await SupabaseService.client.from('inventory_items').delete().eq('id', id);
    fetchItems();
  }

  // UPDATE
  Future<void> updateItem(String id) async {
    await SupabaseService.client.from('inventory_items').update({
      'item_name': nameController.text.trim(),
      'category': categoryController.text.trim(),
      'quantity': int.parse(quantityController.text),
      'price': int.parse(priceController.text),
    }).eq('id', id);

    clearFields();
    fetchItems();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item updated successfully')),
    );
  }

  void clearFields() {
    nameController.clear();
    categoryController.clear();
    quantityController.clear();
    priceController.clear();
  }

  // EDIT DIALOG
  void showEditDialog(Map item) {
    nameController.text = item['item_name'];
    categoryController.text = item['category'];
    quantityController.text = item['quantity'].toString();
    priceController.text = item['price'].toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                updateItem(item['id'].toString());
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
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
            // 🔍 SEARCH BAR
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search Item',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  filteredItems = inventoryItems
                      .where((item) => item['item_name']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
            const SizedBox(height: 20),

            // ADD ITEM FIELDS
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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addItem,
              child: const Text('Add Item'),
            ),
            const SizedBox(height: 30),

            // INVENTORY LIST
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return InventoryItemTile(
                  name: item['item_name'],
                  category: item['category'],
                  quantity: item['quantity'],
                  price: item['price'],
                  onDelete: () => deleteItem(item['id'].toString()),
                  onEdit: () => showEditDialog(item),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
