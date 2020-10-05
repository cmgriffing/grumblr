import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:grumblr/mocks/core/meals.dart';
import 'package:sembast/sembast.dart';

import 'data/meals.dart';
import 'data/restaurants.dart';
import 'databases/featured_meals.dart';
import 'databases/meals.dart';

const String RESTAURANT_ID = "r42";
const String CURRENT_RESTAURANT_ID = "r123";

Map restaurantsRouteMocks = {
  "/restaurants": (RequestOptions requestOptions) =>
      {"restaurants": restaurantsMocks},
  "/restaurants/$RESTAURANT_ID": (RequestOptions requestOptions) async {
    String restaurantId = RESTAURANT_ID;
    requestOptions.extra["ids"].forEach((Map idMap) {
      if (idMap["mockId"] == RESTAURANT_ID) {
        restaurantId = idMap["realId"];
      }
    });

    Map restaurant = restaurantsMocks
        .firstWhere((restaurant) => restaurant["id"] == restaurantId);

    var featuredMealsResults = await FeaturedMealsDatabase().store.find(
          FeaturedMealsDatabase().db,
          finder: Finder(
            filter: Filter.equals(
              'restaurantId',
              restaurantId,
            ),
          ),
        );
    List<Map> featuredMeals = featuredMealsResults
        .map<Map<dynamic, dynamic>>((meal) => meal.value)
        .toList();

    var mealsResults = await MealsDatabase().store.find(
          MealsDatabase().db,
          finder: Finder(
            filter: Filter.or(
              featuredMeals.map<Filter>((featuredMeal) =>
                  Filter.equals('id', featuredMeal['mealId'])).toList(),
            ),
          ),
        );

    List<Map> meals =
        mealsResults.map<Map<dynamic, dynamic>>((meal) => meal.value).toList();

    return {"restaurant": restaurant, "featuredMeals": meals};
  },
  "/restaurant/manage/$RESTAURANT_ID/meals":
      (RequestOptions requestOptions) async {
    String restaurantId = RESTAURANT_ID;
    requestOptions.extra["ids"].forEach((Map idMap) {
      if (idMap["mockId"] == RESTAURANT_ID) {
        restaurantId = idMap["realId"];
      }
    });

    var results = await MealsDatabase().store.find(
          MealsDatabase().db,
          finder: Finder(
            filter: Filter.equals(
              'restaurant.id',
              restaurantId,
            ),
          ),
        );

    List<Map> meals =
        results.map<Map<dynamic, dynamic>>((meal) => meal.value).toList();

    return {"meals": meals};
  },
  '/restaurant/manage/$RESTAURANT_ID/meals/featured/$MEAL_ID':
      (RequestOptions requestOptions) async {
    String restaurantId = RESTAURANT_ID;
    requestOptions.extra["ids"].forEach((Map idMap) {
      if (idMap["mockId"] == RESTAURANT_ID) {
        restaurantId = idMap["realId"];
      }
    });

    String mealId = MEAL_ID;
    requestOptions.extra["ids"].forEach((Map idMap) {
      if (idMap["mockId"] == MEAL_ID) {
        mealId = idMap["realId"];
      }
    });
    developer.log('Method: ${requestOptions.method}');
    if (requestOptions.method == 'POST') {
      await FeaturedMealsDatabase().store.add(
        FeaturedMealsDatabase().db,
        {
          "mealId": mealId,
          "restaurantId": restaurantId,
        },
      );
    } else if (requestOptions.method == 'DELETE') {
      await FeaturedMealsDatabase().store.delete(
            FeaturedMealsDatabase().db,
            finder: Finder(
              filter: Filter.and(
                [
                  Filter.equals(
                    "mealId",
                    mealId,
                  ),
                  Filter.equals(
                    "restaurantId",
                    restaurantId,
                  ),
                ],
              ),
            ),
          );
    }
    return {"success": true};
  }
};
