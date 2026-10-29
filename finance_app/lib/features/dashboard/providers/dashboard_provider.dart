import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/supabase_service.dart';
import '../../transactions/models/transaction_model.dart';

/// StreamProvider that emits the most recent transactions for the current user.
final recentTransactionsProvider = StreamProvider.autoDispose<List<TransactionModel>>((ref) {
  final client = SupabaseService.instance.client;

  if (client == null) {
    // Fallback sample stream for dev when Supabase is not configured.
    final sample = List.generate(
      5,
      (i) => TransactionModel(id: 'tmp_$i', userId: 'me', amount: 20.0 + i, currency: 'USD', type: i.isEven ? 'expense' : 'income', occurredAt: DateTime.now().subtract(Duration(days: i))),
    );
    return Stream<List<TransactionModel>>.value(sample);
  }

  // Use Supabase realtime stream if available. The .stream API returns a Stream<List<Map>>.
  final stream = client.from('transactions').stream(primaryKey: ['id']).order('occurred_at', ascending: false).limit(5).execute();

  // Map raw records to TransactionModel
  return stream.map((rows) => rows.map<TransactionModel>((r) => TransactionModel.fromMap(r)).toList());
});

/// FutureProvider for aggregated totals (balance, income, expense)
final totalsProvider = FutureProvider.autoDispose<Map<String, double>>((ref) async {
  final client = SupabaseService.instance.client;
  if (client == null) {
    return {'balance': 1234.56, 'income': 2345.0, 'expense': 1110.44};
  }

  // Fetch recent 6 months sums for income/expense and compute balance
  final incomeRes = await client.rpc('sum_transactions_by_type', params: {'_type': 'income'}).maybeSingle();
  final expenseRes = await client.rpc('sum_transactions_by_type', params: {'_type': 'expense'}).maybeSingle();

  double income = 0, expense = 0;
  try {
    income = (incomeRes?['sum'] as num?)?.toDouble() ?? 0;
  } catch (_) {}
  try {
    expense = (expenseRes?['sum'] as num?)?.toDouble() ?? 0;
  } catch (_) {}

  return {'balance': income - expense, 'income': income, 'expense': expense};
});
