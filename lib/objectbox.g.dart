







import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; 
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'features/home/data/models/category_entity.dart';
import 'features/home/data/models/note_entity.dart';

export 'package:objectbox/objectbox.dart'; 

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
    id: const obx_int.IdUid(1, 8670265835077875909),
    name: 'NoteEntity',
    lastPropertyId: const obx_int.IdUid(6, 1186615201072275347),
    flags: 0,
    properties: <obx_int.ModelProperty>[
      obx_int.ModelProperty(
        id: const obx_int.IdUid(1, 3305555215050535686),
        name: 'id',
        type: 6,
        flags: 1,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(2, 2968653635583261959),
        name: 'title',
        type: 9,
        flags: 0,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(3, 558905368823607960),
        name: 'subTitle',
        type: 9,
        flags: 0,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(4, 9043055839402400810),
        name: 'date',
        type: 9,
        flags: 0,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(5, 4167106417597252623),
        name: 'color',
        type: 6,
        flags: 0,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(6, 1186615201072275347),
        name: 'categoryId',
        type: 6,
        flags: 0,
      ),
    ],
    relations: <obx_int.ModelRelation>[],
    backlinks: <obx_int.ModelBacklink>[],
  ),
  obx_int.ModelEntity(
    id: const obx_int.IdUid(2, 148603666884733238),
    name: 'CategoryEntity',
    lastPropertyId: const obx_int.IdUid(3, 5779279869173763551),
    flags: 0,
    properties: <obx_int.ModelProperty>[
      obx_int.ModelProperty(
        id: const obx_int.IdUid(1, 6698199857899115312),
        name: 'id',
        type: 6,
        flags: 1,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(2, 3294954880892091696),
        name: 'name',
        type: 9,
        flags: 0,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(3, 5779279869173763551),
        name: 'date',
        type: 9,
        flags: 0,
      ),
    ],
    relations: <obx_int.ModelRelation>[],
    backlinks: <obx_int.ModelBacklink>[],
  ),
];












Future<obx.Store> openStore({
  String? directory,
  int? maxDBSizeInKB,
  int? maxDataSizeInKB,
  int? fileMode,
  int? maxReaders,
  bool queriesCaseSensitiveDefault = true,
  String? macosApplicationGroup,
}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(
    getObjectBoxModel(),
    directory: directory ?? (await defaultStoreDirectory()).path,
    maxDBSizeInKB: maxDBSizeInKB,
    maxDataSizeInKB: maxDataSizeInKB,
    fileMode: fileMode,
    maxReaders: maxReaders,
    queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
    macosApplicationGroup: macosApplicationGroup,
  );
}



obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
    entities: _entities,
    lastEntityId: const obx_int.IdUid(2, 148603666884733238),
    lastIndexId: const obx_int.IdUid(0, 0),
    lastRelationId: const obx_int.IdUid(0, 0),
    lastSequenceId: const obx_int.IdUid(0, 0),
    retiredEntityUids: const [],
    retiredIndexUids: const [],
    retiredPropertyUids: const [],
    retiredRelationUids: const [],
    modelVersion: 5,
    modelVersionParserMinimum: 5,
    version: 1,
  );

  final bindings = <Type, obx_int.EntityDefinition>{
    NoteEntity: obx_int.EntityDefinition<NoteEntity>(
      model: _entities[0],
      toOneRelations: (NoteEntity object) => [],
      toManyRelations: (NoteEntity object) => {},
      getId: (NoteEntity object) => object.id,
      setId: (NoteEntity object, int id) {
        object.id = id;
      },
      objectToFB: (NoteEntity object, fb.Builder fbb) {
        final titleOffset = object.title == null
            ? null
            : fbb.writeString(object.title!);
        final subTitleOffset = object.subTitle == null
            ? null
            : fbb.writeString(object.subTitle!);
        final dateOffset = object.date == null
            ? null
            : fbb.writeString(object.date!);
        fbb.startTable(7);
        fbb.addInt64(0, object.id);
        fbb.addOffset(1, titleOffset);
        fbb.addOffset(2, subTitleOffset);
        fbb.addOffset(3, dateOffset);
        fbb.addInt64(4, object.color);
        fbb.addInt64(5, object.categoryId);
        fbb.finish(fbb.endTable());
        return object.id;
      },
      objectFromFB: (obx.Store store, ByteData fbData) {
        final buffer = fb.BufferContext(fbData);
        final rootOffset = buffer.derefObject(0);
        final idParam = const fb.Int64Reader().vTableGet(
          buffer,
          rootOffset,
          4,
          0,
        );
        final titleParam = const fb.StringReader(
          asciiOptimization: true,
        ).vTableGetNullable(buffer, rootOffset, 6);
        final subTitleParam = const fb.StringReader(
          asciiOptimization: true,
        ).vTableGetNullable(buffer, rootOffset, 8);
        final dateParam = const fb.StringReader(
          asciiOptimization: true,
        ).vTableGetNullable(buffer, rootOffset, 10);
        final colorParam = const fb.Int64Reader().vTableGetNullable(
          buffer,
          rootOffset,
          12,
        );
        final categoryIdParam = const fb.Int64Reader().vTableGetNullable(
          buffer,
          rootOffset,
          14,
        );
        final object = NoteEntity(
          id: idParam,
          title: titleParam,
          subTitle: subTitleParam,
          date: dateParam,
          color: colorParam,
          categoryId: categoryIdParam,
        );

        return object;
      },
    ),
    CategoryEntity: obx_int.EntityDefinition<CategoryEntity>(
      model: _entities[1],
      toOneRelations: (CategoryEntity object) => [],
      toManyRelations: (CategoryEntity object) => {},
      getId: (CategoryEntity object) => object.id,
      setId: (CategoryEntity object, int id) {
        object.id = id;
      },
      objectToFB: (CategoryEntity object, fb.Builder fbb) {
        final nameOffset = fbb.writeString(object.name);
        final dateOffset = object.date == null
            ? null
            : fbb.writeString(object.date!);
        fbb.startTable(4);
        fbb.addInt64(0, object.id);
        fbb.addOffset(1, nameOffset);
        fbb.addOffset(2, dateOffset);
        fbb.finish(fbb.endTable());
        return object.id;
      },
      objectFromFB: (obx.Store store, ByteData fbData) {
        final buffer = fb.BufferContext(fbData);
        final rootOffset = buffer.derefObject(0);
        final idParam = const fb.Int64Reader().vTableGet(
          buffer,
          rootOffset,
          4,
          0,
        );
        final nameParam = const fb.StringReader(
          asciiOptimization: true,
        ).vTableGet(buffer, rootOffset, 6, '');
        final dateParam = const fb.StringReader(
          asciiOptimization: true,
        ).vTableGetNullable(buffer, rootOffset, 8);
        final object = CategoryEntity(
          id: idParam,
          name: nameParam,
          date: dateParam,
        );

        return object;
      },
    ),
  };

  return obx_int.ModelDefinition(model, bindings);
}


class NoteEntity_ {
  
  static final id = obx.QueryIntegerProperty<NoteEntity>(
    _entities[0].properties[0],
  );

  
  static final title = obx.QueryStringProperty<NoteEntity>(
    _entities[0].properties[1],
  );

  
  static final subTitle = obx.QueryStringProperty<NoteEntity>(
    _entities[0].properties[2],
  );

  
  static final date = obx.QueryStringProperty<NoteEntity>(
    _entities[0].properties[3],
  );

  
  static final color = obx.QueryIntegerProperty<NoteEntity>(
    _entities[0].properties[4],
  );

  
  static final categoryId = obx.QueryIntegerProperty<NoteEntity>(
    _entities[0].properties[5],
  );
}


class CategoryEntity_ {
  
  static final id = obx.QueryIntegerProperty<CategoryEntity>(
    _entities[1].properties[0],
  );

  
  static final name = obx.QueryStringProperty<CategoryEntity>(
    _entities[1].properties[1],
  );

  
  static final date = obx.QueryStringProperty<CategoryEntity>(
    _entities[1].properties[2],
  );
}
