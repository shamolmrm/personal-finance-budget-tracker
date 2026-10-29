import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/screens/login_screen.dart';
import '../providers/profile_provider.dart';
import 'categories_screen.dart';
import 'edit_profile_screen.dart';
import 'export_screen.dart';
import 'notifications_settings_screen.dart';
import 'premium_screen.dart';
import 'security_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              CircleAvatar(radius: 30, backgroundColor: Theme.of(context).colorScheme.primary, child: Text(profile.fullName.substring(0, 1), style: const TextStyle(color: Colors.white, fontSize: 24))),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(profile.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(profile.email, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text('Currency: ${profile.currency}', style: const TextStyle(color: Colors.grey)),
                ]),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        _menuCard(context, Icons.edit, 'Edit Profile', 'Update your name, email and currency', () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditProfileScreen()))),
        _menuCard(context, Icons.notifications, 'Notifications', 'Manage reminders and alerts', () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsSettingsScreen()))),
        _menuCard(context, Icons.category, 'Categories', 'Create and manage spending categories', () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CategoriesScreen()))),
        _menuCard(context, Icons.lock, 'Security', 'Protect your account with biometrics', () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SecurityScreen()))),
        _menuCard(context, Icons.cloud_upload, 'Export Data', 'Export transactions and budgets', () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ExportScreen()))),
        const SizedBox(height: 12),
        const Text('Premium', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PremiumScreen())),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.workspace_premium, color: Colors.white)),
              const SizedBox(width: 16),
              const Expanded(child: Text('Upgrade to Premium for AI chat, receipt scanner and unlimited budgets.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
              const Icon(Icons.arrow_forward_ios, size: 16)
            ]),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen())), icon: const Icon(Icons.logout), label: const Text('Logout')),
      ]),
    );
  }

  Widget _menuCard(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        tileColor: Theme.of(context).cardColor,
        leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.14), child: Icon(icon, color: Theme.of(context).colorScheme.primary)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
