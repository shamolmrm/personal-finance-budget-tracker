class GoalModel {
  final String id;
  final String userId;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime? deadline;
  final String icon;
  final String color;
  final bool isCompleted;

  GoalModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    this.deadline,
    this.icon = '🎯',
    this.color = '#4F46E5',
    this.isCompleted = false,
  });

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      targetAmount: (map['target_amount'] as num).toDouble(),
      savedAmount: (map['saved_amount'] as num).toDouble(),
      deadline: map['deadline'] == null ? null : DateTime.parse(map['deadline'] as String),
      icon: map['icon'] as String? ?? '🎯',
      color: map['color'] as String? ?? '#4F46E5',
      isCompleted: map['is_completed'] as bool? ?? false,
    );
  }

  double get progress => targetAmount == 0 ? 0 : (savedAmount / targetAmount).clamp(0, 1);
}
