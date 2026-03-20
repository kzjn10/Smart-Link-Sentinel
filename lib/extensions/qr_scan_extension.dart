import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../presentation/widget/x_bottom_sheet_content.dart';
import 'context_extensions.dart';

extension QrScanExtension on BuildContext {
  Future<void> scanQrCodeToController(TextEditingController controller) async {
    await showModalBottomSheet(
      context: this,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20)),
      ),
      builder: (sheetContext) {
        final appContext = this;
        final mobileScannerController = MobileScannerController();

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(appContext).viewInsets.bottom,
          ),
          child: XBottomSheetContent(
            padding: EdgeInsets.zero,
            height: appContext.deviceHeight * 0.5,
            title: appContext.l10n?.common_text_scanQrCodeTitle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: MobileScanner(
                        controller: mobileScannerController,
                        onDetect: (capture) {
                          final barcode = capture.barcodes.firstOrNull;
                          final value = barcode?.rawValue;
                          if (value != null && value.isNotEmpty) {
                            controller.text = value;
                            mobileScannerController.dispose();
                            Navigator.pop(sheetContext);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    appContext.l10n?.common_text_scanQrCode ?? '',
                    style: appContext.textTheme.bodySmall?.copyWith(
                      color: appContext.tertiaryColor.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      mobileScannerController.dispose();
                      Navigator.pop(sheetContext);
                    },
                    child: Text(appContext.l10n?.common_text_cancel ?? ''),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
