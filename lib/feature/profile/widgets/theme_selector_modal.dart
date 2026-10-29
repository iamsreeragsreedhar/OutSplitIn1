import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:out_split_in/core/theme/view_model/theme_bloc.dart';
import 'package:out_split_in/core/theme/view_model/theme_event.dart';
import 'package:out_split_in/core/theme/view_model/theme_state.dart';

class ThemeSelectorModal extends StatelessWidget {
  const ThemeSelectorModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const ThemeSelectorModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2824) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Choose Theme',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF18231F),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Select your preferred visual style',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white60 : const Color(0xFF78837F),
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _themeTile(
                      context: context,
                      title: 'System Default',
                      subtitle: 'Matches your device settings',
                      icon: Icons.brightness_auto_rounded,
                      mode: ThemeMode.system,
                      currentMode: state.themeMode,
                    ),
                    const SizedBox(height: 8),
                    _themeTile(
                      context: context,
                      title: 'Light Theme',
                      subtitle: 'Clean off-white & emerald palette',
                      icon: Icons.light_mode_rounded,
                      mode: ThemeMode.light,
                      currentMode: state.themeMode,
                    ),
                    const SizedBox(height: 8),
                    _themeTile(
                      context: context,
                      title: 'Dark Theme',
                      subtitle: 'Eye-friendly dark green & slate',
                      icon: Icons.dark_mode_rounded,
                      mode: ThemeMode.dark,
                      currentMode: state.themeMode,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode currentMode,
  }) {
    final isSelected = mode == currentMode;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primary = Color(0xFF0BA874);

    return InkWell(
      onTap: () {
        context.read<ThemeBloc>().add(ChangeThemeEvent(mode));
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withValues(alpha: isDark ? 0.2 : 0.1)
              : (isDark ? const Color(0xFF161F1C) : const Color(0xFFF7F9F8)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? primary
                : (isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC)),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? primary
                    : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : const Color(0xFF4A5551)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF18231F),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : const Color(0xFF78837F),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
