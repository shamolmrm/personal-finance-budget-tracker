class TransactionModel {
  final String id;
  final String userId;
  final String? accountId;
  final String? categoryId;
  final double amount;
  final String currency;
  final String type; // 'income' | 'expense'
  final String? note;
  final String? merchant;
  final DateTime occurredAt;

  TransactionModel({required this.id, required this.userId, this.accountId, this.categoryId, required this.amount, required this.currency, required this.type, this.note, this.merchant, required this.occurredAt});

  factory TransactionModel.fromMap(Map<String, dynamic> m) {
    return TransactionModel(
      id: m['id'] as String,
      userId: m['user_id'] as String,
      accountId: m['account_id'] as String?,
      categoryId: m['category_id'] as String?,
      amount: (m['amount'] as num).toDouble(),
      currency: (m['currency'] as String?) ?? 'USD',
      type: m['type'] as String? ?? 'expense',
      note: m['note'] as String?,
      merchant: m['merchant'] as String?,
      occurredAt: DateTime.parse(m['occurred_at'] as String),
    );
  }
}
