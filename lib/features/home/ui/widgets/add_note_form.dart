import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../data/models/note_entity.dart';
import '../../data/models/category_entity.dart';
import '../../logic/add_note_cubit/add_note_cubit.dart';
import 'colors_list_view.dart';
import 'custom_text_field.dart';
import '../../../../main.dart';

class AddNoteForm extends StatefulWidget {
  const AddNoteForm({super.key});

  @override
  State<AddNoteForm> createState() => _AddNoteFormState();
}

class _AddNoteFormState extends State<AddNoteForm> {
  final GlobalKey<FormState> formKey = GlobalKey();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  String? title, subTitle;
  int? selectedCategoryId;
  List<CategoryEntity> categories = [];

  @override
  void initState() {
    super.initState();

    categories = objectBox.getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        children: [
          SizedBox(height: 32.h),
          CustomTextField(
            onSaved: (value) {
              title = value;
            },
            hint: 'title',
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            onSaved: (value) {
              subTitle = value;
            },
            hint: 'content',
            maxLines: 5,
          ),
          SizedBox(height: 16.h),

          DropdownButtonFormField<int?>(
            initialValue: selectedCategoryId,
            decoration: const InputDecoration(labelText: 'Category'),
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('Uncategorized'),
              ),
              ...categories.map(
                (c) => DropdownMenuItem<int?>(value: c.id, child: Text(c.name)),
              ),
            ],
            onChanged: (v) {
              setState(() {
                selectedCategoryId = v;
              });
            },
            onSaved: (v) {
              selectedCategoryId = v;
            },
          ),
          SizedBox(height: 16.h),
          const ColorsListView(),
          SizedBox(height: 32.h),
          BlocBuilder<AddNoteCubit, AddNoteState>(
            builder: (context, state) {
              return CustomButton(
                isLoading: state is AddNoteLoading ? true : false,
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    var currentDate = DateTime.now();

                    var formattedCurrentDate = DateFormat(
                      'dd/MM/yyyy',
                    ).format(currentDate);

                    int? categoryId = selectedCategoryId;

                    var noteModel = NoteEntity(
                      title: title!,
                      subTitle: subTitle!,
                      date: formattedCurrentDate,
                      color: BlocProvider.of<AddNoteCubit>(
                        context,
                      ).color.toARGB32(),
                      categoryId: categoryId,
                    );

                    BlocProvider.of<AddNoteCubit>(context).addNote(noteModel);
                  } else {
                    autovalidateMode = AutovalidateMode.always;
                    setState(() {});
                  }
                },
              );
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
