import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:grumblr/http.dart';
import 'package:grumblr/mocks/core/meals.dart';
import 'package:grumblr/mocks/core/restaurants.dart';
import 'package:grumblr/mocks/mocks.dart';
import 'package:grumblr/services/api/allergies.dart';
import 'package:grumblr/types/meal.dart';
import 'package:grumblr/types/restaurant.dart';
import 'package:grumblr/types/restaurant_details.dart';

class RestaurantDetailsResponse {
  final RestaurantDetails restaurantDetails;
  RestaurantDetailsResponse({this.restaurantDetails});

  factory RestaurantDetailsResponse.fromJson(dynamic json) {
    Map rawRestaurant = json['restaurant'];
    List rawFeaturedMeals = json['featuredMeals'];

    List<Meal> featuredMeals = [];

    rawFeaturedMeals.forEach((rawMeal) {
      List allergies = <AllergyOption>[];
      rawMeal['allergies'].forEach(
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

      featuredMeals.add(Meal(
          name: rawMeal['name'],
          id: rawMeal['id'],
          imageUrl: rawMeal['imageUrl'],
          description: rawMeal['description'],
          allergies: allergies));
    });

    RestaurantDetails restaurantDetails = RestaurantDetails(
        restaurant: Restaurant(
          id: rawRestaurant['id'],
          name: rawRestaurant['name'],
          description: rawRestaurant['description'],
          imageUrl: rawRestaurant['imageUrl'],
          address: Address(
            line1: rawRestaurant['address']['line1'],
            line2: rawRestaurant['address']['line2'],
            line3: rawRestaurant['address']['line3'],
            line4: rawRestaurant['address']['line4'],
            municipality: rawRestaurant['address']['municipality'],
            province: rawRestaurant['address']['province'],
            postalCode: rawRestaurant['address']['postalCode'],
          ),
        ),
        featuredMeals: featuredMeals);

    return RestaurantDetailsResponse(restaurantDetails: restaurantDetails);
  }
}

class RestaurantMealsResponse {
  final List<Meal> meals;
  RestaurantMealsResponse({this.meals});

  factory RestaurantMealsResponse.fromJson(dynamic json) {
    List rawmeals = json['meals'];

    List<Meal> meals = [];

    rawmeals.forEach((rawMeal) {
      List allergies = <AllergyOption>[];
      rawMeal['allergies'].forEach(
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

      meals.add(Meal(
          name: rawMeal['name'],
          id: rawMeal['id'],
          imageUrl: rawMeal['imageUrl'],
          description: rawMeal['description'],
          allergies: allergies));
    });

    return RestaurantMealsResponse(meals: meals);
  }
}

class ApiRestaurantService {
  Future<RestaurantDetailsResponse> getRestaurantDetails(String restaurantId) {
    return Http()
        .get('/restaurants/$restaurantId',
            options: Options(extra: {
              "ids": [
                {
                  "idType": IdTypes.restaurant,
                  "mockId": RESTAURANT_ID,
                  "realId": restaurantId
                }
              ]
            }))
        .then<RestaurantDetailsResponse>((Response response) =>
            RestaurantDetailsResponse.fromJson(response.data));
  }

  Future<RestaurantMealsResponse> getRestaurantMeals(String restaurantId) {
    return Http()
        .get('/restaurant/manage/$restaurantId/meals',
            options: Options(extra: {
              "ids": [
                {
                  "idType": IdTypes.restaurant,
                  "mockId": RESTAURANT_ID,
                  "realId": restaurantId
                }
              ]
            }))
        .then<RestaurantMealsResponse>((Response response) =>
            RestaurantMealsResponse.fromJson(response.data));
  }

  Future<RestaurantMealsResponse> getRestaurantFeaturedMeals(
      String restaurantId) {
    return Http()
        .get('/restaurant/manage/$restaurantId/meals/featured',
            options: Options(extra: {
              "ids": [
                {
                  "idType": IdTypes.restaurant,
                  "mockId": RESTAURANT_ID,
                  "realId": restaurantId
                }
              ]
            }))
        .then<RestaurantMealsResponse>((Response response) =>
            RestaurantMealsResponse.fromJson(response.data));
  }

  setMealAsFeatured(String restaurantId, String mealId) {
    return Http().post(
      '/restaurant/manage/$restaurantId/meals/featured/$mealId',
      options: Options(
        extra: {
          "ids": [
            {
              "idType": IdTypes.meal,
              "mockId": MEAL_ID,
              "realId": mealId,
            },
            {
              "idType": IdTypes.restaurant,
              "mockId": RESTAURANT_ID,
              "realId": restaurantId
            }
          ]
        },
      ),
    );
  }

  removeMealAsFeatured(String restaurantId, String mealId) {
    return Http().delete(
      '/restaurant/manage/$restaurantId/meals/featured/$mealId',
      options: Options(
        extra: {
          "ids": [
            {
              "idType": IdTypes.meal,
              "mockId": MEAL_ID,
              "realId": mealId,
            },
            {
              "idType": IdTypes.restaurant,
              "mockId": RESTAURANT_ID,
              "realId": restaurantId
            }
          ]
        },
      ),
    );
  }
}
