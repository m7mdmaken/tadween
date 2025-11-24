import 'package:flutter/material.dart';

import 'package:tadween/core/theme/assets.gen.dart';
import 'package:tadween/features/on_boarding/ui/widgets/page_view_item.dart';

class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({super.key, required this.pageController});
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    // final localizations = AppLocalizations.of(context)!;

    return PageView(
      controller: pageController,
      children: [
        PageViewItem(
          image: Assets.svgs.onboarding1.svg(),
          title: 'Capture your thoughts instantly',
          subTitle:
              "Write notes effortlessly with a smooth feather-inspired flow. Every idea has its place",
        ),
        PageViewItem(
          image: Assets.svgs.onboarding2.svg(),
          title: "Keep everything organized",

          subTitle:
              "Folders, tags, and colors help you find your notes fast and keep your ideas structured",
        ),
      ],
    );
  }
}
