import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grumblr/components/meal_card.dart';
import 'package:grumblr/mocks/core/restaurants.dart';
import 'dart:developer' as developer;

import 'package:grumblr/services/api/restaurants.dart';
import 'package:grumblr/services/state/router.dart';
import 'package:grumblr/types/meal.dart';
import 'package:grumblr/types/restaurant_details.dart';

class ManageMealsPage extends StatefulWidget {
  ManageMealsPage({Key key}) : super(key: key);

  final String title = 'Manage Meals';

  @override
  _ManageMealsPageState createState() => _ManageMealsPageState();
}

class _ManageMealsPageState extends State<ManageMealsPage> {
  List<Meal> meals;
  RestaurantDetails restaurantDetails;

  @override
  void setState(fn) {
    developer.log("setState Called");
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRestaurantMeals(CURRENT_RESTAURANT_ID);
    fetchRestaurantSettings(CURRENT_RESTAURANT_ID);

    RxRouterState().currentPage.listen((page) {
      developer.log('fetching');
      if (page == '/restaurant/meals/manage') {
        fetchRestaurantMeals(CURRENT_RESTAURANT_ID);
        fetchRestaurantSettings(CURRENT_RESTAURANT_ID);
      }
    });
  }

  @override
  void didUpdateWidget(ManageMealsPage page) {
    super.didUpdateWidget(page);
    developer.log('Did Update Widget');
  }

  fetchRestaurantMeals(restaurantId) async {
    RestaurantMealsResponse response =
        await ApiRestaurantService().getRestaurantMeals(restaurantId);

    List<Meal> filteredMeals = response.meals;
    if (restaurantDetails != null) {
      filteredMeals = [...response.meals];
      filteredMeals.removeWhere((meal) =>
          restaurantDetails.featuredMeals
              .indexWhere((featuredMeal) => featuredMeal.id == meal.id) >
          -1);
    }
    setState(() {
      meals = filteredMeals;
    });
  }

  fetchRestaurantSettings(restaurantId) async {
    RestaurantDetailsResponse response =
        await ApiRestaurantService().getRestaurantDetails(restaurantId);
    setState(() {
      restaurantDetails = response.restaurantDetails;
    });

    List<Meal> filteredMeals = meals;
    if (meals != null) {
      filteredMeals = [...meals];
      filteredMeals.removeWhere((meal) =>
          response.restaurantDetails.featuredMeals
              .indexWhere((featuredMeal) => featuredMeal.id == meal.id) >
          -1);
    }
    setState(() {
      meals = filteredMeals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.toNamed('/restaurant/meals/manage/add');
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ...restaurantDetails.featuredMeals.map(
                      (meal) => MealCard(
                        meal: meal,
                        viewportConstraints: viewportConstraints,
                        isFeatured: true,
                        featuredUnset: (String mealId) {
                          setState(() {
                            restaurantDetails.featuredMeals.remove(meal);
                            meals.add(meal);
                          });
                        },
                      ),
                    ),
                    ...meals.map(
                      (meal) => MealCard(
                        meal: meal,
                        viewportConstraints: viewportConstraints,
                        isFeatured: false,
                        featuredSet: (String mealId) {
                          setState(() {
                            restaurantDetails.featuredMeals.add(meal);
                            meals.remove(meal);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
