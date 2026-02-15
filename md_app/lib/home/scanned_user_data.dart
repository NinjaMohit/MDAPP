import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:md_app/component/app_text_widget.dart';
import 'package:md_app/database/db_helper.dart';
import 'package:md_app/export_data/export_scanned_user.dart';
import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';
import 'package:md_app/util/size_config.dart';

class TodayScansView extends StatelessWidget {
  const TodayScansView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          scrolledUnderElevation: 0.0,
          elevation: 0,
          toolbarHeight: 75,
          backgroundColor: AppColors.buttoncolor,
          foregroundColor: AppColors.buttoncolor,
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 2),
            child: AppTextWidget(
              text: "Today's Scanned Users",
              fontSize: AppTextSize.textSizeMediumL,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          leading: Padding(
            padding:
                EdgeInsets.only(top: SizeConfig.heightMultiplier * 2, left: 30),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: DBHelper.getTodayScans(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No users scanned today.',
                  style: TextStyle(color: AppColors.primaryText, fontSize: 16),
                ),
              );
            }

            // Group scans by societyName
            final scans = snapshot.data!;
            final groupedScans = <String, List<Map<String, dynamic>>>{};
            for (var scan in scans) {
              final societyName = scan['societyName'] ?? 'Unknown';
              groupedScans.putIfAbsent(societyName, () => []).add(scan);
            }

            final societyList = groupedScans.keys.toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Export Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        exportTodayScansToExcel(context);
                      } catch (e) {
                        print('Failed to export data: $e');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      alignment: Alignment.center,
                      height: 50,
                      width: 220,
                      decoration: BoxDecoration(
                        color: AppColors.buttoncolor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: AppTextWidget(
                        text: "Export Today Scanned Customer",
                        fontSize: AppTextSize.textSizeSmallm,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                // Scrollable List
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                    itemCount: societyList.length,
                    itemBuilder: (context, index) {
                      final societyName = societyList[index];
                      final societyScans = groupedScans[societyName]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10),
                            child: AppTextWidget(
                              text: societyName,
                              fontSize: AppTextSize.textSizeMedium,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          ...societyScans
                              .map((scan) => SizedBox(
                                    width: SizeConfig.widthMultiplier * 90,
                                    child: Card(
                                      color: AppColors.buttoncolor,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppTextWidget(
                                              text:
                                                  "Customer: ${scan['customerName'] ?? 'N/A'}",
                                              fontSize:
                                                  AppTextSize.textSizeSmalle,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primaryText,
                                            ),
                                            SizedBox(height: 5),
                                            AppTextWidget(
                                              text:
                                                  "Mobile: ${scan['customerMobile'] ?? 'N/A'}",
                                              fontSize:
                                                  AppTextSize.textSizeSmalle,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primaryText,
                                            ),
                                            SizedBox(height: 5),
                                            AppTextWidget(
                                              text:
                                                  "Scan Status: ${scan['scanned']}",
                                              fontSize:
                                                  AppTextSize.textSizeSmalle,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.green,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
