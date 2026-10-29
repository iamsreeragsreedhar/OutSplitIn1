import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';
import 'package:out_split_in/feature/home/widgets/functions/function.dart';

class PdfExportService {
  static const PdfColor primaryColor = PdfColor.fromInt(0xFF0BA874);
  static const PdfColor darkGreen = PdfColor.fromInt(0xFF087F59);
  static const PdfColor lightGreen = PdfColor.fromInt(0xFFE8F8F2);
  static const PdfColor expenseRed = PdfColor.fromInt(0xFFE05A62);
  static const PdfColor textDark = PdfColor.fromInt(0xFF18231F);
  static const PdfColor textMuted = PdfColor.fromInt(0xFF708078);
  static const PdfColor borderColor = PdfColor.fromInt(0xFFE4EDE8);
  static const PdfColor surfaceBg = PdfColor.fromInt(0xFFF9FBF9);

  /// Generates the complete PDF document bytes
  static Future<Uint8List> generateStatementPdf(
    List<TransactionModel> transactions, {
    String periodTitle = 'All-Time Statement',
    String? userName,
    String? userEmail,
  }) async {
    final pdf = pw.Document();

    // Sort newest first
    final sorted = List<TransactionModel>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Calculate metrics
    double totalIncome = 0.0;
    double totalExpense = 0.0;
    final Map<String, double> categorySpend = {};

    for (final tx in sorted) {
      if (tx.type == TransactionType.income) {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount;
        final catName = categoryToString(tx.category);
        categorySpend[catName] = (categorySpend[catName] ?? 0.0) + tx.amount;
      }
    }

    final double netBalance = totalIncome - totalExpense;
    final double savingsRate = totalIncome > 0
        ? ((totalIncome - totalExpense) / totalIncome * 100).clamp(0, 100)
        : 0.0;

    final dateFormat = DateFormat('dd MMM yyyy');
    final timeFormat = DateFormat('hh:mm a');
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: 'Rs. ',
      decimalDigits: 2,
    );

    // Sorted categories by spend
    final sortedCategories = categorySpend.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final generatedOn = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(
          periodTitle: periodTitle,
          userName: userName,
          userEmail: userEmail,
          generatedOn: generatedOn,
        ),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          pw.SizedBox(height: 16),

          // KPI Metric Summary Cards
          _buildMetricsSection(
            currencyFormat: currencyFormat,
            totalIncome: totalIncome,
            totalExpense: totalExpense,
            netBalance: netBalance,
            savingsRate: savingsRate,
          ),

          pw.SizedBox(height: 20),

