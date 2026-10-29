import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../providers/dashboard_provider.dart';
import 'package:shimmer/shimmer.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totals = ref.watch(totalsProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFEEF2FF), AppColors.primary]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: totals.when(
        data: (map) {
          final balance = map['balance'] ?? 0.0;
          final income = map['income'] ?? 0.0;
          final expense = map['expense'] ?? 0.0;
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Total balance', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(Formatters.currency(balance), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Income', style: TextStyle(color: Colors.white70)), Text(Formatters.currency(income, symbol: '\$'), style: const TextStyle(color: AppColors.income))]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Expense', style: TextStyle(color: Colors.white70)), Text(Formatters.currency(expense, symbol: '\$'), style: const TextStyle(color: AppColors.expense))]),
            ])
          ]);
        },
        loading: () => Shimmer.fromColors(
          baseColor: Colors.white24,
          highlightColor: Colors.white54,
          child: Container(height: 100, width: double.infinity, color: Colors.white24),
        ),
        error: (e, st) => Column(children: [Text('Failed to load totals', style: TextStyle(color: Colors.white)),]),
      ),
    );
  }
}
