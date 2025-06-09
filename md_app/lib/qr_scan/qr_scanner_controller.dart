import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/global_var.dart';
import 'package:md_app/home/customer/customer_model.dart';
import 'package:md_app/model/histroymodel.dart';
import 'package:md_app/qr_scan/qr_scan_service.dart';

class QrScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    scannedCustomer.value = null;
    errorMessage.value = '';
  }

  final qrService = QrScanService();

  var scannedCustomer = Rxn<CustomerModel>();
  var errorMessage = ''.obs;

  // Existing gallery scanning method
  Future<void> handleScanFromGallery() async {
    try {
      final qrRawData = await qrService.scanQrFromGallery();

      if (qrRawData == null) {
        errorMessage.value = "No QR code found.";
        return;
      }

      final customer = CustomerModel.fromJson(jsonDecode(qrRawData));
      final customerId = customer.id;
      if (customerId == null) {
        errorMessage.value = "Invalid QR code: Customer ID not found.";
        return;
      }
      // Record scan in daily_scans table
      final scanDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await DBHelper.insertDailyScan(customerId, userId.value, scanDate, 'Yes');
      await saveHistoryEntry(customer.id!, userId.value);
      print('Decoded QR data: $customer');

      scannedCustomer.value = customer;
      errorMessage.value = '';
      showHistoryTable();
    } catch (e) {
      errorMessage.value = 'Error parsing QR: $e';
    }
  }

  // New camera scanning method
  Future<void> handleScanFromCamera() async {
    try {
      final qrRawData = await qrService.scanQrFromCamera();

      if (qrRawData == null) {
        errorMessage.value = "No QR code found.";
        return;
      }

      final customer = CustomerModel.fromJson(jsonDecode(qrRawData));
      final customerId = customer.id;
      if (customerId == null) {
        errorMessage.value = "Invalid QR code: Customer ID not found.";
        return;
      } // Record scan in daily_scans table
      final scanDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await DBHelper.insertDailyScan(customerId, userId.value, scanDate, 'Yes');
      await saveHistoryEntry(customer.id!, userId.value);
      print('Decoded QR data: $customer');

      scannedCustomer.value = customer;
      errorMessage.value = '';
      showHistoryTable();
    } catch (e) {
      errorMessage.value = 'Error parsing QR: $e';
    }
  }

  Future<void> saveHistoryEntry(int customerId, int userId) async {
    final history = HistoryModel(
      customerId: customerId,
      createdById: userId,
      createdAt: DateTime.now().toIso8601String(),
    );

    try {
      final historyId = await DBHelper.insertHistory(history);
      print('History inserted with ID: $historyId');
    } catch (e) {
      print('Error inserting history: $e');
    }
  }

  static Future<void> showHistoryTable() async {
    final db = await DBHelper.database;
    final List<Map<String, dynamic>> result = await db.query('histroy');

    print('\n--- History Table Records ---');
    for (var row in result) {
      print('ID: ${row['id']}');
      print('Customer ID: ${row['customerId']}');
      print('Created By ID: ${row['createdById']}');
      print('Created At: ${row['createdAt']}');
      print('-----------------------------');
    }
  }
}
