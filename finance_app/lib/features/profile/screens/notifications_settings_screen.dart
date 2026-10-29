import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';

class NotificationsSettingsScreen extends ConsumerWidget {
  const NotificationsSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Push reminders'),
              subtitle: const Text('Receive daily expense reminders and goal updates'),
              value: profile.notificationsEnabled,
              onChanged: ref.read(profileNotifierProvider.notifier).toggleNotifications,
            ),
            SwitchListTile(
              title: const Text('Weekly summary'),
              subtitle: const Text('Get a weekly summary of your spending'),
              value: profile.weeklySummaryEnabled,
              onChanged: ref.read(profileNotifierProvider.notifier).toggleWeeklySummary,
            ),
          ],
        ),
      ),
    );
  }
}
