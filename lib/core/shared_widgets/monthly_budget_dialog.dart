import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:out_split_in/core/localization/app_localizations.dart';
import 'package:out_split_in/core/services/budget_service.dart';
import 'package:out_split_in/core/shared_widgets/snackbar.dart';
import 'package:out_split_in/core/theme/app_colors.dart';

class MonthlyBudgetDialog {
  static Future<void> show(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final currentBudget = BudgetService.instance.budgetLimit;

    final controller = TextEditingController(
      text: currentBudget.toStringAsFixed(0),
    );
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final presets = [10000.0, 25000.0, 50000.0, 100000.0];

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
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
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pull handle
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

                      // Title
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E352C) : Appcolors.lightGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.account_balance_wallet_rounded, color: Appcolors.primary, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.monthlyBudget,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : Appcolors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Set your monthly spending ceiling',
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
                      const SizedBox(height: 20),

                      // Amount Input
                      TextFormField(
                        controller: controller,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        autofocus: true,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Appcolors.textDark,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 14, right: 8),
                            child: Text(
                              '₹',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white70 : Appcolors.textDark,
                              ),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                          hintText: '25000',
                          filled: true,
                          fillColor: isDark ? const Color(0xFF161F1C) : const Color(0xFFF7F9F8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Appcolors.primary, width: 1.6),
                          ),
                        ),
                        validator: (value) {
                          final parsed = double.tryParse(value?.trim() ?? '');
                          if (parsed == null || parsed <= 0) {
                            return 'Please enter a valid budget amount';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Quick preset buttons
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: presets.map((preset) {
                          final formatted = NumberFormat.compactCurrency(
                            symbol: '₹',
                            decimalDigits: 0,
                          ).format(preset);

                          return ActionChip(
                            label: Text(
                              formatted,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                            backgroundColor: isDark ? const Color(0xFF1E352C) : Appcolors.lightGreen,
                            labelStyle: const TextStyle(color: Appcolors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: isDark ? const Color(0xFF274D3B) : const Color(0xFFCBEFDF),
                              ),
                            ),
                            onPressed: () {
                              controller.text = preset.toStringAsFixed(0);
                              setModalState(() {});
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                side: BorderSide(
                                  color: isDark ? const Color(0xFF32453E) : const Color(0xFFD6DDD9),
                                ),
                              ),
                              onPressed: () => Navigator.pop(bottomSheetContext),
                              child: Text(
                                l10n.cancel,
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Appcolors.textDark,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Appcolors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () async {
                                if (!formKey.currentState!.validate()) return;
                                final amount = double.parse(controller.text.trim());
                                await BudgetService.instance.setBudget(amount);
                                if (bottomSheetContext.mounted) {
                                  Navigator.pop(bottomSheetContext);
                                  AppSnackbar.success(
                                    context,
                                    '${l10n.budgetUpdated}: ₹${NumberFormat('#,##,###').format(amount)}',
                                  );
                                }
                              },
                              child: Text(
                                l10n.saveBudget,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
