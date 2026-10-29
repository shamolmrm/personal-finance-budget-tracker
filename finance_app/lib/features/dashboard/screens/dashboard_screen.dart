import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/widgets/balance_card.dart';
import '../../dashboard/widgets/ai_tip_card.dart';
import '../../dashboard/widgets/budget_alert_card.dart';
import '../../dashboard/widgets/transaction_item.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(recentTransactionsProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text('Good morning, User 👋', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const BalanceCard(),
              const SizedBox(height: 12),
              const AiTipCard(),
              const SizedBox(height: 12),
              const BudgetAlertCard(),
              const SizedBox(height: 16),
              const Text('Recent transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              transactionsAsync.when(
                data: (list) {
                  if (list.isEmpty) return const Center(child: Text('No recent transactions'));
                  return Column(children: list.map((t) => TransactionItem(transaction: t)).toList());
                },
                loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
                error: (e, st) => Center(child: Text('Failed to load transactions')),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {/* open add transaction sheet */}, child: const Icon(Icons.add)),
    );
  }
}
