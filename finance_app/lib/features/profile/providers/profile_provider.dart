import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileState {
  final String fullName;
  final String email;
  final String currency;
  final bool notificationsEnabled;
  final bool weeklySummaryEnabled;
  final bool biometricEnabled;

  ProfileState({
    required this.fullName,
    required this.email,
    required this.currency,
    this.notificationsEnabled = true,
    this.weeklySummaryEnabled = true,
    this.biometricEnabled = false,
  });

  ProfileState copyWith({
    String? fullName,
    String? email,
    String? currency,
    bool? notificationsEnabled,
    bool? weeklySummaryEnabled,
    bool? biometricEnabled,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      weeklySummaryEnabled: weeklySummaryEnabled ?? this.weeklySummaryEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier()
      : super(ProfileState(fullName: 'Taylor Brooks', email: 'taylor@example.com', currency: 'USD'));

  void updateProfile({String? fullName, String? email, String? currency}) {
    state = state.copyWith(fullName: fullName, email: email, currency: currency);
  }

  void toggleNotifications(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
  }

  void toggleWeeklySummary(bool enabled) {
    state = state.copyWith(weeklySummaryEnabled: enabled);
  }

  void toggleBiometric(bool enabled) {
    state = state.copyWith(biometricEnabled: enabled);
  }
}

final profileNotifierProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) => ProfileNotifier());
