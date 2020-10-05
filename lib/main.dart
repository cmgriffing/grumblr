import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart' as Get;
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import 'package:grumblr/pages/home.dart';
import 'package:grumblr/pages/done.dart';
import 'package:grumblr/pages/meal.dart';
import 'package:grumblr/pages/restaurant/add_meal.dart';
import 'package:grumblr/pages/restaurant/edit_meal.dart';
import 'package:grumblr/pages/restaurant/manage_meals.dart';
import 'package:grumblr/pages/restaurant/restaurant_settings.dart';
import 'package:grumblr/pages/splash.dart';
import 'package:grumblr/pages/testing.dart';
import 'package:grumblr/services/api/user.dart';
import 'package:grumblr/services/state/user_settings.dart';

import 'mocks/core/meals.dart';
import 'mocks/mocks.dart';
import 'services/state/router.dart';

void main() {
  Mocks()
      .scaffoldDatabases()
      .then((result) => ApiUserService().getSettings())
      .then((result) {
    RxUserSettings().discoveryLatitude.value =
        result.userSettings.discoveryLatitude;
    RxUserSettings().discoveryLongitude.value =
        result.userSettings.discoveryLongitude;
    RxUserSettings().discoveryRadius.value =
        result.userSettings.discoveryRadius;

    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Get.GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Colors.red,
        dialogBackgroundColor: Colors.red,
        splashColor: Colors.red,
        highlightColor: Colors.redAccent,
      ),
      routingCallback: (routing) {
        developer.log("routing $routing");
        RxRouterState().currentPage.value = routing.current;
      },
      initialRoute: '/home/swiper/none',
      getPages: [
        Get.GetPage(
          name: '',
          page: () => SplashPage(),
        ),
        Get.GetPage(
            name: '/home/:activeTab/:tabContext',
            page: () => MyHomePage(title: 'Flutter Demo Home Page')),
        Get.GetPage(name: '/meal/:mealId', page: () => MealPage()),
        Get.GetPage(name: '/done', page: () => DonePage()),
        Get.GetPage(
            name: '/testing',
            page: () => TestingPage(),
            transition: Get.Transition.leftToRightWithFade),
        Get.GetPage(
          name: '/restaurant/settings',
          page: () => RestaurantSettingsPage(),
          transition: Get.Transition.rightToLeft,
        ),
        Get.GetPage(
          name: '/restaurant/meals/manage',
          page: () => ManageMealsPage(),
          transition: Get.Transition.downToUp,
        ),
        Get.GetPage(
          name: '/restaurant/meals/manage/add',
          page: () => RestaurantAddMealPage(),
          transition: Get.Transition.rightToLeft,
        ),
        Get.GetPage(
          name: '/restaurant/meals/:mealId/edit',
          page: () => RestaurantEditMealPage(),
          transition: Get.Transition.rightToLeft,
        ),
      ],
    );
  }
}
