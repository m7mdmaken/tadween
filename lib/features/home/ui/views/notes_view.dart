import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../logic/notes_cubit/notes_cubit.dart';
import '../widgets/add_note_bottom_sheet.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/notes_list_view.dart';
import '../../../../core/theme/color_manager.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  void initState() {
    BlocProvider.of<NotesCubit>(context).fetchAllNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            context: context,
            builder: (sheetContext) {
              return BlocProvider.value(
                value: BlocProvider.of<NotesCubit>(context),
                child: const AddNoteBottomSheet(),
              );
            },
          );
        },
        child: Icon(Icons.add, color: ColorManager.cardBg, size: 24.sp),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              CustomAppBar(title: 'Notes', icon: Icons.search),
              Expanded(child: NotesListView()),
            ],
          ),
        ),
      ),
    );
  }
}
