import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:out_split_in/core/theme/view_model/theme_event.dart';
import 'package:out_split_in/core/theme/view_model/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themePrefKey = 'app_theme_mode';

  ThemeBloc() : super(const ThemeState()) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ChangeThemeEvent>(_onChangeTheme);
  }

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeString = prefs.getString(_themePrefKey);

      final mode = switch (modeString) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

      emit(state.copyWith(themeMode: mode));
    } catch (_) {
      emit(state.copyWith(themeMode: ThemeMode.system));
    }
  }

  Future<void> _onChangeTheme(
    ChangeThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(themeMode: event.themeMode));
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeString = switch (event.themeMode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
      await prefs.setString(_themePrefKey, modeString);
    } catch (_) {}
  }
}
