import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/note_entity.dart';
import '../../data/models/category_entity.dart';
import '../../../../main.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());

  List<NoteEntity>? notes;
  List<CategoryEntity>? categories;
  Map<int, List<NoteEntity>> notesByCategory = {};

  void fetchAllNotes() {
    notes = objectBox.getAllNotes();
    categories = objectBox.getAllCategories();

    
    notesByCategory.clear();
    notesByCategory[0] = [];
    if (notes != null) {
      for (final n in notes!) {
        final cid = n.categoryId ?? 0;
        notesByCategory.putIfAbsent(cid, () => []);
        notesByCategory[cid]!.add(n);
      }
    }

    emit(NotesSuccess(notes: notes));
  }

  List<NoteEntity> notesForCategory(int categoryId) {
    return notesByCategory[categoryId] ?? [];
  }

  
  
  
  Future<void> deleteNote(int id) async {
    try {
      objectBox.deleteNote(id);
    } catch (_) {
      
    }
    fetchAllNotes();
  }
}
