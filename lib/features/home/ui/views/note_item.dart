import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/note_entity.dart';
import '../../logic/notes_cubit/notes_cubit.dart';
import '../widgets/edit_note_view.dart';
import '../../../../main.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/helpers/extentions.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({super.key, required this.note});

  final NoteEntity note;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          BlocProvider.value(
            value: BlocProvider.of<NotesCubit>(context),
            child: EditNoteView(note: note),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(note.color ?? ColorManager.cardBg.toARGB32()),
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.only(left: 16.w, top: 24.h, bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              title: Text(
                note.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headline.copyWith(
                  fontSize: 26.sp,
                  color: ColorManager.darkText,
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Text(
                  note.subTitle ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 18.sp,
                    color: ColorManager.darkText.withValues(alpha: 0.54),
                  ),
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  objectBox.deleteNote(note.id);

                  BlocProvider.of<NotesCubit>(context).fetchAllNotes();
                },
                icon: Icon(
                  Icons.delete,
                  color: ColorManager.darkText,
                  size: 30.sp,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                note.date ?? '',
                style: AppTextStyles.caption.copyWith(
                  color: ColorManager.darkText.withValues(alpha: 0.54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
