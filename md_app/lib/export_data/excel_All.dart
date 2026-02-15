import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/util/validation_popup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

int count = 0;
Future<void> exportAllTablesToExcel(BuildContext context) async {
  try {
    // Permissions
    if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        await showDialog(
          context: context,
          builder: (_) => CustomValidationPopup(
            message: "Manage External Storage permission not granted",
          ),
        );
        return;
      }
    } else {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        await showDialog(
          context: context,
          builder: (_) => CustomValidationPopup(
            message: "Storage permission not granted",
          ),
        );
        return;
      }
    }

    // Get data from all 3 tables
    final db = await DBHelper.database;
    final users = await db.query('users');
    final customers = await db.query('customers');
    final dailyScans = await db.query('daily_scans');

    if (users.isEmpty && customers.isEmpty && dailyScans.isEmpty) {
      await showDialog(
        context: context,
        builder: (_) => CustomValidationPopup(
          message: "No data found in users, customers, or daily_scans tables.",
        ),
      );
      return;
    }

    final excel = Excel.createExcel();
    excel.delete('Sheet1');

    // Export Users
    final userSheet = excel['Users'];
    userSheet.appendRow([
      'ID',
      'Username',
      'Password',
      'IsActive',
      'IsAdmin',
      'CreatedAt',
      'UpdatedAt'
    ]);
    for (var row in users) {
      userSheet.appendRow([
        row['id'],
        row['username'],
        row['password'],
        row['isActive'],
        row['isAdmin'],
        row['createdAt'],
        row['updatedAt'],
      ]);
    }

    // Export Customers
    final customerSheet = excel['Customers'];
    customerSheet.appendRow([
      'ID',
      'Society Name',
      'Building Name',
      'Flat No',
      'Customer Name',
      'Mobile',
      //  'Abbreviation',
      'IsActive',
      'QR Data',
      'CreatedAt',
      'UpdatedAt'
    ]);
    for (var row in customers) {
      customerSheet.appendRow([
        row['id'],
        row['societyName'],
        row['buildingName'],
        row['flatNo'],
        row['customerName'],
        row['customerMobile'],
        //    row['abbreviation'],
        row['isActive'],
        row['qrData'],
        row['createdAt'],
        row['updatedAt'],
      ]);
    }

    // Export Daily Scans
    final scanSheet = excel['DailyScans'];
    scanSheet.appendRow([
      'ID',
      'CustomerId',
      'CreatedById',
      'ScanDate',
      'Scanned',
      'CreatedAt'
    ]);
    for (var row in dailyScans) {
      scanSheet.appendRow([
        row['id'],
        row['customerId'],
        row['createdById'],
        row['scanDate'],
        row['scanned'],
        row['createdAt'],
      ]);
    }

    // Set save path
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
      String newPath = "";
      List<String> folders = directory!.path.split("/");
      for (int i = 1; i < folders.length; i++) {
        if (folders[i] != "Android") {
          newPath += "/${folders[i]}";
        } else {
          break;
        }
      }
      newPath = "$newPath/Download";
      directory = Directory(newPath);
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    count++;
    final today = DateTime.now();
    final formattedDate =
        "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}";

    print(formattedDate); // Output: 14-06-2025
    final fileName = 'export_all_tables_${formattedDate}_$count.xlsx';
    final filePath = '${directory.path}/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(excel.encode()!);

    // Show success dialog
    await showDialog(
      context: context,
      builder: (_) => CustomValidationPopup(
        message: "Export successful!\nPath: $filePath",
      ),
    );
  } catch (e) {
    print('Export failed: $e');
    await showDialog(
      context: context,
      builder: (_) => CustomValidationPopup(
        message: "Export failed.\nError: $e",
      ),
    );
  }
}
