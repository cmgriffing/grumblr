import 'package:grumblr/services/api/allergies.dart';
import 'package:grumblr/services/api/cuisines.dart';

class SelectedFulfillmentOptions {
    final bool dineIn;
    final bool takeOut;
    final bool deliveryInHouse;
    final bool deliveryDoorDash;
    final bool deliveryUberEats;
    final bool deliveryJustEat;
    final bool deliveryMenuLog;
    final bool deliveryDeliveroo;

    SelectedFulfillmentOptions({
      this.dineIn,
      this.takeOut,
      this.deliveryInHouse,
      this.deliveryDoorDash,
      this.deliveryUberEats,
      this.deliveryJustEat,
      this.deliveryMenuLog,
      this.deliveryDeliveroo,
    });
}

class UserSettings {

  final double discoveryRadius;
  final double discoveryLatitude;
  final double discoveryLongitude;

  final List<AllergyOption> selectedAllergies;

  final List<bool> selectedCuisineFilterState;
  final List<CuisineOption> selectedCuisines;

  final String selectedDiet;

  final SelectedFulfillmentOptions selectedFulfillmentOptions;

  UserSettings({
    this.discoveryRadius,
    this.discoveryLatitude,
    this.discoveryLongitude,
    this.selectedAllergies,
    this.selectedCuisineFilterState,
    this.selectedCuisines,
    this.selectedDiet,
    this.selectedFulfillmentOptions,
  });
}
