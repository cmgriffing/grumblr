import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:get/get.dart';
import 'package:grumblr/components/app_showcase.dart';
import 'package:grumblr/pages/home/settings.dart';
import 'package:grumblr/pages/home/swiper.dart';
import 'package:grumblr/pages/home/results.dart';
import 'package:badges/badges.dart';
import 'package:grumblr/services/state/onboarding.dart';
import 'package:grumblr/services/state/results.dart';
import 'package:grumblr/services/state/user_settings.dart';
import 'package:showcaseview/showcaseview.dart';

const Map TabNames = {"settings": 0, "swiper": 1, "results": 2};

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  RxUserSettings userSettings = RxUserSettings();
  RxSwipeResults swipeResults = RxSwipeResults();
  CardController cardController = CardController();
  TabController tabController;

  ScrollController scrollController = ScrollController();

  int initialTab = 0;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 1, length: 3, vsync: this);

    String activeTabName = Get.parameters['activeTab'];
    this.initialTab = TabNames[activeTabName];
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: () {
        if (RxOnboardingState().currentOnboardingStep.value ==
            OnboardingSteps.homeSwiper) {
          tabController.animateTo(2, duration: Duration(seconds: 0));
          RxOnboardingState().currentOnboardingStep.value =
              OnboardingSteps.homeResults;
        } else if (RxOnboardingState().currentOnboardingStep.value ==
            OnboardingSteps.homeResults) {
          Get.toNamed('/meal/m123');
          RxOnboardingState().currentOnboardingStep.value =
              OnboardingSteps.mealDetails;
        } else if (RxOnboardingState().currentOnboardingStep.value ==
            OnboardingSteps.homeSettings) {
          RxOnboardingState().currentOnboardingStep.value =
              OnboardingSteps.finished;
        }
      },
      onComplete: (index, globalKey) {
        if (globalKey ==
            RxOnboardingState
                .globalKeyMap[OnboardingStepParts.homeSwiperSwipeRight]) {
          cardController.triggerRight();
        }

        if (globalKey ==
            RxOnboardingState
                .globalKeyMap[OnboardingStepParts.homeSwiperSwipeLeft]) {
          cardController.triggerLeft();
        }

        if (globalKey ==
            RxOnboardingState
                .globalKeyMap[OnboardingStepParts.homeSwiperSwipeUp]) {
          cardController.triggerUp();
        }

        if (globalKey ==
            RxOnboardingState
                .globalKeyMap[OnboardingStepParts.homeSwiperSwipeDown]) {
          cardController.triggerDown();
        }

        if (globalKey ==
            RxOnboardingState
                .globalKeyMap[OnboardingStepParts.homeSettingsCuisines]) {
          scrollController.jumpTo(100);
        }

        if (globalKey ==
            RxOnboardingState
                .globalKeyMap[OnboardingStepParts.homeSettingsDiet]) {
          scrollController.animateTo(1300,
              duration: Duration(milliseconds: 50), curve: Curves.linear);
        }
      },
      builder: Builder(builder: (context) {
        if (RxOnboardingState().shouldShowStep(OnboardingSteps.homeSwiper)) {
          var keys = RxOnboardingState.showcaseSets[OnboardingSteps.homeSwiper];
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => ShowCaseWidget.of(context).startShowCase([...keys]),
          );
        } else if (RxOnboardingState()
            .shouldShowStep(OnboardingSteps.homeSettings)) {
          tabController.animateTo(0);
        }

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 48,
            bottom: TabBar(
              controller: tabController,
              tabs: [
                Tab(
                  icon: AppShowcase(
                      showcaseKey: RxOnboardingState
                          .globalKeyMap[OnboardingStepParts.homeSettingsTab],
                      description: 'Use this tab to edit Settings.',
                      child: Icon(Icons.settings)),
                ),
                Tab(
                  icon: AppShowcase(
                    showcaseKey: RxOnboardingState
                        .globalKeyMap[OnboardingStepParts.homeSwiperTab],
                    description: 'This is where the swiping happens.',
                    child: Icon(Icons.restaurant_menu, size: 42),
                  ),
                ),
                Tab(
                  icon: AppShowcase(
                    showcaseKey: RxOnboardingState
                        .globalKeyMap[OnboardingStepParts.homeResultsTab],
                    description: 'Go check out your swipe results.',
                    child: Badge(
                      badgeContent: Obx(
                        () => Text(
                          "${swipeResults.likedMeals.value.length + swipeResults.favoritedMeals.value.length}",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      child: Icon(Icons.favorite),
                      badgeColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              HomeSettingsView(
                  scrollController: scrollController,
                  buildHook: () {
                    if (RxOnboardingState()
                        .shouldShowStep(OnboardingSteps.homeSettings)) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => ShowCaseWidget.of(context).startShowCase(
                          [
                            ...RxOnboardingState
                                .showcaseSets[OnboardingSteps.homeSettings]
                          ],
                        ),
                      );
                    }
                  }),
              HomeSwiperView(controller: cardController),
              HomeResultsView(buildHook: () {
                if (RxOnboardingState()
                    .shouldShowStep(OnboardingSteps.homeResults)) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => ShowCaseWidget.of(context).startShowCase(
                      [
                        ...RxOnboardingState
                            .showcaseSets[OnboardingSteps.homeResults]
                      ],
                    ),
                  );
                }
              }),
            ],
          ),
        );
      }),
    );
  }
}
