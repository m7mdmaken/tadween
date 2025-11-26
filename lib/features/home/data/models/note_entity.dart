import 'package:objectbox/objectbox.dart';

@Entity()
class NoteEntity {
  int id;
  String? title;
  String? subTitle;
  String? date;
  int? color;
  int? categoryId;

  NoteEntity({
    this.id = 0,
    required this.title,
    required this.subTitle,
    required this.date,
    required this.color,
    this.categoryId,
  });
}
