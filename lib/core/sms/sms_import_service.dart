import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SmsImportResult {
  final int scanned;
  final int imported;
  final int duplicates;
  final int ignored;

  const SmsImportResult({
    required this.scanned,
    required this.imported,
    required this.duplicates,
    required this.ignored,
  });
}

class SmsImportService {
  SmsImportService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  });

  Future<SmsImportResult> importInbox() async {
    return const SmsImportResult(
      scanned: 0,
      imported: 0,
      duplicates: 0,
      ignored: 0,
    );
  }
}
