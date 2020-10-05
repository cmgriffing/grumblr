import 'dart:developer' as developer;
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grumblr/components/restaurant_meal_form.dart';
import 'package:grumblr/pages/home/settings.dart';
import 'package:grumblr/services/api/meals.dart';

class RestaurantEditMealPage extends StatefulWidget {
  RestaurantEditMealPage({Key key}) : super(key: key);

  final String title = 'Edit Meal';

  @override
  _RestaurantEditMealPageState createState() => _RestaurantEditMealPageState();
}

class _RestaurantEditMealPageState extends State<RestaurantEditMealPage> {
  RestaurantMealFormState formState = RestaurantMealFormState(
    fieldValidationMap: {
      FIELD_VALIDATION_KEY_NAME: false,
      FIELD_VALIDATION_KEY_DESCRIPTION: false,
      FIELD_VALIDATION_KEY_CUISINES: false,
    },
    name: null,
    selectedAllergyOptionTags: [],
    selectedCuisineOptionTags: [],
    description: null,
    image: null
  );

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    getMeal(Get.parameters['mealId']);
  }

  getMeal(String mealId) async {
    MealDetailsResponse response =
        await ApiMealService().getMealDetails(mealId);

    setState(() {
      formState = RestaurantMealFormState(
        fieldValidationMap: {
          FIELD_VALIDATION_KEY_NAME: false,
          FIELD_VALIDATION_KEY_DESCRIPTION: false,
          FIELD_VALIDATION_KEY_CUISINES: false,
        },
        name: response.mealDetails.meal.name,
        image: response.mealDetails.meal.imageUrl,
        selectedAllergyOptionTags: response.mealDetails.meal.allergies.map((allergy) => AllergyOptionTag(
          allergyOption: allergy
        )).toList(),
        description: response.mealDetails.meal.description,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    int requiredFieldCount = 0;
    int validFieldCount = 0;
    if (formState != null) {
      requiredFieldCount = formState.fieldValidationMap.keys.length;
      validFieldCount = formState.fieldValidationMap.entries
          .where((mapEntry) => mapEntry.value == true)
          .length;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
        builder: (context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: RestaurantMealForm(
                viewportConstraints: viewportConstraints,
                initialState: formState,
                changed: (RestaurantMealFormState changedState) {
                  developer.log('changed $changedState');
                  setState(() {
                    formState = changedState;
                  });
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$validFieldCount / $requiredFieldCount"),
            ElevatedButton(
              onPressed: validFieldCount == requiredFieldCount
                  ? () {
                      // do form save
                    }
                  : null,
              child: Text("Save"),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
