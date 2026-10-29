import 'package:flutter/material.dart';
import '../../goals/models/goal_model.dart';
import '../../../core/utils/formatters.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final VoidCallback? onAddMoney;
  const GoalCard({Key? key, required this.goal, this.onAddMoney}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percent = goal.progress;
    final progressColor = percent < 0.25 ? Colors.red : percent < 0.5 ? Colors.orange : percent < 0.75 ? Colors.amber : Colors.green;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Text(goal.icon, style: const TextStyle(fontSize: 28)), const SizedBox(width: 12), Expanded(child: Text(goal.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600))), Text('${(percent * 100).toStringAsFixed(0)}%', style: TextStyle(color: progressColor, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 12),
          Text('Saved: ${Formatters.currency(goal.savedAmount)} / ${Formatters.currency(goal.targetAmount)}', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          Stack(children: [
            Container(height: 10, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10))),
            FractionallySizedBox(widthFactor: percent, child: Container(height: 10, decoration: BoxDecoration(color: progressColor, borderRadius: BorderRadius.circular(10))))
          ]),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(goal.deadline != null ? '${goal.deadline!.difference(DateTime.now()).inDays} days left' : 'No deadline', style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ElevatedButton(onPressed: onAddMoney, child: const Text('Add money'))
          ])
        ]),
      ),
    );
  }
}
