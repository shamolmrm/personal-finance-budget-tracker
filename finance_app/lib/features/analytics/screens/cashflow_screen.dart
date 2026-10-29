import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/analytics_provider.dart';
import '../widgets/line_chart_widget.dart';

class CashflowScreen extends ConsumerWidget {
  const CashflowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final netAsync = ref.watch(netSavingsProvider);
    final monthlyAsync = ref.watch(monthlyIncomeExpenseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cashflow')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cashflow snapshot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            monthlyAsync.when(
              data: (data) {
                final income = data.fold<double>(0, (sum, item) => sum + ((item['income'] as num?)?.toDouble() ?? 0));
                final expense = data.fold<double>(0, (sum, item) => sum + ((item['expense'] as num?)?.toDouble() ?? 0));
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _summaryTile('Income', income, Theme.of(context).colorScheme.secondary),
                        _summaryTile('Expense', expense, Theme.of(context).colorScheme.error),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => const Text('Unable to load cashflow metrics.'),
            ),
            const SizedBox(height: 20),
            const Text('Net savings trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Expanded(
              child: netAsync.when(
                data: (data) => SimpleLineChart(data: data),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => const Center(child: Text('Unable to load savings trend.')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryTile(String label, double amount, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),
          Text('${amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}
