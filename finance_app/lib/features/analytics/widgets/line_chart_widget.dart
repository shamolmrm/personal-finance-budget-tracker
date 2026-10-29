import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> data; // {month, net}
  const SimpleLineChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    for (var i = 0; i < data.length; i++) {
      final n = (data[i]['net'] as num?)?.toDouble() ?? 0;
      spots.add(FlSpot(i.toDouble(), n));
    }

    return SizedBox(
      height: 200,
      child: LineChart(LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: Theme.of(context).colorScheme.primary,
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
        ],
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, meta) {
                final idx = v.toInt();
                if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
                return Text(data[idx]['month']);
              },
            ),
          ),
        ),
      )),
    );
  }
}
