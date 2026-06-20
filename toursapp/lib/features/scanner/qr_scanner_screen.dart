import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stoneecho/features/scanner/widgets/scan_frame.dart';
import 'package:stoneecho/features/scanner/widgets/scan_success_card.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key});

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen> {
  final _controller = MobileScannerController();
  bool _hasScanned = false;
  String? _scannedCode;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    setState(() {
      _hasScanned = true;
      _scannedCode = barcode!.rawValue;
    });

    // TODO: Call API /places/qr/{code} and show result
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Dark overlay with scanning frame cutout
          const ScanFrame(),

          // Top bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                ),
                Text(
                  l10n.scanQrCode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    onPressed: _controller.toggleTorch,
                  ),
                ),
              ],
            ),
          ),

          // Instruction text
          Positioned(
            bottom: 200,
            left: 32,
            right: 32,
            child: Text(
              l10n.scanInstruction,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),

          // Success card (slides up when scanned)
          if (_hasScanned && _scannedCode != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ScanSuccessCard(
                qrCode: _scannedCode!,
                onPlayAudio: () {
                  // TODO: Navigate to place detail and auto-play
                },
                onViewDetails: () {
                  // TODO: Navigate to place detail
                  context.pop();
                },
                onDismiss: () {
                  setState(() {
                    _hasScanned = false;
                    _scannedCode = null;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
