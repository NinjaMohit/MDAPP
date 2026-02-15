import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/export_data/import_export_data.dart';
import 'package:md_app/splash/splash_screen.dart';
import 'package:md_app/util/size_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await DBHelper.database;

  // Run only the first time
  final db = await DBHelper.database;
  final customers = await db.query('customers');
  if (customers.isEmpty) {
    await importCustomersFromExcel(); 
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(
        builder: (context, orientation) {
          //SizeConfig().init(constraints, orientation);
          //   SizeConfig().init(context);
          SizeConfig.initWithConstraints(constraints, orientation);

          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Local Login App',
            home: SplashScreen(),
          );
        },
      );
    });
  }
}
