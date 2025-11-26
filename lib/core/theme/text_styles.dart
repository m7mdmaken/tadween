import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_manager.dart';
import 'font_weight.dart';



class AppTextStyles {
  static TextStyle headline = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.lightGray,
  );

  static TextStyle subhead = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorManager.darkText,
  );

  static TextStyle body = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.darkText,
  );

  static TextStyle caption = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.light,
    color: ColorManager.lightGray,
  );

  static TextStyle button = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white,
  );

  static TextStyle accent = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorManager.primaryBlue,
  );

  static TextStyle bodyFromContext(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge?.merge(body) ?? body;
}
