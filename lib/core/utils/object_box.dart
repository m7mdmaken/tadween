import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../features/home/data/models/note_entity.dart';
import '../../features/home/data/models/category_entity.dart';
import '../../objectbox.g.dart';

class ObjectBoxService {
  late final Store _store;
  late final Box<NoteEntity> _noteBox;
  late final Box<CategoryEntity> _categoryBox;

  ObjectBoxService._create(this._store) {
    _noteBox = Box<NoteEntity>(_store);
    _categoryBox = Box<CategoryEntity>(_store);
  }

  static Future<ObjectBoxService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "obx-notes"));
    return ObjectBoxService._create(store);
  }

  

  
  int saveNote(NoteEntity note) {
    return _noteBox.put(note); 
  }

  
  List<NoteEntity> getAllNotes() {
    return _noteBox.getAll();
  }

  
  NoteEntity? getNote(int id) {
    return _noteBox.get(id);
  }

  
  bool deleteNote(int id) {
    return _noteBox.remove(id);
  }

  
  List<NoteEntity> getNotesByCategory(int categoryId) {
    return (_noteBox.query(NoteEntity_.categoryId.equals(categoryId)).build())
        .find();
  }

  Stream<List<NoteEntity>> watchNotesByCategory(int categoryId) {
    return _noteBox
        .query(NoteEntity_.categoryId.equals(categoryId))
        .watch(triggerImmediately: true)
        .map((q) => q.find());
  }

  
  List<NoteEntity> searchNotes(String query) {
    return (_noteBox
            .query(
              NoteEntity_.title.contains(query, caseSensitive: false) |
                  NoteEntity_.subTitle.contains(query, caseSensitive: false),
            )
            .build())
        .find();
  }

  
  Stream<List<NoteEntity>> watchAllNotes() {
    return _noteBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  

  int saveCategory(CategoryEntity category) {
    return _categoryBox.put(category);
  }

  List<CategoryEntity> getAllCategories() {
    return _categoryBox.getAll();
  }

  CategoryEntity? getCategory(int id) {
    return _categoryBox.get(id);
  }

  bool deleteCategory(int id) {
    return _categoryBox.remove(id);
  }

  void close() {
    _store.close();
  }
}
