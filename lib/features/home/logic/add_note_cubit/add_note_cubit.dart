import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/note_entity.dart';
import '../../../../main.dart';

part 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit() : super(AddNoteInitial());

  // Holds the currently selected color for the AddNote flow.
  Color color = const Color(0xffAC3931);

  // Minimal setter used by the UI (color picker dialog) to update the cubit's color.
  // Emits AddNoteInitial to allow UI listeners (BlocBuilder) to rebuild if needed.
  void setColor(int colorValue) {
    color = Color(colorValue);
    emit(AddNoteInitial());
  }

  void addNote(NoteEntity note) async {
    note.color = color.toARGB32();
    emit(AddNoteLoading());
    try {
      objectBox.saveNote(note);
      emit(AddNoteSuccess());
    } catch (e) {
      emit(AddNoteFailure(e.toString()));
    }
  }
}
