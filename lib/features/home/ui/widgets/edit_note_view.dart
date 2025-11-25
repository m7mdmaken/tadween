import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/note_entity.dart';
import '../../logic/notes_cubit/notes_cubit.dart';
import 'custom_appbar.dart';
import 'custom_text_field.dart';
import 'edit_note_colors_list_view.dart';
import '../../../../main.dart';

class EditNoteView extends StatefulWidget {
  const EditNoteView({super.key, required this.note});

  final NoteEntity note;

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  String? title, content;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            CustomAppBar(
              onPressed: () {
                widget.note.title = title ?? widget.note.title;
                widget.note.subTitle = content ?? widget.note.subTitle;
                objectBox.saveNote(widget.note);

                BlocProvider.of<NotesCubit>(context).fetchAllNotes();
                Navigator.pop(context);
              },
              title: 'Edit Note',
              icon: Icons.check,
            ),
            SizedBox(height: 50.h),
            CustomTextField(
              onChanged: (value) {
                title = value;
              },
              hint: widget.note.title ?? '',
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              onChanged: (value) {
                content = value;
              },
              hint: widget.note.subTitle ?? '',
              maxLines: 5,
            ),
            SizedBox(height: 16.h),
            EditNoteColorsList(note: widget.note),
          ],
        ),
      ),
    );
  }
}
