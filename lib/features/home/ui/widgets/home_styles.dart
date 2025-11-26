import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const double cardRadius = 16.0;

BoxDecoration cardDecoration(Color color) {
  return BoxDecoration(
    color: color.withAlpha(200),
    borderRadius: BorderRadius.circular(cardRadius.r),
    border: Border.all(color: Colors.black.withAlpha(255)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(200),
        blurRadius: 8,
        offset: Offset(0, 6),
      ),
    ],
  );
}

BoxDecoration solidCircleBackground(Color color) => BoxDecoration(
  color: color.withAlpha(255),
  shape: BoxShape.circle,
  boxShadow: [
    BoxShadow(color: color.withAlpha(40), blurRadius: 8, offset: Offset(0, 4)),
  ],
);
