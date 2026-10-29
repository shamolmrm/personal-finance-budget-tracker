import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SimplePieChart extends StatelessWidget {
  final List<Map<String, dynamic>> data; // {category, amount}
  const SimplePieChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = data.fold<double>(0, (p, e) => p + ((e['amount'] as num?)?.toDouble() ?? 0));
    return SizedBox(
      height: 220,
      child: PieChart(PieChartData(
        sections: data.asMap().entries.map((entry) {
          final idx = entry.key;
          final d = entry.value;
          final value = (d['amount'] as num?)?.toDouble() ?? 0;
          final percent = total == 0 ? 0 : (value / total) * 100;
          final color = Colors.primaries[idx % Colors.primaries.length];
          return PieChartSectionData(color: color, value: value, title: '${percent.toStringAsFixed(0)}%', radius: 48);
        }).toList(),
      )),
    );
  }
}
