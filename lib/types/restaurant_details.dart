import 'package:grumblr/types/meal.dart';
import 'package:grumblr/types/restaurant.dart';

class RestaurantDetails {
  final Restaurant restaurant;
  final List<Meal> featuredMeals;

  RestaurantDetails({this.restaurant, this.featuredMeals});
}
