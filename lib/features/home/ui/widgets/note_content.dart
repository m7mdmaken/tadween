import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadween/core/theme/color_manager.dart';
import 'package:tadween/core/theme/text_styles.dart';
import 'package:tadween/features/home/data/models/note_entity.dart';

class NoteContent extends StatelessWidget {
  const NoteContent({super.key, required this.note});
  final NoteEntity note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          note.title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.headline.copyWith(
            fontSize: 20.sp,
            color: ColorManager.darkText,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          note.subTitle ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.body.copyWith(
            fontSize: 14.sp,
            color: ColorManager.darkText.withValues(alpha: 0.64),
          ),
        ),
      ],
    );
  }
}
