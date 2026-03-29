import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvancedSettings {
  final bool antialiasing;
  final bool smoothing;

  const AdvancedSettings({
    this.antialiasing = false,
    this.smoothing = false,
  });

  AdvancedSettings copyWith({bool? antialiasing, bool? smoothing}) {
    return AdvancedSettings(
      antialiasing: antialiasing ?? this.antialiasing,
      smoothing: smoothing ?? this.smoothing,
    );
  }
}

class AdvancedSettingsNotifier extends Notifier<AdvancedSettings> {
  static const _antialiasingKey = 'advancedSettings_antialiasing';
  static const _smoothingKey = 'advancedSettings_smoothing';

  @override
  AdvancedSettings build() {
    _loadFromPreferences();
    return const AdvancedSettings();
  }

  Future<void> _loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final antialiasing = prefs.getBool(_antialiasingKey) ?? false;
    final smoothing = prefs.getBool(_smoothingKey) ?? false;
    state = AdvancedSettings(
      antialiasing: antialiasing,
      smoothing: smoothing,
    );
  }

  Future<void> setAntialiasing(bool value) async {
    state = state.copyWith(antialiasing: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_antialiasingKey, value);
  }

  Future<void> setSmoothing(bool value) async {
    state = state.copyWith(smoothing: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_smoothingKey, value);
  }

  Future<void> updateSettings({
    required bool antialiasing,
    required bool smoothing,
  }) async {
    state = AdvancedSettings(
      antialiasing: antialiasing,
      smoothing: smoothing,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_antialiasingKey, antialiasing);
    await prefs.setBool(_smoothingKey, smoothing);
  }
}

final advancedSettingsProvider =
    NotifierProvider<AdvancedSettingsNotifier, AdvancedSettings>(
  AdvancedSettingsNotifier.new,
);
