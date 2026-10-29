import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/supabase_service.dart';
import '../models/transaction_model.dart';

final transactionNotifierProvider = Provider<TransactionService>((ref) => TransactionService());

class TransactionService {
  TransactionService();

  Future<void> addTransaction(TransactionModel t) async {
    final client = SupabaseService.instance.client;
    if (client == null) {
      // Store locally or simulate save
      return Future.delayed(const Duration(milliseconds: 300));
    }

    await client.from('transactions').insert({
      'id': t.id,
      'user_id': t.userId,
      'account_id': t.accountId,
      'category_id': t.categoryId,
      'amount': t.amount,
      'currency': t.currency,
      'type': t.type,
      'note': t.note,
      'merchant': t.merchant,
      'occurred_at': t.occurredAt.toUtc().toIso8601String(),
    }).execute();
  }
}
