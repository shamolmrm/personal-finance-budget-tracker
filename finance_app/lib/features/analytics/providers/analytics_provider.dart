import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/services/supabase_service.dart';
import '../../ai/services/claude_ai_service.dart';

List<String> _lastNMonths(int n) {
  final now = DateTime.now();
  final fmt = DateFormat.MMM();
  return List.generate(n, (i) {
    final d = DateTime(now.year, now.month - (n - 1 - i));
    return fmt.format(d);
  });
}

final monthlyIncomeExpenseProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final client = SupabaseService.instance.client;
  final months = _lastNMonths(6);
  if (client == null) {
    // sample data
    return List.generate(6, (i) => {'month': months[i], 'income': 1000.0 + i * 200, 'expense': 600.0 + i * 150});
  }

  // In production, query sums grouped by month for last 6 months
  // Here we provide a simplified RPC or query placeholder
  final out = <Map<String, dynamic>>[];
  for (var i = 0; i < 6; i++) {
    out.add({'month': months[i], 'income': 0.0, 'expense': 0.0});
  }
  return out;
});

final spendingByCategoryProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final client = SupabaseService.instance.client;
  if (client == null) {
    return [
      {'category': 'Food', 'amount': 420.0},
      {'category': 'Transport', 'amount': 180.0},
      {'category': 'Shopping', 'amount': 260.0},
      {'category': 'Utilities', 'amount': 95.0},
      {'category': 'Others', 'amount': 60.0},
    ];
  }
  // Placeholder: implement real query
  return [];
});

final netSavingsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final client = SupabaseService.instance.client;
  final months = _lastNMonths(12);
  if (client == null) {
    return List.generate(12, (i) => {'month': months[i], 'net': 200.0 + i * 50});
  }
  return List.generate(12, (i) => {'month': months[i], 'net': 0.0});
});

final aiAnalyticsInsightsProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final clientKey = const String.fromEnvironment('CLAUDE_API_KEY', defaultValue: '');
  if (clientKey.isEmpty) {
    return ['Your biggest expense is Food (35%).', 'You saved 12% more than last month.', 'Consider reducing subscriptions by \$15/month.'];
  }
  // Otherwise request concise insights (placeholder)
  return ClaudeAIService.instance.suggestCategory('generate three concise analytics insights for the user')
      .then((s) => [s]);
});
