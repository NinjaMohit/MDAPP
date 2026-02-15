import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:md_app/database/qr_send.dart';
import 'package:md_app/global_var.dart';
import 'package:md_app/home/customer/customer_model.dart';
import 'package:md_app/model/histroymodel.dart';
import 'package:md_app/model/usermodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT,        
        isActive INTEGER,
        isAdmin INTEGER,
        createdAt TEXT,
        updatedAt TEXT
      )
      ''');
      await db.execute('''
  CREATE TABLE customers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    societyName TEXT,
    buildingName TEXT,
    flatNo TEXT,
    customerName TEXT,
    customerMobile TEXT,
    abbreviation TEXT,
    isActive INTEGER,
    qrData TEXT,
    createdAt TEXT,
    updatedAt TEXT
  )
''');
      await db.execute('''
      CREATE TABLE histroy (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerId INTEGER,
        createdById INTEGER,
        createdAt TEXT
      )
      ''');
      await db.execute('''
      CREATE TABLE daily_scans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerId INTEGER,
        createdById INTEGER,
        scanDate TEXT,
        scanned TEXT,
        createdAt TEXT,
        FOREIGN KEY (customerId) REFERENCES customers(id)
      )
    ''');

      await db.insert('users', {
        'username': 'admin',
        'password': 'admin123',
        'isActive': 1,
        'isAdmin': 1,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    });
  }

  static Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<UserModel?> loginUser(String username, String password) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (res.isNotEmpty) {
      return UserModel.fromMap(res.first);
    }
    return null;
  }

  static Future<int> registerUserAdmin({
    required String username,
    required String password,
    required int activeValue,
    required int adminValue,
  }) async {
    final db = await database;

    // Check if username exists
    final existingUser = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (existingUser.isNotEmpty) {
      print('Registration failed - Username already exists: $username');
      throw Exception('Username already exists');
    }

    final now = DateTime.now().toIso8601String();
    final userData = {
      'username': username,
      'password': password,
      'isActive': activeValue,
      'isAdmin': adminValue,
      'createdAt': now,
      'updatedAt': now,
    };

    // Print the data before insertion
    print('Attempting to register user with data:');
    print('Username: $username');
    print('Password: $password');
    print('isActive: active');
    print('isAdmin:admin');
    print('CreatedAt: $now');
    print('UpdatedAt: $now');

    // Insert and get the ID
    final id = await db.insert('users', userData);

    // Print confirmation after successful insertion
    print('User registered successfully with ID: $id');
    print('Full user data: ${userData.toString()}');

    return id;
  }

  static Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  static Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('users');

    return result.map((json) => UserModel.fromMap(json)).toList();
  }

  static Future<int> insertCustomer(CustomerModel customer) async {
    final db = await database;
    return await db.insert('customers', customer.toMap());
  }

  static Future<int> updateCustomer(CustomerModel customer) async {
    final db = await database;
    return await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  static Future<List<CustomerModel>> getAllCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('customers');
    return result.map((json) => CustomerModel.fromJson(json)).toList();
  }

  static Future<void> generateAndSaveQrForCustomer(int customerId) async {
    final db = await DBHelper.database;

    // Fetch the customer by ID
    final result = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [customerId],
    );

    if (result.isEmpty) {
      throw Exception("Customer with ID $customerId not found.");
    }

    final customer = CustomerModel.fromJson(result.first);

    final qrData = generateCustomerQrString(customer);

    await db.update(
      'customers',
      {'qrData': qrData},
      where: 'id = ?',
      whereArgs: [customerId],
    );
    final List<Map<String, dynamic>> result12 = await db.query('customers');

    for (var row in result12) {
      print('--- Customer Record ---');
      print('ID: ${row['id']}');
      print('Society Name: ${row['societyName']}');
      print('Building Name: ${row['buildingName']}');
      print('Flat No: ${row['flatNo']}');
      print('Customer Name: ${row['customerName']}');
      print('Mobile: ${row['customerMobile']}');
      print('Abbreviation: ${row['abbreviation']}');
      print('isActive: ${row['isActive']}');
      print('QR Data: ${row['qrData']}');
      print('Created At: ${row['createdAt']}');
      print('Updated At: ${row['updatedAt']}');
      print('-----------------------');
    }

    log('QR data saved successfully for customer ID: $customerId');
  }

  static Future<int> insertHistory(HistoryModel history) async {
    final db = await database;
    return await db.insert('histroy', history.toMap());
  }

  static Future<int> updateHistory(HistoryModel history) async {
    final db = await database;
    return await db.update(
      'histroy',
      history.toMap(),
      where: 'id = ?',
      whereArgs: [history.id],
    );
  }

  static Future<int> deleteHistory(int id) async {
    final db = await database;
    return await db.delete(
      'histroy',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<HistoryModel>> getAllHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('histroy');

    return result.map((json) => HistoryModel.fromMap(json)).toList();
  }

  // Insert or update a daily scan record
  static Future<void> insertDailyScan(
      int customerId, int userId, String scanDate, String scanned) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    final existing = await db.query(
      'daily_scans',
      where: 'customerId = ? AND scanDate = ?',
      whereArgs: [customerId, scanDate],
    );

    if (existing.isNotEmpty) {
      await db.update(
        'daily_scans',
        {'scanned': scanned, 'createdAt': now},
        where: 'customerId = ? AND scanDate = ?',
        whereArgs: [customerId, scanDate],
      );
    } else {
      await db.insert('daily_scans', {
        'customerId': customerId,
        "createdById": userId,
        'scanDate': scanDate,
        'scanned': scanned,
        'createdAt': now,
      });
    }
  }

  // Mark unscanned customers as 'No' for a specific date
  static Future<void> markUnscannedCustomers(String scanDate) async {
    final db = await database;
    final customers = await db.query(
      'customers',
      where: 'isActive = ?',
      whereArgs: [1],
    );

    for (var customer in customers) {
      final customerId = customer['id'] as int;
      final existing = await db.query(
        'daily_scans',
        where: 'customerId = ? AND scanDate = ?',
        whereArgs: [customerId, scanDate],
      );

      if (existing.isEmpty) {
        if (existing.isEmpty) {
          await db.insert('daily_scans', {
            'customerId': customerId,
            'createdById': userId, // 👈 insert createdById here
            'scanDate': scanDate,
            'scanned': 'No',
            'createdAt': DateTime.now().toIso8601String(),
          });
        }
      }
    }
  }

  // Get daily scan status for all customers on a specific date
  static Future<List<Map<String, dynamic>>> getDailyScans(
      String scanDate) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT c.id, c.customerName, c.societyName, c.buildingName, c.flatNo, 
             COALESCE(ds.scanned, 'No') as scanned
      FROM customers c
      LEFT JOIN daily_scans ds ON c.id = ds.customerId AND ds.scanDate = ?
      WHERE c.isActive = 1
    ''', [scanDate]);
  } // Delete daily scans within a date range

  static Future<int> deleteDailyScansByDateRange(
      String startDate, String endDate) async {
    final db = await database;
    return await db.delete(
      'daily_scans',
      where: 'DATE(scanDate) >= ? AND DATE(scanDate) <= ?',
      whereArgs: [startDate, endDate],
    );
  }

  static Future<List<Map<String, dynamic>>> getTodayScans() async {
    try {
      final db = await database;
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      return await db.rawQuery('''
      SELECT c.id, c.customerName, c.societyName, c.customerMobile, ds.scanned
      FROM customers c
      INNER JOIN daily_scans ds ON c.id = ds.customerId
      WHERE c.isActive = 1 AND date(ds.scanDate) = ? AND LOWER(ds.scanned) = 'yes'
      ORDER BY c.societyName, c.customerName
    ''', [today]);
    } catch (e) {
      print('Error fetching scans: $e');
      return [];
    }
  }





}
