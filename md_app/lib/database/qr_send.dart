import 'dart:convert';

import 'package:md_app/home/customer/customer_model.dart';

String generateCustomerQrString(CustomerModel customer) {
  return jsonEncode({
    'id': customer.id,
    'customerName': customer.customerName,
    'customerMobile': customer.customerMobile,
    'flatNo': customer.flatNo,
    'buildingName': customer.buildingName,
    'societyName': customer.societyName,
  });
}
