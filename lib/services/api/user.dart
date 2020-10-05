import 'package:dio/dio.dart';
import 'package:grumblr/http.dart';
import 'package:grumblr/mocks/core/settings.dart';
import 'package:grumblr/mocks/mocks.dart';
import 'package:grumblr/services/api/allergies.dart';
import 'package:grumblr/types/fulfillment_option.dart';
import 'package:grumblr/types/user_settings.dart';
import 'dart:developer' as developer;

class UserSettingsResponse {
  final UserSettings userSettings;
  UserSettingsResponse({this.userSettings});

  factory UserSettingsResponse.fromJson(dynamic json) {
    List selectedAllergyOptions = <AllergyOption>[];
    json['settings']['selected_allergies'].forEach(
      (allergy) {
        selectedAllergyOptions.add(
          AllergyOption(
            id: allergy['id'],
            name: allergy["name"],
            shortName: allergy["shortName"],
          ),
        );
      },
    );

    List<bool> selectedCuisineFilterState = [...json['settings']['selected_cuisine_filter_state']];


    UserSettings userSettings = UserSettings(
      selectedAllergies: selectedAllergyOptions,
      selectedCuisines: [],
      selectedCuisineFilterState: selectedCuisineFilterState,
      discoveryRadius: json['settings']['discovery_radius'],
      discoveryLatitude: json['settings']['discovery_latitude'],
      discoveryLongitude: json['settings']['discovery_longitude'],
      selectedDiet: json['settings']['selected_diet'],
      selectedFulfillmentOptions: SelectedFulfillmentOptions(
        dineIn: json['settings']['fulfillment_options']['dine_in'],
        takeOut: json['settings']['fulfillment_options']['take_out'],
        deliveryInHouse: json['settings']['fulfillment_options']['delivery_in_house'],
        deliveryDoorDash: json['settings']['fulfillment_options']['delivery_door_dash'],
        deliveryUberEats: json['settings']['fulfillment_options']['delivery_uber_eats'],
        deliveryJustEat: json['settings']['fulfillment_options']['delivery_just_eat'],
        deliveryMenuLog: json['settings']['fulfillment_options']['delivery_menulog'],
        deliveryDeliveroo: json['settings']['fulfillment_options']['delivery_deliveroo'],
      ),
    );

    return UserSettingsResponse(userSettings: userSettings);
  }
}

class ApiUserService {
  getSettings() {
    String userId = 'u123';

    return Http()
        .get(
          '/users/$USER_ID/settings',
          options: Options(
            extra: {
              "ids": [
                { "idType": IdTypes.user, "mockId": USER_ID, "realId": userId }
              ]
            },
          ),
        )
        .then<UserSettingsResponse>((Response response) =>
            UserSettingsResponse.fromJson(response.data));
  }
}
