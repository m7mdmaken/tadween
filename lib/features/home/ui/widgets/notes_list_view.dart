import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/note_entity.dart';
import '../../data/models/category_entity.dart';
import '../../logic/notes_cubit/notes_cubit.dart';
import '../views/note_item.dart';
import 'home_header.dart';

class NotesListView extends StatelessWidget {
  const NotesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        final cubit = BlocProvider.of<NotesCubit>(context);
        final notes = cubit.notes ?? <NoteEntity>[];
        final categories = cubit.categories ?? <CategoryEntity>[];

        final categoryEntries = <Map<String, dynamic>>[];
        categoryEntries.add({
          'id': 0,
          'name': 'Uncategorized',
          'count': cubit.notesForCategory(0).length,
        });
        for (final c in categories) {
          categoryEntries.add({
            'id': c.id,
            'name': c.name,
            'count': cubit.notesForCategory(c.id).length,
          });
        }

        return Column(
          children: [
            HomeHeader(count: notes.length),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  
                  if (notes.isEmpty && categories.isEmpty) {
                    return Center(
                      child: Text(
                        'No notes yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  }

                  
                  
                  
                  if (isWide) {
                    if (notes.isNotEmpty) {
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 3,
                            ),
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          return NoteItem(note: notes[index]);
                        },
                      );
                    }

                    
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      itemCount: categoryEntries.length,
                      itemBuilder: (context, index) {
                        final entry = categoryEntries[index];
                        final cid = entry['id'] as int;
                        final name = entry['name'] as String;
                        final categoryNotes = cubit.notesForCategory(cid);

                        return ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(name),
                              if ((entry['count'] as int) > 0)
                                CircleAvatar(
                                  radius: 12,
                                  child: Text(
                                    (entry['count'] as int).toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          children: categoryNotes.isEmpty
                              ? [
                                  const ListTile(
                                    title: Text('No notes in this folder'),
                                  ),
                                ]
                              : categoryNotes
                                    .map(
                                      (n) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: NoteItem(note: n),
                                      ),
                                    )
                                    .toList(),
                        );
                      },
                    );
                  }

                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    itemCount: categoryEntries.length,
                    itemBuilder: (context, index) {
                      final entry = categoryEntries[index];
                      final cid = entry['id'] as int;
                      final name = entry['name'] as String;
                      final categoryNotes = cubit.notesForCategory(cid);

                      return ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(name),
                            if ((entry['count'] as int) > 0)
                              CircleAvatar(
                                radius: 12,
                                child: Text(
                                  (entry['count'] as int).toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                        children: categoryNotes.isEmpty
                            ? [
                                const ListTile(
                                  title: Text('No notes in this folder'),
                                ),
                              ]
                            : categoryNotes
                                  .map(
                                    (n) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: NoteItem(note: n),
                                    ),
                                  )
                                  .toList(),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
