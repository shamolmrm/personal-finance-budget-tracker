import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = const [
      {'name': 'Food', 'color': Color(0xFFFFA726)},
      {'name': 'Transport', 'color': Color(0xFF4FC3F7)},
      {'name': 'Shopping', 'color': Color(0xFFAB47BC)},
      {'name': 'Health', 'color': Color(0xFF66BB6A)},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Manage your spending categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemBuilder: (_, index) {
                  final item = categories[index];
                  return ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    tileColor: Theme.of(context).cardColor,
                    leading: CircleAvatar(backgroundColor: item['color'] as Color, child: const Icon(Icons.category, color: Colors.white)),
                    title: Text(item['name'] as String),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: categories.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
