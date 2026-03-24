import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/login/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

//   variables
  final pageController = PageController();
  Rx<int> currentIndexPage = 0.obs;

// Update Current Index When Page Scroll
  void updatePageIndecator(index) => currentIndexPage.value= index;

// Jump to the Specific dot Selected Page
  void dotNavigationClick(index){
    currentIndexPage.value = index;
    pageController.jumpTo(index);
  }

  // Update Current Page Index & Jump to the Next Page
  void nextPage(){
    if(currentIndexPage.value==2){
      final storage = GetStorage();

      if(kDebugMode){
        print('==============GET STORAGE Next Button===================');
        print(storage.read('IsFirstTime'));
      }

      storage.write('IsFirstTime', false);

      if(kDebugMode){
        print('==============GET STORAGE Next Button===================');
        print(storage.read('IsFirstTime'));
      }
      Get.offAll(const LoginScreen());
    }else{
      int page = currentIndexPage.value + 1;
      pageController.jumpToPage(page);
    }
  }

  // Update Current Page Index & Jump to the Last Page
  void skipPage(index){
    currentIndexPage.value = 2;
    pageController.jumpToPage(2);
  }
}