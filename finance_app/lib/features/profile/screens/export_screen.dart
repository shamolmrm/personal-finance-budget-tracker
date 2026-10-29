import 'package:flutter/material.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export Data')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Export your financial data for backup or accounting', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            const Text('Export transactions, budgets, and goals in CSV format. The exported file will be saved to your device storage.'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export completed successfully.')));
              },
              icon: const Icon(Icons.download),
              label: const Text('Export as CSV'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share feature coming soon.')));
              },
              icon: const Icon(Icons.share),
              label: const Text('Share export file'),
            ),
          ],
        ),
      ),
    );
  }
}
