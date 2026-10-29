import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/analytics_provider.dart';
import '../widgets/bar_chart_widget.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/line_chart_widget.dart';
import '../widgets/ai_insights_widget.dart';
import '../../ai/screens/smart_insights_screen.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int _periodIndex = 1; // 0: Week,1:Month,2:Year

  @override
  Widget build(BuildContext context) {
    final monthly = ref.watch(monthlyIncomeExpenseProvider);
    final byCat = ref.watch(spendingByCategoryProvider);
    final net = ref.watch(netSavingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.insights),
            tooltip: 'Smart Insights',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SmartInsightsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleButtons(
              children: const [Text('Week'), Text('Month'), Text('Year')],
              isSelected: List.generate(3, (i) => i == _periodIndex),
              onPressed: (i) => setState(() => _periodIndex = i),
            ),
            const SizedBox(height: 12),
            const Text(
              'Monthly Income vs Expense',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            monthly.when(
              data: (d) => SimpleBarChart(data: d),
              loading: () => const SizedBox(
                height: 140,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, st) => const Text('Failed'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Spending by Category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            byCat.when(
              data: (d) => SimplePieChart(data: d),
              loading: () => const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, st) => const Text('Failed'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Net Savings Trend',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            net.when(
              data: (d) => SimpleLineChart(data: d),
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, st) => const Text('Failed'),
            ),
            const SizedBox(height: 16),
            const Text(
              'AI Insights',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const AiInsightsWidget(),
            const SizedBox(height: 16),
            const Text(
              'Top 5 Categories',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            byCat.when(
              data: (list) => Column(
                children: list
                    .take(5)
                    .map(
                      (c) => ListTile(
                        title: Text(c['category']),
                        trailing: Text(c['amount'].toString()),
                      ),
                    )
                    .toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
