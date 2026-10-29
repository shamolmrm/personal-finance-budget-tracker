import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/supabase_service.dart';
import '../models/budget_model.dart';

final budgetsProvider = FutureProvider.autoDispose<List<BudgetModel>>((ref) async {
  final client = SupabaseService.instance.client;
  if (client == null) {
    // Sample budgets
    return [
      BudgetModel(id: 'b1', userId: 'me', categoryId: 'food', amount: 300),
      BudgetModel(id: 'b2', userId: 'me', categoryId: 'transport', amount: 120),
      BudgetModel(id: 'b3', userId: 'me', categoryId: 'shopping', amount: 200),
    ];
  }

  final res = await client.from('budgets').select().order('created_at', ascending: false).execute();
  if (res.data == null) return [];
  final list = (res.data as List).map((m) => BudgetModel.fromMap(Map<String, dynamic>.from(m))).toList();
  return list;
});

/// Compute current spent per budget (placeholder: use transactions sums in real app)
final budgetUsageProvider = FutureProvider.autoDispose<Map<String, double>>((ref) async {
  final budgets = await ref.watch(budgetsProvider.future);
  final Map<String, double> map = {};
  for (var b in budgets) {
    // simulate usage
    map[b.id] = (b.amount * (0.3 + (b.id.hashCode % 60) / 100));
  }
  return map;
});

final aiBudgetSuggestionProvider = FutureProvider.autoDispose<Map<String, double>>((ref) async {
  // Placeholder: call Claude to suggest budgets; return map category->suggested amount
  return {'food': 280.0, 'transport': 100.0, 'shopping': 180.0};
});
