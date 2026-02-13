import 'package:cyrpto_flow_app/data/models/price_history.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceChart extends StatelessWidget {
  const PriceChart({
    super.key,
    required this.history,
    this.loading = false,
    this.height = 200,
  });

  final List<PriceHistoryPoint> history;
  final bool loading;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SizedBox(
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (history.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'Veri yok',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    final prices = history.map((e) => double.tryParse(e.price) ?? 0.0).toList();
    final minY = prices.reduce((a, b) => a < b ? a : b);
    final maxY = prices.reduce((a, b) => a > b ? a : b);
    final span = maxY - minY;
    final minYPad = span * 0.1;
    final spots = List.generate(
      history.length,
      (i) => FlSpot(i.toDouble(), double.tryParse(history[i].price) ?? 0),
    );

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (history.length - 1).clamp(0, double.infinity).toDouble(),
            minY: (minY - minYPad).clamp(0, double.infinity),
            maxY: maxY + minYPad,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 2,
                belowBarData: BarAreaData(show: true, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
                dotData: const FlDotData(show: false),
              ),
            ],
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
          ),
          duration: const Duration(milliseconds: 200),
        ),
      ),
    );
  }
}
