import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadween/features/home/data/models/note_entity.dart';

import 'package:tadween/features/home/ui/views/note_item.dart';
import '../../logic/notes_cubit/notes_cubit.dart';
import '../widgets/add_note_bottom_sheet.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/notes_list_view.dart';
import '../../../../core/theme/color_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<NoteEntity> _searchedNotes = [];
  Timer? _debounce;

  @override
  void initState() {
    BlocProvider.of<NotesCubit>(context).fetchAllNotes();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    super.dispose();
  }

  void _addSearchedItemsToSearchedList(String searchedText) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = searchedText.toLowerCase();
      final cubitStateNotes =
          BlocProvider.of<NotesCubit>(context).notes ?? <NoteEntity>[];
      setState(() {
        _searchedNotes = cubitStateNotes
            .where(
              (n) =>
                  (n.title ?? '').toLowerCase().contains(query) ||
                  (n.subTitle ?? '').toLowerCase().contains(query),
            )
            .toList();
      });
    });
  }

  Widget _buildSearchResults() {
    if (_searchedNotes.isEmpty) {
      return Center(
        child: Text(
          'No results',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: _searchedNotes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return NoteItem(note: _searchedNotes[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotesCubit, NotesState>(
      listener: (context, state) {
        if (state is NotesSuccess && _isSearching) {
          _addSearchedItemsToSearchedList(_searchController.text);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton.small(
          backgroundColor: ColorManager.primaryBlueDark,
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              context: context,
              builder: (sheetContext) {
                return BlocProvider.value(
                  value: BlocProvider.of<NotesCubit>(context),
                  child: const AddNoteBottomSheet(),
                );
              },
            );
          },
          child: Icon(Icons.add, color: ColorManager.cardBg, size: 18.sp),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    if (_isSearching)
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchedNotes = [];
                            _isSearching = false;
                          });
                        },
                      ),
                    Expanded(
                      child: _isSearching
                          ? TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search notes...',
                                border: InputBorder.none,
                                suffixIcon: _searchController.text.isEmpty
                                    ? null
                                    : IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            _searchedNotes = [];
                                          });
                                        },
                                      ),
                              ),
                              onChanged: (v) {
                                _addSearchedItemsToSearchedList(v);
                                setState(() {});
                              },
                            )
                          : CustomAppBar(
                              title: 'Tadween',
                              icon: Icons.search,
                              onPressed: () {
                                setState(() {
                                  _isSearching = true;
                                });
                              },
                            ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isSearching ? _buildSearchResults() : NotesListView(),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }
}
