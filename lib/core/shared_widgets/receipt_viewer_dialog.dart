import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ReceiptViewerDialog extends StatelessWidget {
  final String receiptPath;
  final String title;

  const ReceiptViewerDialog({
    super.key,
    required this.receiptPath,
    this.title = 'Receipt / Bill',
  });

  static Future<void> show(
    BuildContext context, {
    required String receiptPath,
    String title = 'Receipt / Bill',
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (_) => ReceiptViewerDialog(
        receiptPath: receiptPath,
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final file = File(receiptPath);
    final fileExists = file.existsSync();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2824),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long_rounded,
                  color: Color(0xFF0BA874),
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (fileExists)
                  IconButton(
                    icon: const Icon(Icons.share_rounded, color: Colors.white70),
                    tooltip: 'Share Receipt',
                    onPressed: () async {
                      try {
                        await SharePlus.instance.share(
                          ShareParams(
                            files: [XFile(receiptPath)],
                            subject: 'Receipt - $title',
                          ),
                        );
                      } catch (e) {
                        debugPrint('Error sharing receipt: $e');
                      }
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Main Image Area with Pinch-to-Zoom
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF121815),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: fileExists
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)),
                      child: InteractiveViewer(
                        minScale: 0.8,
                        maxScale: 4.5,
                        boundaryMargin: const EdgeInsets.all(20),
                        child: Center(
                          child: Image.file(
                            file,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const _ErrorPlaceholder(
                              message: 'Failed to display receipt image.',
                            ),
                          ),
                        ),
                      ),
                    )
                  : const _ErrorPlaceholder(
                      message: 'Receipt file not found on device.',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  final String message;

  const _ErrorPlaceholder({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.broken_image_rounded, size: 48, color: Colors.white38),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
