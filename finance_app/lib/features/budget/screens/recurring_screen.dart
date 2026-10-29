import 'package:flutter/material.dart';

class RecurringScreen extends StatelessWidget {
  const RecurringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recurringItems = const [
      {'title': 'Netflix subscription', 'amount': 12.99, 'interval': 'Monthly'},
      {'title': 'Gym membership', 'amount': 25.00, 'interval': 'Monthly'},
      {'title': 'Savings transfer', 'amount': 100.00, 'interval': 'Weekly'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Recurring Payments')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: recurringItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = recurringItems[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                title: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(item['interval'] as String),
                trailing: Text('${(item['amount'] as double).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            );
          },
        ),
      ),
    );
  }
}
