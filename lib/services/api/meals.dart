import 'package:dio/dio.dart';
import 'package:grumblr/http.dart';
import 'package:grumblr/mocks/core/meals.dart';
import 'package:grumblr/mocks/core/settings.dart';
import 'package:grumblr/mocks/mocks.dart';
import 'package:grumblr/services/api/allergies.dart';
import 'package:grumblr/types/meal.dart';
import 'package:grumblr/types/meal_details.dart';
import 'dart:developer' as developer;

import 'package:grumblr/types/restaurant.dart';

class MealsResponse {
  final List<Meal> meals;
  MealsResponse({this.meals});

  factory MealsResponse.fromJson(dynamic json) {
    List meals = List.from(json['meals'])
        .map((rawMeal) => Meal(
              id: rawMeal['id'],
              name: rawMeal['name'],
              imageUrl: rawMeal['imageUrl'],
            ))
        .toList();

    return MealsResponse(meals: meals);
  }
}

class MealDetailsResponse {
  final MealDetails mealDetails;
  MealDetailsResponse({this.mealDetails});

  factory MealDetailsResponse.fromJson(dynamic json) {
    List allergies = <AllergyOption>[];
    json['meal']['allergies'].forEach(
      (allergy) {
        allergies.add(
          AllergyOption(
            id: allergy['id'],
            name: allergy["name"],
            shortName: allergy["shortName"],
          ),
        );
      },
    );


    Restaurant restaurant = null;
    if(json['meal']['restaurant'] != null) {
      restaurant = Restaurant(
        name: json['meal']['restaurant']['name'],
        id: json['meal']['restaurant']['id'],
        description: json['meal']['restaurant']['description'],
        imageUrl: json['meal']['restaurant']['imageUrl'],
        lat: json['meal']['restaurant']['lat'],
        long: json['meal']['restaurant']['long'],
        address: Address(
          line1: json['meal']['restaurant']['address']['line1'],
          line2: json['meal']['restaurant']['address']['line2'],
          line3: json['meal']['restaurant']['address']['line3'],
          line4: json['meal']['restaurant']['address']['line4'],
          municipality: json['meal']['restaurant']['address']['municipality'],
          province: json['meal']['restaurant']['address']['province'],
          postalCode: json['meal']['restaurant']['address']['postalCode'],
        ),
      );
    }

    MealDetails mealDetails = MealDetails(
      meal: Meal(
        id: json['meal']['id'],
        name: json['meal']['name'],
        description: json['meal']['description'],
        imageUrl: json['meal']['imageUrl'],
        allergies: allergies,
      ),
      restaurant: restaurant
    );

    return MealDetailsResponse(mealDetails: mealDetails);
  }
}

class ApiMealService {
  Future<MealsResponse> getLocalMeals(double lat, double long) {
    return Http().get('/meals/local?lat=$USER_LATITUDE&long=$USER_LONGITUDE',
          options: Options(
            extra: {
              "ids": [
                {"idType": IdTypes.meal, "mockId": "$USER_LATITUDE", "realId": "$lat"},
                {"idType": IdTypes.meal, "mockId": "$USER_LONGITUDE", "realId": "$long"},
              ]
            },
          ),).then<MealsResponse>(
          (Response response) => MealsResponse.fromJson(response.data),
        );
  }

  Future<MealsResponse> getFavoriteMeals(double lat, double long) {
    return Http().get('/meals/favorites').then<MealsResponse>(
          (Response response) => MealsResponse.fromJson(response.data),
        );
  }

  Future<MealDetailsResponse> getMealDetails(String mealId) {
    return Http()
        .get(
          '/meals/$mealId',
          options: Options(
            extra: {
              "ids": [
                {"idType": IdTypes.meal, "mockId": MEAL_ID, "realId": mealId}
              ]
            },
          ),
        )
        .then<MealDetailsResponse>(
          (Response response) => MealDetailsResponse.fromJson(response.data),
        );
  }

  Future<MealDetailsResponse> createMeal(Meal meal) {
    return Http().post('/meals/new', data: meal.toMap())
        .then<MealDetailsResponse>(
          (Response response) => MealDetailsResponse.fromJson(response.data),
        );
  }
}
