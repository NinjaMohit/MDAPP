import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobile_scanner;

class QrScanService {
  // Existing gallery-based scanning method
  Future<String?> scanQrFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final inputImage = InputImage.fromFile(File(pickedFile.path));
    final barcodeScanner = BarcodeScanner();

    final List<Barcode> barcodes =
        await barcodeScanner.processImage(inputImage);
    await barcodeScanner.close();

    if (barcodes.isEmpty) return null;

    return barcodes.first.rawValue;
  }

  // New camera-based scanning method
  Future<String?> scanQrFromCamera() async {
    try {
      final controller = mobile_scanner.MobileScannerController(
        formats: [mobile_scanner.BarcodeFormat.qrCode],
        facing: mobile_scanner.CameraFacing.back,
        torchEnabled: false,
      );

      // Use a completer to handle the asynchronous barcode detection
      final completer = Completer<String?>();

      // Start scanning and listen for barcode detection
      controller.barcodes.listen((mobile_scanner.BarcodeCapture capture) {
        if (!completer.isCompleted) {
          if (capture.barcodes.isNotEmpty) {
            completer.complete(capture.barcodes.first.rawValue);
          } else {
            completer.complete(null);
          }
        }
      }, onError: (error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
      });

      // Start the scanner
      await controller.start();

      // Wait for the first barcode detection or timeout
      String? result;
      try {
        result = await completer.future.timeout(Duration(seconds: 30),
            onTimeout: () {
          return null; // Return null if no barcode is detected within 30 seconds
        });
      } catch (e) {
        print('Error scanning QR from camera: $e');
        result = null;
      }

      // Dispose of the controller
      await controller.dispose();

      return result;
    } catch (e) {
      print('Error scanning QR from camera: $e');
      return null;
    }
  }
}
