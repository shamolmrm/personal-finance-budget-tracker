import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data; // {month, income, expense}
  const SimpleBarChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spots = <BarChartGroupData>[];
    for (var i = 0; i < data.length; i++) {
      final d = data[i];
      final income = (d['income'] as num?)?.toDouble() ?? 0;
      final expense = (d['expense'] as num?)?.toDouble() ?? 0;
      spots.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(toY: income, color: Colors.greenAccent, width: 8),
        BarChartRodData(toY: expense, color: Colors.redAccent, width: 8),
      ], showingTooltipIndicators: [0,1]));
    }

    return BarChart(BarChartData(
      barGroups: spots,
      titlesData: FlTitlesData(show: true, bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (val,meta){
        final idx = val.toInt(); if (idx<0 || idx>=data.length) return const SizedBox.shrink(); return Text(data[idx]['month']);
      }))),
      gridData: FlGridData(show: false),
    ));
  }
}
