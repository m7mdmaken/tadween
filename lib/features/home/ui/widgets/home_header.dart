import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tadween/features/home/logic/notes_cubit/notes_cubit.dart';
import 'package:tadween/features/home/ui/views/category_manager.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/color_manager.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.primaryBlue,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Notes',
                  style: AppTextStyles.headline.copyWith(
                    fontSize: 20.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  '$count items',
                  style: AppTextStyles.caption.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: IconButton(
              icon: const Icon(
                FontAwesomeIcons.folderPlus,
                color: Colors.white,
              ),
              onPressed: () async {
                final changed = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<NotesCubit>(context),
                      child: const CategoryManagerView(),
                    ),
                  ),
                );
                if (changed == true) {
                  try {
                    BlocProvider.of<NotesCubit>(context).fetchAllNotes();
                  } catch (_) {}
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
