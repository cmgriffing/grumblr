import 'package:grumblr/services/api/allergies.dart';
import 'package:grumblr/types/fulfillment_option.dart';
import 'package:grumblr/types/restaurant.dart';

class MealFulfillmentOption {
  final FulfillmentOption fulfillmentOption;
  final String value;

  MealFulfillmentOption({this.fulfillmentOption, this.value});

  toMap() {
    return {
      "fulfillmentOption": fulfillmentOption.toMap(),
      "value": value,
    };
  }
}

class Meal {
  final String name;
  final String id;
  final String imageUrl;
  final String description;

  final List<AllergyOption> allergies;
  final List<MealFulfillmentOption> fulfillmentOptions;

  Meal({
    this.name,
    this.id,
    this.imageUrl,
    this.description,
    this.allergies,
    this.fulfillmentOptions,
  });

  toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "imageUrl": imageUrl,
      "allergies": allergies
          .map<Map<dynamic, dynamic>>((allergy) => allergy.toMap())
          .toList(),
      "fulfillmentOptions": fulfillmentOptions
          .map<Map<dynamic, dynamic>>(
              (fulfillmentOption) => fulfillmentOption.toMap())
          .toList()
    };
  }
}
