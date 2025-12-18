# Tadween 📝

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue)](https://flutter.dev) [![Dart](https://img.shields.io/badge/Dart-3.10+-00B4AB)](https://dart.dev) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Short description
-----------------
Tadween is a lightweight local note-taking Flutter app with onboarding, colored notes, categories and local persistence using ObjectBox. It uses Cubits from flutter_bloc for simple state management and SharedPreferences to persist onboarding state.

TODO: Replace this short description with your marketing description and app screenshots.

Quick links
-----------
- App entry: [`lib/main.dart`](lib/main.dart:1)  
- App widget: [`lib/tadween_app.dart`](lib/tadween_app.dart:1)  
- Local DB setup: [`lib/core/utils/object_box.dart`](lib/core/utils/object_box.dart:1)  
- Notes feature: [`lib/features/home/`](lib/features/home/)

Key features ✅
---------------
- Onboarding with page indicator and skip/next flow. (`OnBoarding`) — [`lib/features/on_boarding/`](lib/features/on_boarding/ui/views/on_boarding.dart:1)
- Add notes with title, subtitle, date, color and category. (`AddNoteForm`, `AddNoteCubit`) — [`lib/features/home/ui/widgets/add_note_form.dart`](lib/features/home/ui/widgets/add_note_form.dart:1)
- List / Update / Delete notes via `NotesCubit` and ObjectBox. — [`lib/features/home/logic/notes_cubit/notes_cubit.dart`](lib/features/home/logic/notes_cubit/notes_cubit.dart:1)
- Read note details screen. (`ReadNoteView`) — [`lib/features/home/ui/views/read_note_view.dart`](lib/features/home/ui/views/read_note_view.dart:1)
- Local persistence using ObjectBox (embedded DB). (`objectbox.g.dart`, `objectbox-model.json`) — [`lib/objectbox-model.json`](lib/objectbox-model.json:1)

Screenshots 📸
-------------
> TODO: Add screenshots (assets/screenshots/*.png)

Tech stack & Dependencies 🧩
---------------------------
From [`pubspec.yaml`](pubspec.yaml:1) (key dependencies and versions):
- flutter — SDK
- cupertino_icons: ^1.0.8 — iOS style icons
- flutter_native_splash: ^2.4.6 — native splash screen
- shared_preferences: ^2.5.3 — store onboarding flag
- flutter_secure_storage: ^9.2.4 — (available, not used in current code)
- flutter_bloc: ^9.1.1 — state management (Cubits)
- get_it: ^9.0.5 — dependency injection (present but not wired)
- intl: ^0.19.0 — localization utilities
- flutter_svg: ^2.0.9 — render SVG assets
- flutter_screenutil: ^5.9.0 — responsive sizing
- flutter_colorpicker: ^1.1.0 — color picker UI
- cached_network_image: ^3.3.1 — for network image caching (present but not used)
- dots_indicator: ^4.0.1 — onboarding page indicator
- shimmer, skeletonizer — visual placeholders
- hive, hive_flutter — included but not used at runtime (ObjectBox is used)
- objectbox: ^5.0.2 and objectbox_flutter_libs — active DB used in code
- build_runner, flutter_gen_runner, objectbox_generator — dev/build tools

Environment
-----------
- Dart SDK constraint: ^3.10.0 (see [`pubspec.yaml`](pubspec.yaml:21))  
- Flutter: compatible with Flutter SDKs that support Dart 3.10+ (run `flutter --version` to see your local version).

Architecture & Patterns 🏗️
-------------------------
- Feature-first structure: code is organized by feature modules under [`lib/features/`](lib/features/:1).
- State management: Cubit pattern from `flutter_bloc` (lightweight BLoC).
- Persistence layer: ObjectBox as local database (see [`lib/core/utils/object_box.dart`](lib/core/utils/object_box.dart:1)).
- Routing: central `AppRouter` using `onGenerateRoute` and route constants in [`lib/core/routing/routes_consts.dart`](lib/core/routing/routes_consts.dart:1).
- UI: Simple widget composition using Material3 theme via `ColorManager.darkTheme()` — [`lib/core/theme/color_manager.dart`](lib/core/theme/color_manager.dart:1).

Project structure (lib/)
------------------------
- lib/
  - `main.dart` — app bootstrap & ObjectBox init (`WidgetsFlutterBinding.ensureInitialized()` and `ObjectBoxService.create()`)
  - `tadween_app.dart` — root MaterialApp and initial route logic
  - core/
    - constants/ — app constants (`kOnBoardingKey`) [`lib/core/constants/constants.dart`](lib/core/constants/constants.dart:1)
    - helpers/ — shared preferences helper, bloc observer
    - routing/ — `app_router.dart`, `routes_consts.dart`
    - theme/ — `color_manager.dart`, `text_styles.dart`, generated assets (`assets.gen.dart`)
    - utils/ — `object_box.dart` (ObjectBox wrapper)
    - widgets/ — small reusable widgets and buttons
  - features/
    - on_boarding/ — UI and widgets for onboarding flow
    - home/ — main notes feature
      - data/models/ — `note_entity.dart`, `category_entity.dart`
      - logic/ — cubits `AddNoteCubit`, `NotesCubit` and states
      - ui/ — views and widgets (home view, add note form, note item, read note view, colors list, etc.)

Getting started — local dev 🧰
-----------------------------
Prerequisites
- Flutter SDK (compatible with Dart >= 3.10.0)
- Platform toolchains for Android / iOS if building to devices

Installation
1. Clone the repo
   ```bash
   git clone <repo-url>
   cd tadween
   ```
2. Install dependencies
   ```bash
   flutter pub get
   ```
3. Generate build artefacts (if you change ObjectBox model or assets)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Run the app
   ```bash
   flutter run
   ```

Environment setup & configuration
- No remote APIs or Firebase detected in the codebase. All data is local.
- Onboarding flag stored in SharedPreferences key `kOnBoardingKey` (`lib/core/constants/constants.dart`).
- ObjectBox database stored in app support directory (`getApplicationSupportDirectory()`) — see [`lib/core/utils/object_box.dart`](lib/core/utils/object_box.dart:1).

State Management 🔁
-------------------
- `flutter_bloc` Cubits (`AddNoteCubit`, `NotesCubit`) provide simple state flow:
  - `AddNoteCubit.addNote` persists note to ObjectBox and emits success.
  - `NotesCubit.getNotesFromDB()` loads notes from ObjectBox and emits `NotesLoaded`.
- There is a `SimpleBlocObserver` stub in `core/helpers/` (can be used for global logging).

Key code snippets ✂️
--------------------
Initialize ObjectBox (from [`lib/main.dart`](lib/main.dart:1)):
```dart
// dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBoxService.create();
  await ScreenUtil.ensureScreenSize();
  await SharedPrefsHelper.init();
  runApp(Tadween(appRouter: AppRouter()));
}
```

Add and fetch notes:
```dart
// dart
// Adding a note
final ent = NoteEntity(
  title: titleController.text,
  subTitle: subtitleController.text,
  date: DateTime.now().toString(),
  color: selectedColor,
);
objectBox.noteBox.put(ent);

// Fetching notes
final notes = objectBox.noteBox.getAll();
```

Notable implementation details / code observations 🔎
---------------------------------------------------
- ObjectBox is the chosen local DB and is wired in [`lib/core/utils/object_box.dart`](lib/core/utils/object_box.dart:1).
- Onboarding uses `SharedPreferences` flag `kOnBoardingKey` to decide initial route (`lib/tadween_app.dart`: lines 15-22).
- Color picker UI exists in `ColorsListView` and displays `AlertDialog` with `ColorPicker` but the selection callback is currently empty (`onColorChanged: (_)=>{}`) and does not update the `AddNoteForm`'s `selectedColor`. This is a small wiring bug / unfinished feature to fix.
- Routing: route constants available in [`lib/core/routing/routes_consts.dart`](lib/core/routing/routes_consts.dart:1) and `AppRouter` provides `MultiBlocProvider` wrappers for some routes. There are a couple of inconsistencies to check:
  - `NoteItem` uses `Navigator.pushNamed(context, 'READ_NOTE', arguments: {'id': entity.id})` (string literal) while there's no `'READ_NOTE'` constant in `RoutesConsts`. Consider standardizing route usage to avoid runtime routing issues.
- Some listed dependencies (e.g., `hive`, `flutter_secure_storage`, `cached_network_image`, `get_it`) are present in `pubspec.yaml` but are not actively used in the current codebase — consider removing or using them intentionally.

Future improvements ✨
--------------------
- Wire color picker to actually update `AddNoteForm.selectedColor`.
- Add an Edit note screen and proper edit flow (currently `editNoteView` route exists but no dedicated view).
- Improve DI using `get_it` and provide singletons (objectBox, cubits).
- Add unit & widget tests for Cubits and database logic.
- Add CI pipeline, code format checks and pre-commit hooks.
- Add localization using `intl` (strings currently hard-coded).
- Add user export/import or sync functionality (e.g., cloud backup).

Contributing 🤝
--------------
- Fork the repo, create a branch, open a PR with a clear description and link to issue (if any).
- Follow existing code style and run `flutter analyze` and `flutter test` before submitting.
- All PRs will be reviewed for tests and documentation.

License
-------
This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.

Contact
-------
TODO: Add your contact details here (email, twitter, LinkedIn).

Acknowledgements
----------------
Built with ❤️ using Flutter. Thanks to the authors of the packages listed in `pubspec.yaml`.

<!-- TODO: Add screenshots, app store links, and contact info -->