import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:grumblr/components/app_showcase.dart';
import 'package:grumblr/components/meal/meal_allergies_list.dart';
import 'package:grumblr/components/meal/meal_restaurant_details.dart';
import 'package:grumblr/services/api/meals.dart';
import 'package:grumblr/services/state/onboarding.dart';
import 'package:grumblr/types/meal.dart';
import 'package:grumblr/components/meal/meal_details_image.dart';
import 'package:grumblr/types/meal_details.dart';
import 'package:showcaseview/showcaseview.dart';

class MealPage extends StatefulWidget {
  MealPage({Key key}) : super(key: key);

  final String title = 'Meal Details';

  @override
  _MealPageState createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  MealDetails mealDetails;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    String mealId = Get.parameters['mealId'];
    developer.log('mealId: $mealId');
    getMeal(mealId);
  }

  getMeal(mealId) async {
    MealDetails fetchedMealDetails =
        (await ApiMealService().getMealDetails(mealId)).mealDetails;

    setState(() {
      mealDetails = fetchedMealDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ShowCaseWidget(
        onFinish: () {
          RxOnboardingState().currentOnboardingStep.value =
              OnboardingSteps.homeSettings;
          Get.back();
        },
        onComplete: (index, globalKey) {},
        builder: Builder(builder: (context) {
          if (RxOnboardingState().currentOnboardingStep.value ==
              OnboardingSteps.mealDetails) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => ShowCaseWidget.of(context).startShowCase([
                ...RxOnboardingState.showcaseSets[OnboardingSteps.mealDetails]
              ]),
            );
          }

          return LayoutBuilder(
            builder: (context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        if (!mealDetails.meal.isNullOrBlank)
                          Column(
                            children: [
                              MealDetailsImage(
                                  meal: mealDetails.meal,
                                  viewportConstraints: viewportConstraints),
                              Container(
                                constraints: BoxConstraints(
                                    minHeight:
                                        viewportConstraints.maxHeight / 2),
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Text(mealDetails.meal.description),
                                    SizedBox(height: 20),
                                    if (mealDetails.meal.allergies.length > 0)
                                      AppShowcase(
                                        showcaseKey: RxOnboardingState.globalKeyMap[
                                            OnboardingStepParts
                                                .mealDetailsAllergies],
                                        description:
                                            'If a meal contains Allergens they will be listed here.',
                                        child: MealAllergiesList(
                                          allergies: mealDetails.meal.allergies,
                                          width: viewportConstraints.maxWidth,
                                        ),
                                      ),
                                    if (mealDetails.meal.allergies.length > 0)
                                      SizedBox(height: 20),
                                    Text(
                                      'Restaurant Info',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    MealRestaurantDetails(
                                      restaurant: mealDetails.restaurant,
                                      viewportConstraints: viewportConstraints,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        if (mealDetails.isNullOrBlank ||
                            mealDetails.meal.isNullOrBlank)
                          Flexible(child: Text('NO MEAL!')),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
