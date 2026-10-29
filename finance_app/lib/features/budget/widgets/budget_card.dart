import 'package:flutter/material.dart';
import '../../budget/models/budget_model.dart';
import '../../../core/utils/formatters.dart';

class BudgetCard extends StatelessWidget {
  final BudgetModel budget;
  final double used;
  const BudgetCard({Key? key, required this.budget, required this.used}) : super(key: key);

  Color _colorForPercent(double p) {
    if (p < 0.5) return Colors.green;
    if (p < 0.8) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final percent = (used / budget.amount).clamp(0.0, 1.0);
    final color = _colorForPercent(percent);
    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(budget.categoryId ?? 'Category', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text('${Formatters.currency(used)} / ${Formatters.currency(budget.amount)}', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: percent, color: color, backgroundColor: color.withOpacity(0.2)),
        const SizedBox(height: 8),
        Text('${((percent) * 100).toStringAsFixed(0)}% used', style: TextStyle(color: color)),
      ]),
    );
  }
}
