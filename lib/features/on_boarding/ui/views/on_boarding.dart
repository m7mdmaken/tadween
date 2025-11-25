import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helpers/extentions.dart';
import '../../../../core/helpers/shared_preferences_helper.dart';
import '../../../../core/routing/routes_consts.dart';
import '../../../../core/widgets/app_text_button.dart';
import '../widgets/onboarding_page_view.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  late PageController pageController;
  var currentPage = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: OnboardingPageView(pageController: pageController)),
          SizedBox(height: 26),
          CustomDotsIndicator(currentPage: currentPage),
          SizedBox(height: 26),
          currentPage == 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AppTextButton(
                    buttonText: "Next",
                    textStyle: TextTheme.of(context).bodyMedium!,
                    onPressed: () {
                      setState(() {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      });
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AppTextButton(
                    buttonText: "Get Started",
                    textStyle: TextTheme.of(context).bodyMedium!,
                    onPressed: () {
                      SharedPrefsHelper.saveData(
                        key: kOnBoardingKey,
                        value: true,
                      );
                      context.pushReplacementNamed(RoutesConsts.notesView);
                    },
                  ),
                ),
          SizedBox(height: 26),
        ],
      ),
    );
  }
}

class CustomDotsIndicator extends StatelessWidget {
  const CustomDotsIndicator({super.key, required this.currentPage});
  final int currentPage;
  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      dotsCount: 2,
      position: currentPage.toDouble(),
      decorator: DotsDecorator(
        activeColor: Colors.black,
        color: const Color(0xFFC4C4C4),
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        spacing: const EdgeInsets.all(4.0),
      ),
    );
  }
}
