import 'package:get/get.dart';
import 'dart:developer' as developer;

import 'package:grumblr/types/meal.dart';

enum SwipedMealType {
  liked,
  disliked,
  favorited,
  hated,
}

class RxSwipeResults extends GetxController {
  final likedMeals = <Meal>[].obs;
  final favoritedMeals = <Meal>[].obs;
  final dislikedMeals = <Meal>[].obs;
  final hatedMeals = <Meal>[].obs;

  reset() {
    likedMeals.value = [];
    favoritedMeals.value = [];
    dislikedMeals.value = [];
    hatedMeals.value = [];
  }

  swipeMeal({meal, swipedMealType}) {
    if (swipedMealType == SwipedMealType.liked) {
      List<Meal> newList = [...likedMeals.value];
      newList.add(meal);
      likedMeals.value = newList;
    } else if (swipedMealType == SwipedMealType.disliked) {
      List<Meal> newList = [...dislikedMeals.value];
      newList.add(meal);
      dislikedMeals.value = newList;
    } else if (swipedMealType == SwipedMealType.favorited) {
      List<Meal> newList = [...favoritedMeals.value];
      newList.add(meal);
      favoritedMeals.value = newList;
    } else if (swipedMealType == SwipedMealType.hated) {
      List<Meal> newList = [...hatedMeals.value];
      newList.add(meal);
      hatedMeals.value = newList;
    }
  }

  factory RxSwipeResults() {
    return _instance;
  }

  static final RxSwipeResults _instance = RxSwipeResults._privateConstructor();

  RxSwipeResults._privateConstructor();
}
