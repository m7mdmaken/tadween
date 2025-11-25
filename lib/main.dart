import 'package:flutter/cupertino.dart';
import 'core/helpers/shared_preferences_helper.dart';
import 'core/utils/object_box.dart';
import 'tadween_app.dart';
import 'core/routing/app_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

late ObjectBoxService objectBox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBoxService.create();
  await ScreenUtil.ensureScreenSize();
  await SharedPrefsHelper.init();

  runApp(Tadween(appRouter: AppRouter()));
}
