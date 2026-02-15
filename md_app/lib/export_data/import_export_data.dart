import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/home/customer/customer_model.dart';

Future<void> importCustomersFromExcel() async {
  try {
    final byteData = await rootBundle.load('assets/export_all_tables_23-06-2025_1.xlsx');
    final bytes = byteData.buffer.asUint8List();
    final excel = Excel.decodeBytes(bytes);

    final sheet = excel.tables['Customers'];
    if (sheet == null) {
      print('❌ Sheet "Customers" not found.');
      return;
    }

    final rows = sheet.rows;
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      final customer = CustomerModel(
        societyName: row[1]?.value?.toString() ?? '',
        buildingName: row[2]?.value?.toString() ?? '',
        flatNo: row[3]?.value?.toString() ?? '',
        customerName: row[4]?.value?.toString() ?? '',
        customerMobile: row[5]?.value?.toString() ?? '',
        abbreviation: '',
        isActive: int.tryParse(row[6]?.value?.toString() ?? '1') ?? 1,
        qrData: row[7]?.value?.toString() ?? '',
        createdAt: row[8]?.value?.toString() ?? DateTime.now().toIso8601String(),
        updatedAt: row[9]?.value?.toString() ?? DateTime.now().toIso8601String(),
      );

      await DBHelper.insertCustomer(customer);
      print('Inserted: ${customer.customerName}');
    }

    print('✅ Customer data imported successfully.');
  } catch (e) {
    print('❌ Error importing customer data: $e');
  }
}
