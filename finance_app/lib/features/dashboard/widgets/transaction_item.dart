import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';
import '../../transactions/models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel? transaction;
  const TransactionItem({Key? key, this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transaction == null) {
      return const SizedBox.shrink();
    }

    final isExpense = transaction!.type == 'expense';
    return ListTile(
      leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primary, child: const Icon(Icons.receipt_long)),
      title: Text(transaction!.merchant ?? transaction!.note ?? 'Transaction'),
      subtitle: Text(Formatters.dateShort(transaction!.occurredAt)),
      trailing: Text((isExpense ? '-' : '+') + Formatters.currency(transaction!.amount)),
    );
  }
}
