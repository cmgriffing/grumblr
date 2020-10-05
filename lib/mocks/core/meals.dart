import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:grumblr/mocks/core/restaurants.dart';
import 'package:grumblr/mocks/core/settings.dart';
import 'package:sembast/sembast.dart';

import 'data/meals.dart';
import 'data/restaurants.dart';
import 'databases/meals.dart';

const String MEAL_ID = 'm42';

Map mealsRouteMocks = {
  "/meals/local?lat=$USER_LATITUDE&long=$USER_LONGITUDE":
      (RequestOptions requestOptions) => {
            "meals": mealsMocks.map(
              (mealMock) {
                mealMock.putIfAbsent("restaurant", () => restaurantsMocks[0]);
                return mealMock;
              },
            ),
          },
  "/meals/$MEAL_ID": (RequestOptions requestOptions) async {
    MealsDatabase mealsDb = MealsDatabase();
    String mealId = MEAL_ID;
    requestOptions.extra["ids"].forEach((Map idMap) {
      if (idMap["mockId"] == MEAL_ID) {
        mealId = idMap["realId"];
      }
    });

    var record = await mealsDb.store.findFirst(mealsDb.db,
        finder: Finder(filter: Filter.equals('id', mealId)));

    developer.log('record: ${record.value}');

    return {"meal": record.value};
  },
  "/meals/new": (RequestOptions requestOptions) async {
    MealsDatabase mealsDb = MealsDatabase();

    Map<dynamic, dynamic> data = requestOptions.data;

    var restaurant = restaurantsMocks.firstWhere((restaurant) => restaurant["id"] == CURRENT_RESTAURANT_ID);

    var record = await mealsDb.store.add(mealsDb.db, {
      ...data,
      "restaurant": restaurant
    });

    developer.log('record: $record');

    return {"meal": requestOptions.data};
  },
};
