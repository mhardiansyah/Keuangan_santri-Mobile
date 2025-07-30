// ignore_for_file: unused_import

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sakusantri/app/modules/cart/controllers/cart_controller.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
