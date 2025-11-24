import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadween/core/constants/constants.dart';
import 'package:tadween/core/helpers/shared_preferences_helper.dart';
import 'package:tadween/core/routing/app_router.dart';
import 'package:tadween/core/routing/routes_consts.dart';
import 'package:tadween/core/theme/color_manager.dart';

class Tadween extends StatelessWidget {
  const Tadween({super.key, required this.appRouter});
  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    String initialRouteValue;
    final bool seenOnboarding =
        SharedPrefsHelper.getData(key: kOnBoardingKey) ?? false;
    if (seenOnboarding) {
      initialRouteValue = RoutesConsts.homeView;
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
        darkTheme: ColorManager.darkTheme(),
        theme: ColorManager.lightTheme(),
      ),
    );
  }
}
