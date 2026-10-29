import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/services/supabase_service.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local cache / offline-first
  await Hive.initFlutter();

  // Initialize Supabase (reads env/supabase config at runtime)
  await SupabaseService.instance.init();

  runApp(const ProviderScope(child: App()));
}
