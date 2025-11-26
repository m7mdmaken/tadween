import 'package:flutter/material.dart';
import '../../data/models/category_entity.dart';
import '../../../../main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/notes_cubit/notes_cubit.dart';

class CategoryManagerView extends StatefulWidget {
  const CategoryManagerView({super.key});

  @override
  State<CategoryManagerView> createState() => _CategoryManagerViewState();
}

class _CategoryManagerViewState extends State<CategoryManagerView> {
  List<CategoryEntity> categories = [];
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    categories = objectBox.getAllCategories();
    setState(() {});
  }

  Future<void> _showCategoryDialog({CategoryEntity? existing}) async {
    final controller = TextEditingController(text: existing?.name ?? '');
    final formKey = GlobalKey<FormState>();
    final isEditing = existing != null;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Rename Category' : 'Create Category'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Category name'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter name' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final name = controller.text.trim();
                final now = DateTime.now();
                final date =
                    '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
                if (isEditing) {
                  final updated = CategoryEntity(
                    id: existing.id,
                    name: name,
                    date: existing.date,
                  );
                  objectBox.saveCategory(updated);
                } else {
                  final created = CategoryEntity(name: name, date: date);
                  objectBox.saveCategory(created);
                }

                _changed = true;
                Navigator.of(context).pop();
                _loadCategories();
                try {
                  BlocProvider.of<NotesCubit>(context).fetchAllNotes();
                } catch (_) {}
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(CategoryEntity cat) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete category'),
        content: Text(
          'Delete "${cat.name}"? Notes in this category will become uncategorized.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      objectBox.deleteCategory(cat.id);
      _changed = true;
      _loadCategories();
      try {
        BlocProvider.of<NotesCubit>(context).fetchAllNotes();
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(_changed),
        ),
        title: const Text('Manage Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: categories.isEmpty
            ? Center(
                child: Text(
                  'No categories yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
            : ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (_, _) => const Divider(),
                itemBuilder: (context, index) {
                  final c = categories[index];
                  return ListTile(
                    title: Text(c.name),
                    subtitle: c.date != null ? Text(c.date!) : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showCategoryDialog(existing: c),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(c),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
