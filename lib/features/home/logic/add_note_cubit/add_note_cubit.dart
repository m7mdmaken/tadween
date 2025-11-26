import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/note_entity.dart';
import '../../../../main.dart';

part 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit() : super(AddNoteInitial());

  
  Color color = const Color(0xffAC3931);

  
  
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
