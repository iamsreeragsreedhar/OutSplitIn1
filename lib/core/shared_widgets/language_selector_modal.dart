import 'package:flutter/material.dart';
import 'package:out_split_in/core/localization/app_localizations.dart';
import 'package:out_split_in/core/localization/locale_controller.dart';
import 'package:out_split_in/core/theme/app_colors.dart';

class LanguageSelectorModal {
  static Future<void> show(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final currentCode = LocaleController.instance.locale.languageCode;

    final languages = [
      {'code': 'en', 'name': 'English', 'native': 'English'},
      {'code': 'hi', 'name': 'Hindi', 'native': 'हिन्दी'},
      {'code': 'ml', 'name': 'Malayalam', 'native': 'മലയാളം'},
      {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்'},
    ];

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2824) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF32453E) : const Color(0xFFE0E5E2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E352C) : Appcolors.lightGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.language_rounded, color: Appcolors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.selectLanguage,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Appcolors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.languageSubtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFFA1AFA9) : Appcolors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ...languages.map((lang) {
                final code = lang['code']!;
                final isSelected = currentCode == code;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: isSelected
                        ? (isDark ? const Color(0xFF1E352C) : Appcolors.lightGreen)
                        : (isDark ? const Color(0xFF161F1C) : const Color(0xFFF7F9F8)),
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        await LocaleController.instance.setLocale(Locale(code));
                        if (bottomSheetContext.mounted) {
                          Navigator.pop(bottomSheetContext);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang['native']!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: isSelected
                                          ? Appcolors.primary
                                          : (isDark ? Colors.white : Appcolors.textDark),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    lang['name']!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? const Color(0xFFA1AFA9) : Appcolors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle_rounded, color: Appcolors.primary, size: 22),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
