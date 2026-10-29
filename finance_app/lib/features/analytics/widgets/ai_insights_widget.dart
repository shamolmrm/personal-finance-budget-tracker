import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/analytics_provider.dart';

class AiInsightsWidget extends ConsumerWidget {
  const AiInsightsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(aiAnalyticsInsightsProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: insights.when(
          data: (list) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: list.map((s) => Padding(padding: const EdgeInsets.symmetric(vertical:6), child: Text('• $s'))).toList()),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => const Text('Failed to generate insights'),
        ),
      ),
    );
  }
}
