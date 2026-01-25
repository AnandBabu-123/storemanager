import 'package:flutter/material.dart';

class Styles{
  static final primaryColor= Color(0xFF000000);
  static final secondaryColor= Color(0xFF5E5D5D);
  static final thirdColor=Color(0x665E5D5D);
  static final primaryTextColor= Color(0xFF000000);
  static final secondaryTextColor= Color(0x665E5D5D);
  static final whiteTextColor= Color(0xffffffff);
  static final backgroundPrimaryColor= Color(0xFF99CAFF);
  static final backgroundSecondaryColor= Color(0x1A007BFF);
  static final lightBackgroundPrimaryColor= Color(0xFFDAE9FF);
  static final buttonPrimaryTextColor= Color(0xffffffff);
  static final buttonSecondaryTextColor= Color(0xffffffff);
  static final buttonBackgroundColor= Color(0xff007BFF);
  static final coff_white = Color(0x66F5F5F5);
  static final dark_black =Color(0xff1A1A1A);
  static final backgroundColor = Color(0xFF007BFF);
  static final primaryblackColor =Color(0xFF121212);// Applying color
  static final backgroundWhiteColor = Color(0xffffffff);
  static final light_greenColor = Color(0xff2BBE9B);
  static final light_orangeColor = Color(0xffF7931E);
  static final light_goldColor =Color(0xffDEC364);
  static final light_blueColor=Color(0xff1C2F56);
  static final light_darkGreenColor=Color(0xff279A96);
  static final light_bluedarkColor=Color(0xff09244C);
  static final redColor=Color(0xffFF0000);
  static final light_yellowColor=Color(0xffF1C40F);
  static final cyanColor = Color(0xff00FFFF);
  static final dark_blueColor =Color(0xff1a43bf);
  static final light_violetColor=Color(0xff7F00FF);
  static final lightweight_grayColor =Color(0xEEEEEE);
  /// Font Family
  static String fontFamilyRobotoBold = "Roboto-Bold";
  static String fontFamilyRobotoMedium = "Roboto-Light";
  static String fontFamilyMulishBold   ="Mulish-Bold";
  static String fontFamilyMulishMedium = "Mulish-Light";


  static textStyle08(var color, var fontFamily) {
    return TextStyle(
      color: color,
      fontFamily: fontFamily,
      fontSize: 08, // Incorrect: should be 8, not 08
    );
  }

  static  textStyle10(var color,var fontFamily){
    return  TextStyle(
        color: color, fontFamily: fontFamily,fontSize: 10);
  }
  static  textStyle12(var color,var fontFamily){
    return  TextStyle(
        color: color, fontFamily: fontFamily,fontSize: 12);
  }
  static  textStyle14(var color,var fontFamily){
    return  TextStyle(
        color: color, fontFamily: fontFamily,fontSize: 14);
  }
  static  textStyle16(var color,var fontFamily){
    return  TextStyle(
        color: color, fontFamily: fontFamily,fontSize: 16);
  }
  static  textStyle18(var color,var fontFamily){
    return TextStyle(
        color: color, fontFamily: fontFamily,fontSize: 18);
  }
  static  textStyle20(var color,var fontFamily){
    return  TextStyle(
        color: color, fontFamily: fontFamily,fontSize: 20);
  }
  static  textStyle24(var color,var fontFamily){
    return  TextStyle(
        color: color, fontFamily: fontFamily,fontSize: 24);
  }

  static  textStyle28(var color,var fontFamily){
    return   TextStyle(
        color: color, fontFamily: fontFamily,fontSize: 28);
  }
  static BoxDecoration boxDecoration = BoxDecoration(
      color: const Color(0XFFffffff),
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.19),
            offset: const Offset(0, 2),
            blurRadius: 4)
      ]);
  static BoxDecoration borderBoxDecoration = BoxDecoration(
      color: Colors.white,
      border: Border.all(width: 0.5,
          color: Styles.thirdColor),
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.19),
            offset: const Offset(0, 2),
            blurRadius: 4)
      ]);
}