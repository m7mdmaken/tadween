import 'package:flutter/cupertino.dart';
import 'package:tadween/core/helpers/shared_preferences_helper.dart';
import 'package:tadween/tadween_app.dart';
import 'package:tadween/core/routing/app_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await SharedPrefsHelper.init();
  runApp(Tadween(appRouter: AppRouter()));
}
