import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:out_split_in/core/services/excel_export_service.dart';
import 'package:out_split_in/core/services/pdf_export_service.dart';
import 'package:out_split_in/core/shared_widgets/snackbar.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';

class ExportStatementSheet extends StatelessWidget {
  final List<TransactionModel> transactions;
  final String periodTitle;

  const ExportStatementSheet({
    super.key,
    required this.transactions,
    this.periodTitle = 'Financial Statement',
  });

  static Future<void> show(
    BuildContext context, {
    required List<TransactionModel> transactions,
    String periodTitle = 'Financial Statement',
  }) {
    if (transactions.isEmpty) {
      AppSnackbar.info(context, 'No transactions available to export');
      return Future.value();
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExportStatementSheet(
        transactions: transactions,
        periodTitle: periodTitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? 'OutSplitIn User';
    final userEmail = user?.email;

    const primary = Color(0xFF0BA874);
    final cardBg = isDark ? const Color(0xFF1E2824) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF18231F);
    final mutedColor = isDark ? const Color(0xFFA1AFA9) : const Color(0xFF84918B);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pill Handle
            Center(
              child: Container(
                width: 44,
                height: 4.5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.description_rounded, color: primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Export Statement',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${transactions.length} transactions included',
                        style: TextStyle(fontSize: 13, color: mutedColor),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: mutedColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Option 1: PDF Statement
            _exportOption(
              context: context,
              isDark: isDark,
              icon: Icons.picture_as_pdf_rounded,
              iconColor: const Color(0xFFE05A62),
              bgColor: const Color(0xFFFFF0F0),
              title: 'Branded PDF Statement',
              subtitle: 'Formatted report with summary cards & category charts',
              onTap: () async {
                Navigator.pop(context);
                try {
                  AppSnackbar.info(context, 'Generating PDF statement...');
                  await PdfExportService.shareStatementPdf(
                    transactions,
                    periodTitle: periodTitle,
                    userName: userName,
                    userEmail: userEmail,
                  );
                } catch (e) {
                  if (context.mounted) {
                    AppSnackbar.error(context, 'PDF generation failed: $e');
                  }
                }
              },
            ),

            const SizedBox(height: 12),

            // Option 2: Print / Preview PDF
            _exportOption(
              context: context,
              isDark: isDark,
              icon: Icons.print_rounded,
              iconColor: primary,
              bgColor: const Color(0xFFE8F8F2),
              title: 'Print / Preview PDF',
              subtitle: 'Direct wireless printing or save to device as PDF',
              onTap: () async {
                Navigator.pop(context);
                try {
                  await PdfExportService.printStatement(
                    transactions,
                    periodTitle: periodTitle,
                    userName: userName,
                    userEmail: userEmail,
                  );
                } catch (e) {
                  if (context.mounted) {
                    AppSnackbar.error(context, 'Printing failed: $e');
                  }
                }
              },
            ),

            const SizedBox(height: 12),

            // Option 3: Excel CSV
            _exportOption(
              context: context,
              isDark: isDark,
              icon: Icons.table_view_rounded,
              iconColor: const Color(0xFF1D6F42),
              bgColor: const Color(0xFFE8F5E9),
              title: 'Excel Spreadsheet (.CSV)',
              subtitle: 'Data table compatible with Excel & Google Sheets',
              onTap: () async {
                Navigator.pop(context);
                try {
                  AppSnackbar.info(context, 'Preparing Excel spreadsheet...');
                  await ExcelExportService.exportTransactions(transactions);
                } catch (e) {
                  if (context.mounted) {
                    AppSnackbar.error(context, 'Excel export failed: $e');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _exportOption({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final textColor = isDark ? Colors.white : const Color(0xFF18231F);
    final mutedColor = isDark ? const Color(0xFFA1AFA9) : const Color(0xFF84918B);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF24322C) : const Color(0xFFF7FBF9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2E3E37) : const Color(0xFFE5EDE8),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D3C35) : bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
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
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: mutedColor),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: mutedColor.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
