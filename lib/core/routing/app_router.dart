import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadween/features/home/logic/add_note_cubit/add_note_cubit.dart';
import 'package:tadween/features/home/logic/notes_cubit/notes_cubit.dart';
import 'routes_consts.dart';
import '../../features/home/ui/views/home_view.dart';
import '../../features/on_boarding/ui/views/on_boarding.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesConsts.onBoardingView:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());
      case RoutesConsts.notesView:
        return _buildNotesViewWithCubit();
      case RoutesConsts.editNoteView:
        return _buildEditNoteViewWithCubits();
      default:
        return null;
    }
  }

  MaterialPageRoute<dynamic> _buildEditNoteViewWithCubits() {
    return MaterialPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AddNoteCubit()),
          BlocProvider(create: (context) => NotesCubit()..fetchAllNotes()),
        ],
        child: const HomeView(),
      ),
    );
  }

  MaterialPageRoute<dynamic> _buildNotesViewWithCubit() {
    return MaterialPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AddNoteCubit()),
          BlocProvider(create: (context) => NotesCubit()..fetchAllNotes()),
        ],
        child: const HomeView(),
      ),
    );
  }
}
