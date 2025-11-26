import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/constants/constants.dart';
import 'core/helpers/shared_preferences_helper.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes_consts.dart';
import 'core/theme/color_manager.dart';

class Tadween extends StatelessWidget {
  const Tadween({super.key, required this.appRouter});
  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    String initialRouteValue;
    final bool seenOnboarding =
        SharedPrefsHelper.getData(key: kOnBoardingKey) ?? false;
    if (seenOnboarding) {
      initialRouteValue = RoutesConsts.notesView;
    } else {
      initialRouteValue = RoutesConsts.onBoardingView;
    }
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        onGenerateRoute: appRouter.onGenerateRoute,
        initialRoute: initialRouteValue,
        debugShowCheckedModeBanner: false,
        theme: ColorManager.darkTheme(),
        
      ),
    );
  }
}
