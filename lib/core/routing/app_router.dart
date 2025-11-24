import 'package:flutter/material.dart';
import 'package:tadween/core/routing/routes_consts.dart';
import 'package:tadween/features/on_boarding/ui/views/on_boarding.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesConsts.onBoardingView:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());
      case RoutesConsts.homeView:
        return MaterialPageRoute(builder: (_) => const SizedBox());
      default:
        return null;
    }
  }
}
