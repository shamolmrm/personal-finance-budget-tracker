import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../../dashboard/providers/dashboard_provider.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tx = ref.watch(recentTransactionsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: tx.when(
        data: (list) => ListView.separated(
          itemBuilder: (_, i) {
            final t = list[i];
            return ListTile(title: Text(t.merchant ?? t.note ?? 'Transaction'), subtitle: Text(t.occurredAt.toIso8601String()), trailing: Text(t.amount.toString()));
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: list.length,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Failed to load: $e')),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SizedBox())), child: const Icon(Icons.add)),
    );
  }
}
