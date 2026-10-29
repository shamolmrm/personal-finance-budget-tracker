import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/supabase_service.dart';
import '../models/user_model.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  AuthState({required this.status, this.user});

  AuthState.authenticated(UserModel user) : status = AuthStatus.authenticated, user = user;
  AuthState.unauthenticated() : status = AuthStatus.unauthenticated, user = null;
  AuthState.unknown() : status = AuthStatus.unknown, user = null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.unknown()) {
    _loadSession();
  }

  Future<void> _loadSession() async {
    final client = SupabaseService.instance.client;
    if (client == null) {
      state = AuthState.unauthenticated();
      return;
    }
    final user = client.auth.currentUser;
    if (user != null) {
      state = AuthState.authenticated(UserModel(
        id: user.id,
        email: user.email,
        fullName: user.userMetadata?['full_name'] as String?,
      ));
    } else {
      state = AuthState.unauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    final client = SupabaseService.instance.client;
    if (client == null) {
      state = AuthState.unauthenticated();
      return;
    }
    final res = await client.auth.signInWithPassword(email: email.trim(), password: password);
    final user = res.user;
    if (user == null) {
      throw Exception('Unable to sign in. Please check your email and password.');
    }
    state = AuthState.authenticated(UserModel(
      id: user.id,
      email: user.email,
      fullName: user.userMetadata?['full_name'] as String?,
    ));
  }

  Future<void> register(String fullName, String email, String password) async {
    final client = SupabaseService.instance.client;
    if (client == null) {
      state = AuthState.unauthenticated();
      return;
    }
    final res = await client.auth.signUp(email: email.trim(), password: password, data: {'full_name': fullName.trim()});
    final user = res.user;
    if (user == null) {
      throw Exception('Unable to register. Please try again.');
    }
    state = AuthState.authenticated(UserModel(id: user.id, email: user.email, fullName: fullName.trim()));
  }

  Future<void> logout() async {
    final client = SupabaseService.instance.client;
    if (client != null) {
      await client.auth.signOut();
    }
    state = AuthState.unauthenticated();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());
