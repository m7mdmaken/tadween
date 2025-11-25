import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../features/home/data/models/note_entity.dart';
import '../../objectbox.g.dart';

class ObjectBoxService {
  late final Store _store;
  late final Box<NoteEntity> _noteBox;

  ObjectBoxService._create(this._store) {
    _noteBox = Box<NoteEntity>(_store);
  }

  static Future<ObjectBoxService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "obx-notes"));
    return ObjectBoxService._create(store);
  }

  // CRUD Operations

  // Create or Update
  int saveNote(NoteEntity note) {
    return _noteBox.put(note); // Returns the ID
  }

  // Read all
  List<NoteEntity> getAllNotes() {
    return _noteBox.getAll();
  }

  // Read one
  NoteEntity? getNote(int id) {
    return _noteBox.get(id);
  }

  // Delete
  bool deleteNote(int id) {
    return _noteBox.remove(id);
  }

  // Query examples
  List<NoteEntity> searchNotes(String query) {
    return (_noteBox
            .query(
              NoteEntity_.title.contains(query, caseSensitive: false) |
                  NoteEntity_.subTitle.contains(query, caseSensitive: false),
            )
            .build())
        .find();
  }

  // List<NoteEntity> getNotesOrderedByDate() {
  //   return (_noteBox.query()
  //         ..order(NoteEntity_.createdAt, flags: Order.descending))
  //       .build()
  //       .find();
  // }

  // Stream for real-time updates
  Stream<List<NoteEntity>> watchAllNotes() {
    return _noteBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  void close() {
    _store.close();
  }
}
