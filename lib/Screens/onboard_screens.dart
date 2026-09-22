import 'package:expenz/Screens/onboardings/page_1.dart';
import 'package:expenz/Screens/onboardings/shared_onboarding_widget.dart';
import 'package:expenz/data/onboard_data.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardScreens extends StatefulWidget {
  const OnboardScreens({super.key});

  @override
  State<OnboardScreens> createState() => _OnboardScreensState();
}

class _OnboardScreensState extends State<OnboardScreens> {
  bool isPageLoaded = false;
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    final onboardData = OnboardData();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: controller,
                    onPageChanged: (index) {
                      setState(() {
                        isPageLoaded = index == 3;
                      });
                    },
                    children: [
                      Page1(),
                      SharedOnboardingWidget(
                        imgUrl: onboardData.onboardList[0].imagePath,
                        title: onboardData.onboardList[0].title,
                        description: onboardData.onboardList[0].description,
                      ),
                      SharedOnboardingWidget(
                        imgUrl: onboardData.onboardList[1].imagePath,
                        title: onboardData.onboardList[1].title,
                        description: onboardData.onboardList[1].description,
                      ),
                      SharedOnboardingWidget(
                        imgUrl: onboardData.onboardList[2].imagePath,
                        title: onboardData.onboardList[2].title,
                        description: onboardData.onboardList[2].description,
                      ),
                    ],
                  ),
                  Container(
                    alignment: const Alignment(0, 0.7),
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 4,
                      effect: ExpandingDotsEffect(
                        activeDotColor: kMainColor,
                        dotColor: kLightGrey,
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 5,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 30,
                    child: !isPageLoaded
                        ? GestureDetector(
                            onTap: () {
                              final currentPage = controller.hasClients
                                  ? (controller.page ?? 0).toInt()
                                  : 0;
                              final nextPage = currentPage + 1;
                              if (nextPage < 4) {
                                controller.animateToPage(
                                  nextPage,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOutCubic,
                                );
                              }
                            },
                            child: CustomButton(
                              bgColor: kMainColor,
                              name: isPageLoaded ? "Get Started" : "Next",
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              context.go('/register');
                            },
                            child: CustomButton(
                              bgColor: kMainColor,
                              name: isPageLoaded ? "Get Started" : "Next",
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
