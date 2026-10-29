import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseClient? _client;
  static final SupabaseService instance = SupabaseService._internal();

  SupabaseService._internal();

  Future<void> init() async {
    // Initialize Supabase client. In production, load these from secure env.
    const url = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
    const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

    if (url.isEmpty || anonKey.isEmpty) {
      // Skip initialization if not provided; feature tests can mock this.
      return;
    }

    await Supabase.initialize(url: url, anonKey: anonKey);
    _client = Supabase.instance.client;
  }

  SupabaseClient? get client => _client;
}
