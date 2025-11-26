import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadween/core/theme/color_manager.dart';
import 'package:tadween/core/theme/text_styles.dart';
import 'package:tadween/features/home/data/models/note_entity.dart';
import 'package:tadween/features/home/ui/widgets/home_styles.dart';

class LeadingCircle extends StatelessWidget {
  const LeadingCircle({super.key, required this.note});
  final NoteEntity note;

  @override
  Widget build(BuildContext context) {
    final Color bg = Color(note.color ?? ColorManager.primaryBlue.toARGB32());
    final String letter = (note.title ?? 'N').isNotEmpty
        ? (note.title ?? 'N')[0]
        : 'N';
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: solidCircleBackground(bg),
      alignment: Alignment.center,
      child: Text(
        letter.toUpperCase(),
        style: AppTextStyles.headline.copyWith(
          fontSize: 22.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}
