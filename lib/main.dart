import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yt_ecommerce_admin_panel/app.dart';
import 'package:yt_ecommerce_admin_panel/bindings/general_bindings.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/orders/coupon_repository.dart';
import 'package:yt_ecommerce_admin_panel/firebase_options.dart';
import 'package:yt_ecommerce_admin_panel/utils/local_storage/storage_utility.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage first
  await GetStorage.init();
  
  // Initialize TLocalStorage
  await TLocalStorage.instance.initialize();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Initialize repositories
  Get.put(AuthenticationRepository(), permanent: true);
  Get.put(CouponRepository(), permanent: true);
  
  // Initialize General Bindings (this will initialize CartController)
  Get.put(GeneralBindings());
  
  runApp(const App());
}