import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryEntity {
  int id;
  String name;
  String? date;

  CategoryEntity({this.id = 0, required this.name, this.date});
}
