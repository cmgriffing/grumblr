import 'package:flutter/material.dart';
import 'package:grumblr/components/app_showcase.dart';
import 'package:grumblr/services/state/onboarding.dart';
import 'package:grumblr/types/meal.dart';
import 'package:showcaseview/showcaseview.dart';

TextStyle textStyleWhiteTitleOverBG = TextStyle(
  fontSize: 24,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  shadows: [
    Shadow(
      color: Colors.black,
      blurRadius: 5,
    )
  ],
);

TextStyle textStyleWhiteTextOverBG = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  shadows: [
    Shadow(
      color: Colors.black,
      blurRadius: 3,
    )
  ],
);

class MealDetailsImage extends StatelessWidget {
  MealDetailsImage({this.meal, this.viewportConstraints});

  final Meal meal;
  final BoxConstraints viewportConstraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: viewportConstraints.maxWidth,
      height: viewportConstraints.maxHeight / 2,
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(meal.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: viewportConstraints.maxWidth,
            child: Text(
              meal.name,
              style: textStyleWhiteTitleOverBG,
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            width: viewportConstraints.maxWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShowcase(
                  showcaseKey: RxOnboardingState
                      .globalKeyMap[OnboardingStepParts.mealDetailsCuisine],
                  description: 'The main cuisine type is shown here.',
                  child: Text(
                    "FOO",
                    style: textStyleWhiteTextOverBG,
                  ),
                ),
                Row(
                  children: [
                    AppShowcase(
                      showcaseKey: RxOnboardingState.globalKeyMap[
                          OnboardingStepParts.mealDetailsIconsAllergies],
                      description:
                          'Use this to check for Allergens\n and tap it to go to that section.',
                      child: IconButton(
                        icon: Icon(Icons.report_problem),
                        color: Colors.white,
                        onPressed: () => {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
