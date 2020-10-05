import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

enum OnboardingSteps {
  homeSwiper,
  homeResults,
  mealDetails,
  homeSettings,
  finished,
}

enum OnboardingStepParts {
  // home swiper
  homeSwiperTab,
  homeSwiperSwipeRight,
  homeSwiperSwipeLeft,
  homeSwiperSwipeUp,
  homeSwiperSwipeDown,
  homeSwiperButtons,
  // home results
  homeResultsTab,
  homeResultsFavorites,
  homeResultsLiked,
  homeResultsLikedMeal,
  // meal details
  mealDetailsCuisine,
  mealDetailsIconsCost,
  mealDetailsIconsAllergies,
  mealDetailsAllergies,
  mealDetailsOrdering,
  // home settings
  homeSettingsTab,
  homeSettingsRadius,
  homeSettingsLocation,
  homeSettingsAllergies,
  homeSettingsCuisines,
  homeSettingsDiet,
  homeSettingsDelivery,
}

class RxOnboardingState extends GetxController {
  final hasDoneOnboarding = false.obs;
  final isShowingOnboarding = false.obs;
  final currentOnboardingStep = OnboardingSteps.homeSwiper.obs;

  factory RxOnboardingState() {
    return _instance;
  }

  shouldShowStep(OnboardingSteps step) {
    return stepOrderMap[step] >= stepOrderMap[currentOnboardingStep.value];
  }

  static Map stepOrderMap = Map.fromIterable(
    OnboardingSteps.values.asMap().entries.map(
          (stepEntry) => {
            "key": stepEntry.value,
            "value": stepEntry.key,
          },
        ),
    key: (stepMap) => stepMap["key"],
    value: (stepMap) => stepMap["value"],
  );

  static Map globalKeyMap = Map.fromIterable(
    OnboardingStepParts.values.map(
      (part) => {
        "key": part,
        "value": GlobalKey(),
      },
    ),
    key: (partMap) => partMap["key"],
    value: (partMap) => partMap["value"],
  );

  static Map showcaseSets = {
    OnboardingSteps.homeSwiper: [
      globalKeyMap[OnboardingStepParts.homeSwiperTab],
      globalKeyMap[OnboardingStepParts.homeSwiperSwipeRight],
      globalKeyMap[OnboardingStepParts.homeSwiperSwipeLeft],
      globalKeyMap[OnboardingStepParts.homeSwiperSwipeUp],
      globalKeyMap[OnboardingStepParts.homeSwiperSwipeDown],
      globalKeyMap[OnboardingStepParts.homeSwiperButtons],
    ],
    OnboardingSteps.homeResults: [
      globalKeyMap[OnboardingStepParts.homeResultsTab],
      globalKeyMap[OnboardingStepParts.homeResultsFavorites],
      globalKeyMap[OnboardingStepParts.homeResultsLiked],
      globalKeyMap[OnboardingStepParts.homeResultsLikedMeal],
    ],
    OnboardingSteps.mealDetails: [
      globalKeyMap[OnboardingStepParts.mealDetailsCuisine],
      // globalKeyMap[OnboardingStepParts.mealDetailsIconsCost],
      globalKeyMap[OnboardingStepParts.mealDetailsIconsAllergies],
      globalKeyMap[OnboardingStepParts.mealDetailsAllergies],
      // globalKeyMap[OnboardingStepParts.mealDetailsOrdering],
    ],
    OnboardingSteps.homeSettings: [
      globalKeyMap[OnboardingStepParts.homeSettingsTab],
      globalKeyMap[OnboardingStepParts.homeSettingsRadius],
      globalKeyMap[OnboardingStepParts.homeSettingsLocation],
      globalKeyMap[OnboardingStepParts.homeSettingsAllergies],
      globalKeyMap[OnboardingStepParts.homeSettingsCuisines],
      globalKeyMap[OnboardingStepParts.homeSettingsDiet],
      globalKeyMap[OnboardingStepParts.homeSettingsDelivery],
    ],
  };

  static final RxOnboardingState _instance =
      RxOnboardingState._privateConstructor();

  RxOnboardingState._privateConstructor();
}
