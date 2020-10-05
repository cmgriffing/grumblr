import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grumblr/components/restaurant_meal_form.dart';
import 'package:grumblr/services/api/meals.dart';
import 'package:grumblr/types/meal.dart';

class RestaurantAddMealPage extends StatefulWidget {
  RestaurantAddMealPage({Key key}) : super(key: key);

  final String title = 'Add Meal';

  @override
  _RestaurantAddMealPageState createState() => _RestaurantAddMealPageState();
}

class _RestaurantAddMealPageState extends State<RestaurantAddMealPage> {
  RestaurantMealFormState formState = RestaurantMealFormState(
    fieldValidationMap: {
    FIELD_VALIDATION_KEY_NAME: false,
    FIELD_VALIDATION_KEY_DESCRIPTION: false,
    FIELD_VALIDATION_KEY_CUISINES: false,
  },
    name: '',
    selectedAllergyOptionTags: [],
    selectedCuisineOptionTags: [],
    description: '',
    image: null,
  );

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    int requiredFieldCount = 0;
    int validFieldCount = 0;
    if (formState != null) {
      developer.log('foo: ${formState.fieldValidationMap}');
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
                initialState: formState,
                viewportConstraints: viewportConstraints,
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
                        ApiMealService()
                            .createMeal(
                          Meal(
                            id: 'm167',
                            name: formState.name,
                            description: formState.description,
                            allergies: formState.selectedAllergyOptionTags
                                .map((allergyOptionTag) =>
                                    allergyOptionTag.allergyOption)
                                .toList(),
                            imageUrl: formState.image,
                          ),
                        )
                            .then(
                          (result) {
                            Get.close(1);
                          },
                        );
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
