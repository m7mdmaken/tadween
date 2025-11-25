import 'package:flutter/material.dart';

import '../theme/color_manager.dart';

class GetStartedButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const GetStartedButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var primaryColor = ColorManager.primaryBlue;
    var accentColor = ColorManager.iconColor;

    const double borderRadius = 15;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: primaryColor,
          ),
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              alignment: Alignment.center,

              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
            onPressed: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                text,
                style: TextStyle(color: accentColor, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
