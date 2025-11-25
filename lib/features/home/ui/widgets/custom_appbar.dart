import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/color_manager.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
  });

  final String title;
  final IconData icon;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.headline.copyWith(fontSize: 28.sp)),
          Container(
            height: 46.h,
            width: 46.h,
            decoration: BoxDecoration(
              color: ColorManager.primaryBlueDark,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: IconButton(
                onPressed: onPressed,
                icon: Icon(icon, size: 28.sp, color: ColorManager.cardBg),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
