import 'package:flutter/material.dart';

class DebtTrackerScreen extends StatelessWidget {
  const DebtTrackerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final debts = const [
      {
        'name': 'Credit card',
        'balance': 820.50,
        'rate': 19.99,
        'progress': 0.35
      },
      {
        'name': 'Student loan',
        'balance': 4210.00,
        'rate': 4.25,
        'progress': 0.55
      },
      {'name': 'Car loan', 'balance': 15600.00, 'rate': 6.20, 'progress': 0.20},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Debt Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: debts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final debt = debts[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(debt['name'] as String,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        Text(
                            '\$${(debt['balance'] as double).toStringAsFixed(2)}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Interest ${debt['rate']}%',
                        style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                        value: debt['progress'] as double, minHeight: 10),
                    const SizedBox(height: 8),
                    Text(
                        '${((debt['progress'] as double) * 100).round()}% paid',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
