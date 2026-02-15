import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/home/customer/customer_model.dart';
import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/validation_popup.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportController extends GetxController {
  var selectedSociety = RxnString();
  var selectedDateRange = Rxn<DateTimeRange>();
  int count = 0;
  Future<void> exportDataBySociety(context) async {
    // Get all customers
    // Reset selections
    selectedSociety.value = null; // Add this line
    selectedDateRange.value = null;

    List<CustomerModel> customers = await DBHelper.getAllCustomers();

    // Get unique societies
    List<String> uniqueSocieties = customers
        .map((c) => c.societyName?.trim() ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    // Show dialog for society and date range selection
    bool? confirmed = await Get.dialog<bool>(
      StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text("Export Scan Data"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: flutter.BoxDecoration(
                  border: flutter.Border.all(color: flutter.Colors.grey),
                  borderRadius: flutter.BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  underline: Container(
                    height: 0,
                    color: Colors.grey,
                  ),
                  value: selectedSociety.value,
                  isExpanded: true,
                  hint: Text(
                    "Select Society",
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                  items: uniqueSocieties.map((soc) {
                    return DropdownMenuItem<String>(
                      value: soc,
                      child: Text(soc),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedSociety.value = val;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton.icon(
                icon: Icon(Icons.date_range, color: Colors.black87),
                label: Text(
                  selectedDateRange.value == null
                      ? "Select Date Range"
                      : "${DateFormat('yyyy-MM-dd').format(selectedDateRange.value!.start)} → ${DateFormat('yyyy-MM-dd').format(selectedDateRange.value!.end)}",
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
                onPressed: () async {
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: Colors.blue,
                          colorScheme: ColorScheme.light(primary: Colors.blue),
                          buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (range != null) {
                    setState(() {
                      selectedDateRange.value = range;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.buttoncolor,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Get.back(result: false),
              child: Text("Cancel"),
            ),
            SizedBox(width: 5),
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.buttoncolor,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Get.back(result: true),
              child: Text("Export"),
            ),
          ],
        );
      }),
    );

    if (confirmed != true) return;

    // Set default date range if none selected (e.g., today)
    DateTimeRange dateRange = selectedDateRange.value ??
        DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now(),
        );

    // Filter customers by society
    List<CustomerModel> filteredCustomers = customers.where((c) {
      bool societyMatch = selectedSociety.value == null ||
          c.societyName?.trim().toLowerCase() ==
              selectedSociety.value!.trim().toLowerCase();
      return societyMatch;
    }).toList();

    if (filteredCustomers.isEmpty) {
      await showDialog(
        context: context,
        builder: (_) => CustomValidationPopup(
          message: "No customers found for the selected society.",
        ),
      );
      return;
    }

    // Generate list of dates in the range
    List<String> dates = [];
    DateTime currentDate = dateRange.start;
    while (!currentDate.isAfter(dateRange.end)) {
      dates.add(DateFormat('yyyy-MM-dd').format(currentDate));
      currentDate = currentDate.add(Duration(days: 1));
    }

    // Fetch scan data for all customers and dates
    List<Map<String, dynamic>> scanData = [];
    for (var customer in filteredCustomers) {
      for (var date in dates) {
        final scanRecords = await DBHelper.getDailyScans(date);
        final scanRecord = scanRecords.firstWhere(
          (record) => record['id'] == customer.id,
          orElse: () => {
            'id': customer.id,
            'customerName': customer.customerName,
            'societyName': customer.societyName,
            'scanned': 'No',
          },
        );

        scanData.add({
          'customerName': customer.customerName ?? '',
          'societyName': customer.societyName ?? '',
          'date': date,
          'day': DateFormat('EEEE').format(DateTime.parse(date)),
          'scanned': scanRecord['scanned'],
        });
      }
    }

    if (scanData.isEmpty) {
      await showDialog(
        context: context,
        builder: (_) => CustomValidationPopup(
          message: "No scan data found for the selected filter(s).",
        ),
      );
      return;
    }

// Create Excel file
    // Create Excel file
    var excel = Excel.createExcel();
    excel.delete('Sheet1');
    Sheet sheet = excel['ScanReport'];

// Add headers: Customer Name, Society Name, Date Range, [each date]
    List<String> headers = [
      'Society Name',
      'Mobile No',
      'Flat No',
      'Customer Name',
      'Date Range',
    ];
    headers.add(''); // spacer column 1

    for (var date in dates) {
      headers.add(date); // actual date header
      headers.add(''); // spacer column 1
    }
    sheet.appendRow(headers);

// Prepare the data with spacing
    List<List<String>> rowsToAdd = [];
    String? previousSocietyName;

    for (var customer in filteredCustomers) {
      // Check if society name has changed
      if (previousSocietyName != null &&
          previousSocietyName != customer.societyName?.trim()) {
        // Add 2 empty rows when society name changes
        rowsToAdd.add(['', '', '', ...List.filled(dates.length, '')]);
        rowsToAdd.add(['', '', '', ...List.filled(dates.length, '')]);
      }

      // Create the row for the current customer
      List<String> row = [];
      row.add(customer.societyName ?? '');
      row.add(customer.customerMobile ?? '');
      row.add(customer.flatNo ?? '');
      row.add(customer.customerName ?? '');
      row.add(
          '${DateFormat('yyyy-MM-dd').format(dateRange.start)} to ${DateFormat('yyyy-MM-dd').format(dateRange.end)}');

      row.add(''); // Spacer column

      for (var date in dates) {
        final scanRecords = await DBHelper.getDailyScans(date);
        final scanRecord = scanRecords.firstWhere(
          (record) => record['id'] == customer.id,
          orElse: () => <String, dynamic>{},
        );

        // ignore: unnecessary_null_comparison
        String status = (scanRecord != null && scanRecord['scanned'] == 'Yes')
            ? 'Yes'
            : 'No';
        row.add(status);
        row.add(''); // Spacer column
      }

      rowsToAdd.add(row);
      // Update the previous society name
      previousSocietyName = customer.societyName?.trim();
    }

// Append all rows to the sheet
    for (var row in rowsToAdd) {
      sheet.appendRow(row);
    }
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
    // Save Excel file
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
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    String filePath =
        '${directory.path}/scan_report_${formattedDate}_$count.xlsx';
    final file = File(filePath);
    await file.create(recursive: true);
    await file.writeAsBytes(excel.encode()!);

    await showDialog(
      context: context,
      builder: (_) => CustomValidationPopup(
        message: "Export successful.",
      ),
    );

    // Reset selections
    selectedSociety.value = null;
    selectedDateRange.value = null;
  }

  //----------------------

  Future<void> deleteScanDataByDateRange(context) async {
    // Insert test data to ensure there are records to delete
    // await DBHelper.insertTestDailyScans();
    selectedDateRange.value = null;

    // Show dialog for date range selection
    bool? confirmed = await Get.dialog<bool>(
      StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text("Delete Scan Data"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                icon: Icon(Icons.date_range, color: Colors.black87),
                label: Text(
                  selectedDateRange.value == null
                      ? "Select Date Range"
                      : "${DateFormat('yyyy-MM-dd').format(selectedDateRange.value!.start)} → ${DateFormat('yyyy-MM-dd').format(selectedDateRange.value!.end)}",
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
                onPressed: () async {
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: Colors.blue,
                          colorScheme: ColorScheme.light(primary: Colors.blue),
                          buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (range != null) {
                    setState(() {
                      selectedDateRange.value = range;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.buttoncolor,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Get.back(result: false),
              child: Text("Cancel"),
            ),
            SizedBox(width: 5),
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.buttoncolor,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Get.back(result: true),
              child: Text("Delete"),
            ),
          ],
        );
      }),
    );

    if (confirmed != true) return;

    // Ensure a date range is selected
    if (selectedDateRange.value == null) {
      await showDialog(
        context: context,
        builder: (_) => CustomValidationPopup(
          message: "Please select a date range to delete scan data.",
        ),
      );
      return;
    }

    // Format the dates for the query
    String startDate =
        DateFormat('yyyy-MM-dd').format(selectedDateRange.value!.start);
    String endDate =
        DateFormat('yyyy-MM-dd').format(selectedDateRange.value!.end);
    print('Selected date range: $startDate to $endDate');

    // Log all records in the daily_scans table before deletion
    final db = await DBHelper.database;
    final allRecords = await db.query('daily_scans');
    print(
        'All records in daily_scans table before deletion: ${allRecords.length}');
    for (var record in allRecords) {
      print('Record: $record');
    }

    // Log the records that match the date range before deletion
    final matchingRecords = await db.query(
      'daily_scans',
      where: 'DATE(scanDate) >= ? AND DATE(scanDate) <= ?',
      whereArgs: [startDate, endDate],
    );
    print('Records to be deleted: ${matchingRecords.length}');
    for (var record in matchingRecords) {
      print('Record: $record');
    }

    // Delete the scan data
    int deletedCount =
        await DBHelper.deleteDailyScansByDateRange(startDate, endDate);

    // Log all records in the daily_scans table after deletion
    final remainingRecords = await db.query('daily_scans');
    print(
        'All records in daily_scans table after deletion: ${remainingRecords.length}');
    for (var record in remainingRecords) {
      print('Record: $record');
    }

    // Show confirmation
    await showDialog(
      context: context,
      builder: (_) => CustomValidationPopup(
        message: "Successfully deleted $deletedCount scan records.",
      ),
    );

    // Reset selections
    selectedDateRange.value = null;
  }
}
