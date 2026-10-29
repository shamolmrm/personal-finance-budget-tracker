class BudgetModel {
  final String id;
  final String userId;
  final String? categoryId;
  final double amount;
  final DateTime? startDate;
  final DateTime? endDate;
  final String interval;

  BudgetModel({required this.id, required this.userId, this.categoryId, required this.amount, this.startDate, this.endDate, this.interval = 'monthly'});

  factory BudgetModel.fromMap(Map<String, dynamic> m) {
    return BudgetModel(
      id: m['id'] as String,
      userId: m['user_id'] as String,
      categoryId: m['category_id'] as String?,
      amount: (m['amount'] as num).toDouble(),
      startDate: m['start_date'] == null ? null : DateTime.parse(m['start_date'] as String),
      endDate: m['end_date'] == null ? null : DateTime.parse(m['end_date'] as String),
      interval: m['interval'] as String? ?? 'monthly',
    );
  }
}
