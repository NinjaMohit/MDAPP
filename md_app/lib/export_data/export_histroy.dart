import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/model/histroymodel.dart';
import 'package:md_app/util/validation_popup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

int count = 0;

Future<void> exportHistoryToExcel(BuildContext context) async {
  // Ask user to pick a date range
  final DateTimeRange? dateRange = await selectDateRange(context);
  if (dateRange == null) return;

  // Request storage permission
  if (Platform.isAndroid) {
    var status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      print('Manage external storage permission not granted');
      return;
    }
  } else {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      print('Storage permission not granted');
      return;
    }
  }

  // Fetch all history data from database
  List<HistoryModel> historyList = [];
  try {
    historyList = await DBHelper.getAllHistory();
  } catch (e) {
    print('Error fetching history from DB: $e');
    await showDialog(
      context: context,
      builder: (_) => CustomValidationPopup(
        message: "Failed to fetch history data.",
      ),
    );
    return;
  }

  // Filter data by date range
  List<HistoryModel> filteredHistory = historyList.where((item) {
    DateTime? createdAt;
    try {
      createdAt = DateTime.parse(item.createdAt);
    } catch (e) {
      print('Date parse error for createdAt: ${item.createdAt}');
      return false;
    }

    DateTime start = DateTime(
      dateRange.start.year,
      dateRange.start.month,
      dateRange.start.day,
    );
    DateTime end = DateTime(
      dateRange.end.year,
      dateRange.end.month,
      dateRange.end.day,
      23,
      59,
      59,
    );

    return !createdAt.isBefore(start) && !createdAt.isAfter(end);
  }).toList();

  // If no data found for the date range
  if (filteredHistory.isEmpty) {
    await showDialog(
      context: context,
      builder: (_) => CustomValidationPopup(
        message: "No history data found for selected date range.",
      ),
    );
    return;
  }

  // Create Excel and add headers
  var excel = Excel.createExcel();
  excel.delete('Sheet1'); // remove default sheet
  Sheet sheetObject = excel['History'];
  sheetObject.appendRow(['Customer ID', 'Created By ID', 'Created At']);

  // Append rows for each filtered history entry
  for (var history in filteredHistory) {
    sheetObject.appendRow([
      history.customerId,
      history.createdById,
      history.createdAt,
    ]);
  }

  // Determine save path
  Directory? directory;
  if (Platform.isAndroid) {
    directory = await getExternalStorageDirectory();

    // Adjust path to Downloads folder on Android
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

  // Save Excel file
  count++;
  String filePath = '${directory.path}/history_export$count.xlsx';
  final file = File(filePath);
  await file.create(recursive: true);
  await file.writeAsBytes(excel.encode()!);

  print("✅ Excel file saved at: $filePath");

  await showDialog(
    context: context,
    builder: (_) => CustomValidationPopup(
      message:
          "Exported filtered history to Excel successfully.\nPath: $filePath",
    ),
  );
}

Future<DateTimeRange?> selectDateRange(BuildContext context) async {
  DateTime now = DateTime.now();
  return await showDateRangePicker(
    context: context,
    firstDate: DateTime(2020),
    lastDate: DateTime(now.year + 1),
    saveText: 'Done',
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.blue,
          colorScheme: ColorScheme.light(primary: Colors.blue),
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      );
    },
  );
}
