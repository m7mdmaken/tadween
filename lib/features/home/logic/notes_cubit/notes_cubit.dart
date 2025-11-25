import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/note_entity.dart';
import '../../../../main.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());

  List<NoteEntity>? notes;
  void fetchAllNotes() {
    notes = objectBox.getAllNotes();
    emit(NotesSuccess(notes: notes));
  }
}
