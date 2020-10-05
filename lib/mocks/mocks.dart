import 'package:grumblr/mocks/core/auth.dart';
import 'package:grumblr/mocks/core/data/settings.dart';
import 'package:grumblr/mocks/core/databases/settings.dart';
import 'package:grumblr/mocks/core/meals.dart';
import 'package:grumblr/mocks/core/allergies.dart';
import 'package:grumblr/mocks/core/cuisines.dart';
import 'package:grumblr/http.dart';

import 'dart:developer' as developer;

import 'package:grumblr/mocks/core/restaurants.dart';
import 'package:grumblr/mocks/core/settings.dart';
import 'package:sembast/sembast.dart';

import 'core/databases/featured_meals.dart';
import 'core/databases/meals.dart';
import 'core/databases/restaurants.dart';

enum IdTypes { meal, cuisine, allergy, user, diet, restaurant }

Map addBaseUri(Map mocks) {
  return mocks.map((key, value) {
    String newKey = "$BASE_API_URL$key";
    return MapEntry(newKey, value);
  });
}

class Mocks {
  static final Mocks _instance = Mocks._privateConstructor();

  factory Mocks() {
    return _instance;
  }

  Map routeMocks = {};

  Mocks._privateConstructor() {
    routeMocks = addBaseUri({
      ...routeMocks,

      // Core
      ...authRouteMocks,
      ...mealsRouteMocks,
      ...allergiesRouteMocks,
      ...cuisinesRouteMocks,
      ...restaurantsRouteMocks,
      ...userSettingsRouteMocks,
    });

    developer.log("routeMocks: ${routeMocks.keys.toString()}");
  }

  scaffoldDatabases() async {
    var mealsDb = MealsDatabase();
    var featuredMealsDb = FeaturedMealsDatabase();
    var restaurantsDb = RestaurantsDatabase();
    var userSettingsDb = UserSettingsDatabase();

    // use a timeout here to wait?
    await new Future.delayed(const Duration(milliseconds: 1000));

    var mealsRecords = await mealsDb.store.find(mealsDb.db);
    List<Map> meals =
        mealsRecords.map<Map<dynamic, dynamic>>((meal) => meal.value).toList();

    var restaurantsRecords = await restaurantsDb.store.find(restaurantsDb.db);
    List<Map> restaurants = restaurantsRecords
        .map<Map<dynamic, dynamic>>((restaurant) => restaurant.value)
        .toList();

    meals.forEach((meal) async {
      // "random" restaurant id
      String restaurantId = 'r123';

      Map restaurant = restaurants.firstWhere(
          (innerRestaurant) => innerRestaurant["id"] == restaurantId);

      // meal["restaurant"] = restaurant;

      await mealsDb.store.update(
        mealsDb.db,
        {
          ...meal,
          "restaurant": restaurant
        },
        finder: Finder(
          filter: Filter.equals("id", meal["id"]),
        ),
      );
    });
  }
}
