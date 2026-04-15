import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResponsiveHelper {
  static bool get isMobile => Get.width < 600;
  static bool get isTablet => Get.width >= 600 && Get.width < 1200;
  static bool get isDesktop => Get.width >= 1200;
  static bool get isLargeDesktop => Get.width >= 1600;
  
  static EdgeInsets get responsivePadding {
    if (isMobile) return const EdgeInsets.all(12);
    if (isTablet) return const EdgeInsets.all(20);
    return const EdgeInsets.all(24);
  }
  
  static double getFontSize(double size) {
    if (isMobile) return size;
    if (isTablet) return size * 1.2;
    return size * 1.4;
  }
  
  // Card specific responsive values
  static double getCardPadding() {
    if (isMobile) return 8;
    if (isTablet) return 12;
    return 16;
  }
  
  static double getIconSize() {
    if (isMobile) return 18;
    if (isTablet) return 22;
    return 24;
  }
  
  static double getIconContainerPadding() {
    if (isMobile) return 6;
    if (isTablet) return 8;
    return 10;
  }
  
  static double getTitleFontSize() {
    if (isMobile) return 12;
    if (isTablet) return 14;
    return 16;
  }
  
  static double getValueFontSize() {
    if (isMobile) return 18;
    if (isTablet) return 22;
    return 26;
  }
  
  static double getTrendFontSize() {
    if (isMobile) return 9;
    if (isTablet) return 10;
    return 11;
  }
  
  static double getSpacing() {
    if (isMobile) return 6;
    if (isTablet) return 8;
    return 12;
  }
  
  static double getBorderRadius() {
    if (isMobile) return 8;
    return 12;
  }
  
  static int getGridCrossAxisCount(int mobile, int tablet, int desktop) {
    if (isMobile) return mobile;
    if (isTablet) return tablet;
    return desktop;
  }
  
  static double getChildAspectRatio(double mobile, double tablet, double desktop) {
    if (isMobile) return mobile;
    if (isTablet) return tablet;
    return desktop;
  }
}