          // Top Expense Categories Section
          if (sortedCategories.isNotEmpty) ...[
            pw.Text(
              'EXPENSE BREAKDOWN BY CATEGORY',
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: textMuted,
                letterSpacing: 1.1,
              ),
            ),
            pw.SizedBox(height: 8),
            _buildCategoryBreakdownTable(
              sortedCategories: sortedCategories,
              totalExpense: totalExpense,
              currencyFormat: currencyFormat,
            ),
            pw.SizedBox(height: 22),
          ],

          // Transaction Ledger Section
          pw.Text(
            'TRANSACTION HISTORY (${sorted.length} RECORDS)',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: textMuted,
              letterSpacing: 1.1,
            ),
          ),
          pw.SizedBox(height: 8),

          _buildTransactionTable(
            sorted: sorted,
            dateFormat: dateFormat,
            timeFormat: timeFormat,
            currencyFormat: currencyFormat,
          ),
        ],
      ),
    );

    return pdf.save();
  }

  /// Triggers the native print or PDF preview
  static Future<void> printStatement(
    List<TransactionModel> transactions, {
    String periodTitle = 'Expense Report',
    String? userName,
    String? userEmail,
  }) async {
    final pdfBytes = await generateStatementPdf(
      transactions,
      periodTitle: periodTitle,
      userName: userName,
      userEmail: userEmail,
    );

    await Printing.layoutPdf(
      name: 'OutSplitIn_Statement_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }

  /// Exports and triggers the system share sheet
  static Future<String> shareStatementPdf(
    List<TransactionModel> transactions, {
    String periodTitle = 'Expense Statement',
    String? userName,
    String? userEmail,
  }) async {
    final pdfBytes = await generateStatementPdf(
      transactions,
      periodTitle: periodTitle,
      userName: userName,
      userEmail: userEmail,
    );

    final tempDir = await getTemporaryDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'OutSplitIn_Statement_$timestamp.pdf';
    final file = File('${tempDir.path}/$fileName');

    await file.writeAsBytes(pdfBytes);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/pdf')],
        subject: 'OutSplitIn Financial Statement',
        text: 'Financial Statement generated by OutSplitIn with ${transactions.length} transactions.',
      ),
    );

    return file.path;
  }

  // --- Helper Widgets ---

  static pw.Widget _buildHeader({
    required String periodTitle,
    String? userName,
    String? userEmail,
    required String generatedOn,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: borderColor, width: 1.2),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: pw.BoxDecoration(
                      color: primaryColor,
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Text(
                      'OutSplitIn',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Text(
                    'Financial Statement',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                periodTitle,
                style: const pw.TextStyle(fontSize: 11, color: textMuted),
              ),
              if (userName != null && userName.isNotEmpty) ...[
                pw.SizedBox(height: 2),
                pw.Text(
                  'User: $userName ${userEmail != null ? "($userEmail)" : ""}',
                  style: const pw.TextStyle(fontSize: 9, color: textMuted),
                ),
              ],
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Generated On',
                style: const pw.TextStyle(fontSize: 9, color: textMuted),
              ),
              pw.Text(
                generatedOn,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildMetricsSection({
    required NumberFormat currencyFormat,
    required double totalIncome,
    required double totalExpense,
    required double netBalance,
    required double savingsRate,
  }) {
    return pw.Row(
      children: [
        _metricBox(
          title: 'TOTAL INCOME',
          amount: currencyFormat.format(totalIncome),
          color: primaryColor,
          bgColor: lightGreen,
        ),
        pw.SizedBox(width: 8),
        _metricBox(
          title: 'TOTAL EXPENSES',
          amount: currencyFormat.format(totalExpense),
          color: expenseRed,
          bgColor: const PdfColor.fromInt(0xFFFFF0F0),
        ),
        pw.SizedBox(width: 8),
        _metricBox(
          title: 'NET SAVINGS',
          amount: currencyFormat.format(netBalance),
          color: netBalance >= 0 ? darkGreen : expenseRed,
          bgColor: surfaceBg,
        ),
        pw.SizedBox(width: 8),
        _metricBox(
          title: 'SAVINGS RATE',
          amount: '${savingsRate.toStringAsFixed(1)}%',
          color: primaryColor,
          bgColor: surfaceBg,
        ),
      ],
    );
  }

  static pw.Widget _metricBox({
    required String title,
    required String amount,
    required PdfColor color,
    required PdfColor bgColor,
  }) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: pw.BoxDecoration(
          color: bgColor,
          borderRadius: pw.BorderRadius.circular(8),
          border: pw.Border.all(color: borderColor, width: 0.8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 7.5,
                fontWeight: pw.FontWeight.bold,
                color: textMuted,
                letterSpacing: 0.5,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              amount,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildCategoryBreakdownTable({
    required List<MapEntry<String, double>> sortedCategories,
    required double totalExpense,
    required NumberFormat currencyFormat,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: borderColor, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(2),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: surfaceBg),
          children: [
            _th('Category'),
            _th('Total Spent', align: pw.TextAlign.right),
            _th('% of Expenses', align: pw.TextAlign.right),
          ],
        ),
        ...sortedCategories.take(6).map((entry) {
          final pct = totalExpense > 0 ? (entry.value / totalExpense * 100) : 0.0;
          return pw.TableRow(
            children: [
              _td(entry.key),
              _td(currencyFormat.format(entry.value), align: pw.TextAlign.right),
              _td('${pct.toStringAsFixed(1)}%', align: pw.TextAlign.right),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildTransactionTable({
    required List<TransactionModel> sorted,
    required DateFormat dateFormat,
    required DateFormat timeFormat,
    required NumberFormat currencyFormat,
  }) {
    if (sorted.isEmpty) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(24),
        alignment: pw.Alignment.center,
        child: pw.Text(
          'No transactions found for this period.',
          style: const pw.TextStyle(color: textMuted, fontSize: 10),
        ),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: borderColor, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(2.2), // Date
        1: pw.FlexColumnWidth(3.8), // Title
        2: pw.FlexColumnWidth(2.2), // Category
        3: pw.FlexColumnWidth(1.6), // Type
        4: pw.FlexColumnWidth(2.2), // Amount
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: surfaceBg),
          children: [
            _th('Date & Time'),
            _th('Title / Note'),
            _th('Category'),
            _th('Type'),
            _th('Amount', align: pw.TextAlign.right),
          ],
        ),
        ...sorted.map((tx) {
          final isIncome = tx.type == TransactionType.income;
          return pw.TableRow(
            children: [
              _td('${dateFormat.format(tx.date)}\n${timeFormat.format(tx.date)}',
                  fontSize: 7.5),
              _td(
                tx.title.isNotEmpty ? tx.title : 'Transaction',
                subtitle: tx.source.isNotEmpty ? tx.source : null,
              ),
              _td(categoryToString(tx.category)),
              _td(
                isIncome ? 'INCOME' : 'EXPENSE',
                color: isIncome ? primaryColor : expenseRed,
                bold: true,
                fontSize: 7.5,
              ),
              _td(
                '${isIncome ? '+' : '-'}${currencyFormat.format(tx.amount)}',
                color: isIncome ? primaryColor : expenseRed,
                bold: true,
                align: pw.TextAlign.right,
              ),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _th(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
          color: textDark,
        ),
      ),
    );
  }

  static pw.Widget _td(
    String text, {
    String? subtitle,
    PdfColor? color,
    bool bold = false,
    double fontSize = 8.5,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: pw.Column(
        crossAxisAlignment: align == pw.TextAlign.right
            ? pw.CrossAxisAlignment.end
            : pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            text,
            textAlign: align,
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: color ?? textDark,
            ),
          ),
          if (subtitle != null && subtitle.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              subtitle,
              textAlign: align,
              style: const pw.TextStyle(fontSize: 7, color: textMuted),
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 14),
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: borderColor, width: 0.8)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'OutSplitIn - Smart Personal Finance & Expense Tracker',
            style: const pw.TextStyle(fontSize: 8, color: textMuted),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: textMuted),
          ),
        ],
      ),
    );
  }
}
