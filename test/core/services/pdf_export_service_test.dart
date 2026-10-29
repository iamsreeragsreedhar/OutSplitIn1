import 'package:flutter_test/flutter_test.dart';
import 'package:out_split_in/core/services/pdf_export_service.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';

void main() {
  group('PdfExportService Tests', () {
    test('generateStatementPdf generates non-empty PDF document bytes', () async {
      final transactions = [
        TransactionModel(
          id: '1',
          smsId: '',
          amount: 50000,
          type: TransactionType.income,
          category: TransactionCategory.salary,
          title: 'Monthly Salary',
          source: 'Employer HDFC',
          date: DateTime(2026, 10, 1),
        ),
        TransactionModel(
          id: '2',
          smsId: '',
          amount: 1250,
          type: TransactionType.expense,
          category: TransactionCategory.food,
          title: 'Dinner at Olive Garden',
          source: 'GPay',
          date: DateTime(2026, 10, 5),
        ),
        TransactionModel(
          id: '3',
          smsId: '',
          amount: 999,
          type: TransactionType.expense,
          category: TransactionCategory.bills,
          title: 'Airtel Broadband',
          source: 'PhonePe',
          date: DateTime(2026, 10, 12),
        ),
      ];

      final pdfBytes = await PdfExportService.generateStatementPdf(
        transactions,
        periodTitle: 'October 2026 Financial Statement',
        userName: 'Sreerag',
        userEmail: 'sreerag@test.com',
      );

      expect(pdfBytes, isNotNull);
      expect(pdfBytes.isNotEmpty, isTrue);
      // PDF documents start with '%PDF-'
      final header = String.fromCharCodes(pdfBytes.take(5));
      expect(header, equals('%PDF-'));
    });

    test('generateStatementPdf handles empty transaction lists gracefully', () async {
      final pdfBytes = await PdfExportService.generateStatementPdf(
        [],
        periodTitle: 'Empty Period',
      );

      expect(pdfBytes, isNotNull);
      expect(pdfBytes.isNotEmpty, isTrue);
    });
  });
}
