import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';
import 'package:out_split_in/feature/home/widgets/functions/function.dart';

class ExcelExportService {
  /// Generates an Excel-compatible CSV spreadsheet and triggers the native share sheet
  static Future<String> exportTransactions(List<TransactionModel> transactions) async {
    final buffer = StringBuffer();

    // UTF-8 Byte Order Mark (BOM) ensures Microsoft Excel correctly opens UTF-8 text
    buffer.write('\uFEFF');

    // Excel Column Headers
    buffer.writeln(
      '"Transaction ID","Date","Time","Type","Amount (INR)","Title / Merchant","Category","Payment Source","Auto-Detected"',
    );

    // Sort transactions newest to oldest
    final sorted = List<TransactionModel>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('hh:mm a');

    for (final tx in sorted) {
      final id = _escape(tx.id);
      final dateStr = dateFormat.format(tx.date);
      final timeStr = timeFormat.format(tx.date);
      final typeStr = tx.type == TransactionType.income ? 'Income' : 'Expense';
      final amountStr = tx.amount.toStringAsFixed(2);
      final title = _escape(tx.title);
      final category = _escape(categoryToString(tx.category));
      final source = _escape(tx.source);
      final autoDetected = tx.autoDetected ? 'Yes' : 'No';

      buffer.writeln(
        '"$id","$dateStr","$timeStr","$typeStr","$amountStr","$title","$category","$source","$autoDetected"',
      );
    }

    // Save to device directory
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'OutSplitIn_Transactions_$timestamp.csv';
    final file = File('${tempDir.path}/$fileName');

    await file.writeAsString(buffer.toString());

    // Share via native share dialog (Excel, WhatsApp, Email, Drive, etc.)
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'text/csv')],
        subject: 'OutSplitIn Transactions Spreadsheet',
        text: 'Exported ${transactions.length} transactions from OutSplitIn.',
      ),
    );

    return file.path;
  }

  static String _escape(String value) {
    return value.replaceAll('"', '""');
  }
}
