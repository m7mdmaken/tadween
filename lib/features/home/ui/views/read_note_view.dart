import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadween/core/helpers/extentions.dart';
import '../../data/models/note_entity.dart';
import '../../logic/notes_cubit/notes_cubit.dart';
import '../widgets/edit_note_view.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/color_manager.dart';

class ReadNoteView extends StatelessWidget {
  const ReadNoteView({super.key, required this.note});

  final NoteEntity note;

  @override
  Widget build(BuildContext context) {
    final Color bg = Color(note.color ?? ColorManager.cardBg.toARGB32());
    return Scaffold(
      backgroundColor: ColorManager.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: ColorManager.darkText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: ColorManager.darkText),
            onPressed: () {
              context.push(
                BlocProvider.value(
                  value: BlocProvider.of<NotesCubit>(context),
                  child: EditNoteView(note: note),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: bg.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      color: bg,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: bg.withAlpha(180),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      (note.title ?? 'N').isNotEmpty
                          ? (note.title ?? 'N')[0].toUpperCase()
                          : 'N',
                      style: AppTextStyles.headline.copyWith(
                        color: Colors.white,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.headline.copyWith(
                            fontSize: 20.sp,
                            color: ColorManager.darkText,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          note.date ?? '',
                          style: AppTextStyles.caption.copyWith(
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              note.subTitle ?? '',
              style: AppTextStyles.body.copyWith(
                fontSize: 16.sp,
                color: ColorManager.darkText.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
