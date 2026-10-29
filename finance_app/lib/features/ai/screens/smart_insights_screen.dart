import 'package:flutter/material.dart';

class SmartInsightsScreen extends StatelessWidget {
  const SmartInsightsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cards = [
      {
        'title': 'Spending Alert',
        'body': 'Your food budget is trending 18% above target this month.',
      },
      {
        'title': 'Savings Opportunity',
        'body':
            'You can save an extra \$120 by reducing subscription expenses.',
      },
      {
        'title': 'Goal Progress',
        'body': 'You are 25% closer to your emergency fund goal.',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Smart Insights')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card['title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(card['body']!),
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
