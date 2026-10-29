import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/supabase_service.dart';
import '../../ai/services/claude_ai_service.dart';
import '../models/goal_model.dart';

final goalsProvider = FutureProvider.autoDispose<List<GoalModel>>((ref) async {
  final client = SupabaseService.instance.client;
  if (client == null) {
    return [
      GoalModel(id: 'g1', userId: 'me', title: 'Emergency Fund', targetAmount: 1200, savedAmount: 450, deadline: DateTime.now().add(const Duration(days: 45)), icon: '🏦', color: '#10B981'),
      GoalModel(id: 'g2', userId: 'me', title: 'New Laptop', targetAmount: 1800, savedAmount: 900, deadline: DateTime.now().add(const Duration(days: 120)), icon: '💻', color: '#F59E0B'),
      GoalModel(id: 'g3', userId: 'me', title: 'Vacation', targetAmount: 1500, savedAmount: 300, deadline: DateTime.now().add(const Duration(days: 210)), icon: '✈️', color: '#4F46E5'),
    ];
  }
  final res = await client.from('goals').select().order('created_at', ascending: false).execute();
  if (res.data == null) return [];
  return (res.data as List).map((item) => GoalModel.fromMap(Map<String, dynamic>.from(item))).toList();
});

final aiGoalSuggestionProvider = FutureProvider.autoDispose<String>((ref) async {
  final suggestion = await ClaudeAIService.instance.suggestCategory('Calculate a monthly savings target to reach a user\'s goal on time.');
  return suggestion;
});
