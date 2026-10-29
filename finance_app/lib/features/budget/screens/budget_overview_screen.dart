import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/budget_model.dart';
import '../providers/budget_provider.dart';
import '../widgets/budget_card.dart';
import 'create_budget_screen.dart';

class BudgetOverviewScreen extends ConsumerWidget {
  const BudgetOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetsProvider);
    final usageAsync = ref.watch(budgetUsageProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Total budget vs spent', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          // Top summary (simple)
          Row(children: const [Expanded(child: Card(child: Padding(padding: EdgeInsets.all(12), child: Text('Total Budget\n\$600 / \$1200'))))]),
          const SizedBox(height: 12),
          const Text('Per-category budgets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          budgetsAsync.when(
            data: (list) {
              return SizedBox(
                height: 160,
                child: usageAsync.when(
                  data: (usage) => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) => BudgetCard(budget: list[i], used: usage[list[i].id] ?? 0),
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemCount: list.length,
                  ),
                  loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
                  error: (e, st) => const Text('Failed to load usage'),
                ),
              );
            },
            loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
            error: (e, st) => const Text('Failed to load budgets'),
          ),
          const SizedBox(height: 12),
          Row(children: [
            ElevatedButton.icon(onPressed: () async {
              final suggestions = await ref.read(aiBudgetSuggestionProvider.future);
              showDialog(context: context, builder: (_) => AlertDialog(title: const Text('AI Budget Suggestions'), content: Column(mainAxisSize: MainAxisSize.min, children: suggestions.entries.map((e) => ListTile(title: Text(e.key), trailing: Text('\$${e.value.toStringAsFixed(0)}'))).toList()), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))]));
            }, icon: const Icon(Icons.smart_toy), label: const Text('AI Budget Suggest')),
            const SizedBox(width: 12),
            ElevatedButton.icon(onPressed: () async {
              final res = await Navigator.of(context).push<BudgetModel>(MaterialPageRoute(builder: (_) => const CreateBudgetScreen()));
              if (res != null) {
                // refresh provider or insert
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Budget created')));
              }
            }, icon: const Icon(Icons.add), label: const Text('Add Budget'))
          ])
        ]),
      ),
    );
  }
}
