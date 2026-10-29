import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/analytics_provider.dart';
import '../widgets/pie_chart_widget.dart';

class SpendingBreakdownScreen extends ConsumerWidget {
  const SpendingBreakdownScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spendingAsync = ref.watch(spendingByCategoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Spending Breakdown')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This month', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            spendingAsync.when(
              data: (data) {
                if (data.isEmpty) {
                  return const Center(child: Text('No spending data available.'));
                }
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(child: SimplePieChart(data: data)),
                      const SizedBox(height: 16),
                      ...data.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item['category'] ?? 'Unknown', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              Text('${(item['amount'] as num?)?.toStringAsFixed(2) ?? '0.00'}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Expanded(child: Center(child: CircularProgressIndicator())),
              error: (error, _) => Expanded(child: Center(child: Text('Unable to load spending breakdown.'))),
            ),
          ],
        ),
      ),
    );
  }
}
