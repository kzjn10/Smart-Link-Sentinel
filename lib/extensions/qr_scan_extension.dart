import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../presentation/widget/x_bottom_sheet_content.dart';
import 'context_extensions.dart';

extension QrScanExtension on BuildContext {
  Future<void> scanQrCodeToController(TextEditingController controller) async {
    final appContext = this;
    final router = GoRouter.of(appContext);
    final initialUri = router.routerDelegate.currentConfiguration.uri;

    var bottomSheetOpen = true;

    final mobileScannerController = MobileScannerController();
    var mobileScannerDisposed = false;

    void disposeScanner() {
      if (mobileScannerDisposed) return;
      mobileScannerDisposed = true;
      mobileScannerController.dispose();
    }

    void dismissIfStillOpen() {
      if (!bottomSheetOpen) return;
      if (!appContext.mounted) return;

      bottomSheetOpen = false;
      final navigator = Navigator.of(appContext);
      if (navigator.canPop()) {
        navigator.pop();
      }
    }

    void onRouteChanged() {
      if (router.routerDelegate.currentConfiguration.uri != initialUri) {
        dismissIfStillOpen();
      }
    }

    router.routerDelegate.addListener(onRouteChanged);

    try {
      await showModalBottomSheet(
        context: appContext,
        useSafeArea: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: .vertical(top: .circular(20)),
        ),
        builder: (sheetContext) {
          return Padding(
            padding: .only(bottom: MediaQuery.of(appContext).viewInsets.bottom),
            child: XBottomSheetContent(
              padding: EdgeInsets.zero,
              height: appContext.deviceHeight * 0.5,
              title: appContext.l10n?.common_text_scanQrCodeTitle,
              child: Padding(
                padding: const .symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      width: 300,
                      child: ClipRRect(
                        borderRadius: .circular(12),
                        child: MobileScanner(
                          controller: mobileScannerController,
                          onDetect: (capture) {
                            final barcode = capture.barcodes.firstOrNull;
                            final value = barcode?.rawValue;
                            if (value != null && value.isNotEmpty) {
                              controller.text = value;
                              bottomSheetOpen = false;
                              disposeScanner();
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
                        bottomSheetOpen = false;
                        disposeScanner();
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
    } finally {
      router.routerDelegate.removeListener(onRouteChanged);
      bottomSheetOpen = false;
      disposeScanner();
    }
  }
}
