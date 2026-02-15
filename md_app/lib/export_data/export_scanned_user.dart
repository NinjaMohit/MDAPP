import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/util/validation_popup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart'; // Ensure this is imported for DateFormat

int count = 0;

Future<void> exportTodayScansToExcel(BuildContext context) async {
  try {
    // Request storage permission
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

    // Fetch today's scans
    final scans = await DBHelper.getTodayScans();
    if (scans.isEmpty) {
      await showDialog(
        context: context,
        builder: (_) => CustomValidationPopup(
          message: "No users scanned today.",
        ),
      );
      return;
    }

    // Group scans by societyName
    final groupedScans = <String, List<Map<String, dynamic>>>{};
    for (var scan in scans) {
      final societyName = scan['societyName'] ?? 'Unknown';
      if (!groupedScans.containsKey(societyName)) {
        groupedScans[societyName] = [];
      }
      groupedScans[societyName]!.add(scan);
    }

    // Create Excel file
    final excel = Excel.createExcel();
    excel.delete('Sheet1'); // Remove default sheet
    final sheet = excel['TodayScans'];

    // Add headers
    sheet.appendRow(['Society Name', 'Customer Name', 'Mobile']);

    // Add data grouped by society with 3 empty rows between societies
    for (var societyName in groupedScans.keys) {
      final scans = groupedScans[societyName]!;

      for (int i = 0; i < scans.length; i++) {
        final scan = scans[i];

        // Show society name only for the first row
        sheet.appendRow([
          i == 0 ? societyName : '', // Society name only in first row
          scan['customerName'] ?? 'N/A',
          scan['customerMobile'] ?? 'N/A',
        ]);
      }
      // Add 3 empty rows between societies (except for the last society)
      if (societyName != groupedScans.keys.last) {
        sheet.appendRow(['', '', '']);
        sheet.appendRow(['', '', '']);
      }
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

    // Generate file name with date and counter
    count++; // Reuse the global count variable
    final today = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy').format(today);
    final fileName = 'today_scans_${formattedDate}_$count.xlsx';
    final filePath = '${directory.path}/$fileName';

    // Save Excel file
    final file = File(filePath);
    await file.writeAsBytes(excel.encode()!);

    // Show success dialog
    await showDialog(
      context: context,
      builder: (_) => CustomValidationPopup(
        message: "Today's scans exported successfully!\nPath: $filePath",
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
