import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/constants/constants.dart';
import '../../logic/add_note_cubit/add_note_cubit.dart';

class ColorItem extends StatelessWidget {
  const ColorItem({super.key, required this.isActive, required this.color});

  final bool isActive;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return isActive
        ? CircleAvatar(
            radius: 38.r,
            backgroundColor: Colors.white,
            child: CircleAvatar(radius: 34.r, backgroundColor: color),
          )
        : CircleAvatar(radius: 38.r, backgroundColor: color);
  }
}

class ColorsListView extends StatefulWidget {
  const ColorsListView({super.key});

  @override
  State<ColorsListView> createState() => _ColorsListViewState();
}

class _ColorsListViewState extends State<ColorsListView> {
  @override
  Widget build(BuildContext context) {
    final addNoteCubit = BlocProvider.of<AddNoteCubit>(context);

    return SizedBox(
      height: 76.h,
      child: IconButton(
        icon: Icon(Icons.palette, size: 48.r),
        onPressed: () => _openColorPicker(context, addNoteCubit),
        tooltip: 'Pick note color',
      ),
    );
  }

  void _openColorPicker(BuildContext context, AddNoteCubit addNoteCubit) {
    final initialColor = addNoteCubit.color;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            'Choose color',
            style: AppTextStyles.subhead.copyWith(
              fontSize: 16.sp,
              color: ColorManager.darkText,
            ),
          ),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: initialColor,
              onColorChanged: (color) {
                addNoteCubit.setColor(color.toARGB32());
                Navigator.of(ctx).pop();
              },

              availableColors: kColors,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancel',
                style: AppTextStyles.body.copyWith(
                  fontSize: 14.sp,
                  color: ColorManager.primaryBlueDark,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
