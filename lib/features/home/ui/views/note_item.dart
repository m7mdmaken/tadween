import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadween/features/home/ui/widgets/leading_circle.dart';
import 'package:tadween/features/home/ui/widgets/note_content.dart';
import '../../data/models/note_entity.dart';
import '../../logic/notes_cubit/notes_cubit.dart';
import '../views/read_note_view.dart';
import '../widgets/edit_note_view.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/helpers/extentions.dart';
import '../widgets/home_styles.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({super.key, required this.note});

  final NoteEntity note;

  @override
  Widget build(BuildContext context) {
    final int rawColor = note.color ?? ColorManager.cardBg.toARGB32();
    final Color bgColor = Color(rawColor);
    return GestureDetector(
      onTap: () {
        context.push(
          BlocProvider.value(
            value: BlocProvider.of<NotesCubit>(context),
            child: ReadNoteView(note: note),
          ),
        );
      },
      onLongPress: () {
        context.push(
          BlocProvider.value(
            value: BlocProvider.of<NotesCubit>(context),
            child: EditNoteView(note: note),
          ),
        );
      },
      child: Container(
        decoration: cardDecoration(bgColor),
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            LeadingCircle(note: note),
            SizedBox(width: 12.w),
            Expanded(child: NoteContent(note: note)),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  note.date ?? '',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await BlocProvider.of<NotesCubit>(
                      context,
                    ).deleteNote(note.id);
                  },
                  icon: Icon(
                    Icons.delete_outline,
                    color: ColorManager.darkText,
                    size: 26.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
