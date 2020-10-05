import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:grumblr/components/app_showcase.dart';
import 'package:grumblr/services/api/allergies.dart';
import 'package:grumblr/services/api/cuisines.dart';
import 'package:grumblr/services/api/user.dart';
import 'package:grumblr/services/state/onboarding.dart';
import 'package:grumblr/services/state/user_settings.dart';
import 'package:grumblr/types/fulfillment_option.dart';
import 'package:nominatim_location_picker/nominatim_location_picker.dart';
import 'package:geocoder/geocoder.dart';
import 'package:showcaseview/showcaseview.dart';


class Location {
  final String name;
  final double lat;
  final double long;

  Location({
    this.name,
    this.lat,
    this.long,
  });
}

class Label extends StatelessWidget {
  final String data;

  Label({this.data});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.left,
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String data;

  SectionTitle({this.data});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class HomeSettingsView extends StatefulWidget {
  final Function buildHook;
  final ScrollController scrollController;
  HomeSettingsView({Key key, this.buildHook, this.scrollController}) : super(key: key);

  @override
  _HomeSettingsViewState createState() => _HomeSettingsViewState();
}

class _HomeSettingsViewState extends State<HomeSettingsView> {
  final _formKey = GlobalKey<FormState>();

  final userSettings = RxUserSettings();

  Address location;

  List<AllergyOptionTag> selectedAllergyOptionTags = [];
  List<CuisineOptionTag> selectedCuisineOptionTags = [];

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    selectedAllergyOptionTags = userSettings.selectedAllergies.value.map(
      (option) {
        return AllergyOptionTag(allergyOption: option);
      },
    ).toList();

    userSettings.selectedAllergies.listen((selectedAllergies) {
      selectedAllergyOptionTags = selectedAllergies.map(
        (option) {
          return AllergyOptionTag(allergyOption: option);
        },
      ).toList();
    });

    selectedCuisineOptionTags = userSettings.selectedCuisines.value.map(
      (option) {
        return CuisineOptionTag(cuisineOption: option);
      },
    ).toList();

    userSettings.selectedCuisines.listen((selectedCuisines) {
      selectedCuisineOptionTags = selectedCuisines.map(
        (option) {
          return CuisineOptionTag(cuisineOption: option);
        },
      ).toList();
    });

    fetchSettings();

    double latitude = RxUserSettings().discoveryLatitude.value;
    double longitude = RxUserSettings().discoveryLongitude.value;
    setLocationFromLatLong(latitude, longitude);
  }

  setLocationFromLatLong(double latitude, double longitude) async {
    final coordinates = new Coordinates(latitude, longitude);
    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    Address first = addresses.first;

    setState(() {
      location = first;
    });
  }

  //
  fetchSettings() async {
    // Response<Map> settingsResponse = await ApiUserService().getSettings();

    setState(() {
      // userSettings.discoveryRadius.value = settingsResponse['discoveryRadius']
    });
  }

  Future getLocationWithNominatim() async {
    Map result = await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return NominatimLocationPicker(
          searchHint: 'Where are you?',
          awaitingForLocation: "Waiting for location",
        );
      },
    );
    if (result != null) {
      developer.log("result from picker: $result");

      setLocationFromLatLong(
          result["latlng"].latitude, result["latlng"].longitude);
      setState(() {
        RxUserSettings().discoveryLatitude.value = result["latlng"].latitude;
        RxUserSettings().discoveryLongitude.value = result["latlng"].longitude;
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.buildHook();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, BoxConstraints viewportConstraints) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: viewportConstraints.maxWidth,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.toNamed('/restaurant/settings');
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.exit_to_app),
                                Text("Restaurant Management"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: viewportConstraints.maxWidth,
                      padding: EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                        left: 12,
                        right: 12,
                      ),
                      decoration: BoxDecoration(color: Colors.red),
                      child: Row(
                        children: [
                          Icon(
                            Icons.map_outlined,
                            color: Colors.white,
                          ),
                          Text(
                            " Discovery",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(
                              data:
                                  'Radius ${userSettings.discoveryRadius.value.round()} miles'),
                          SizedBox(height: 10),
                          AppShowcase(
                            showcaseKey: RxOnboardingState.globalKeyMap[
                                OnboardingStepParts.homeSettingsRadius],
                            description: 'Adjust the size of your Search area.',
                            child: Slider(
                              value: userSettings.discoveryRadius.value,
                              min: 5,
                              max: 25,
                              divisions: 20,
                              label: userSettings.discoveryRadius.value
                                  .round()
                                  .toString(),
                              onChanged: (double value) {
                                setState(() {
                                  userSettings.discoveryRadius.value = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Label(data: 'Search Near'),
                          SizedBox(height: 10),
                          if (!location.locality.isNull)
                            Container(
                                child: Text(
                                    "${location.locality}, ${location.adminArea}"),
                                alignment: Alignment.center),
                          if (location.locality.isNull)
                            Container(
                                child: Text('No location found.'),
                                alignment: Alignment.center),
                          AppShowcase(
                            showcaseKey: RxOnboardingState.globalKeyMap[
                                OnboardingStepParts.homeSettingsLocation],
                            description: 'Select your location from a map.',
                            child: Container(
                              child: RaisedButton(
                                onPressed: () {
                                  getLocationWithNominatim();
                                },
                                child: Text('Select a new location'),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: viewportConstraints.maxWidth,
                      padding: EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                        left: 12,
                        right: 12,
                      ),
                      decoration: BoxDecoration(color: Colors.red),
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter,
                            color: Colors.white,
                          ),
                          Text(
                            " Filters",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(data: 'Allergies'),
                          SizedBox(height: 10),
                          AppShowcase(
                            showcaseKey: RxOnboardingState.globalKeyMap[
                                OnboardingStepParts.homeSettingsAllergies],
                            description: 'If you have Allergies,\n add them here and Meals containing\n them will ber ignored.',
                            child: FlutterTagging<AllergyOptionTag>(
                              initialItems: selectedAllergyOptionTags,
                              textFieldConfiguration: TextFieldConfiguration(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.black12,
                                  hintText: 'Search Allergies',
                                  labelText: 'Select Allergies',
                                ),
                              ),
                              findSuggestions: (String search) {
                                return ApiAllergyService()
                                    .getAllergyOptions()
                                    .then<List<AllergyOptionTag>>(
                                        (allergyOptionsResponse) {
                                  return List.from(
                                    (allergyOptionsResponse).allergyOptions.map(
                                      (option) {
                                        return AllergyOptionTag(
                                            allergyOption: option);
                                      },
                                    ),
                                  );
                                }).catchError((error) {
                                  developer.log("ERROR!!!!! $error");
                                  return List<AllergyOptionTag>.from([]);
                                });
                              },
                              configureSuggestion: (allergyTag) {
                                return SuggestionConfiguration(
                                  title: Text(allergyTag.allergyOption.name),
                                );
                              },
                              configureChip: (allergyTag) {
                                return ChipConfiguration(
                                  label: Text(allergyTag.allergyOption.name),
                                  backgroundColor: Colors.red,
                                  labelStyle: TextStyle(color: Colors.white),
                                  deleteIconColor: Colors.white,
                                );
                              },
                              onChanged: () {
                                // print();
                                userSettings.selectedAllergies.value =
                                    selectedAllergyOptionTags
                                        .map((allergyOptionTag) =>
                                            allergyOptionTag.allergyOption)
                                        .toList();
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Label(data: 'Cuisines'),
                          const SizedBox(height: 10),
                          AppShowcase(
                            showcaseKey: RxOnboardingState.globalKeyMap[
                                OnboardingStepParts.homeSettingsCuisines],
                            description: 'Using this filter, you can\n Ignore or get only Cuisine types of your choice.',
                            child: Container(
                              alignment: Alignment.center,
                              child: ToggleButtons(
                                constraints: BoxConstraints.expand(
                                  width: viewportConstraints.maxWidth / 3 - 16,
                                  height: 84,
                                ),
                                children: <Widget>[
                                  Text('No Filter'),
                                  Text('Only'),
                                  Text('Exclude'),
                                ],
                                onPressed: (int index) {
                                  setState(() {
                                    for (int buttonIndex = 0;
                                        buttonIndex <
                                            userSettings
                                                .selectedCuisineFilterState
                                                .value
                                                .length;
                                        buttonIndex++) {
                                      if (buttonIndex == index) {
                                        userSettings.selectedCuisineFilterState
                                                .value[buttonIndex] =
                                            !userSettings
                                                .selectedCuisineFilterState
                                                .value[buttonIndex];
                                      } else {
                                        userSettings.selectedCuisineFilterState
                                            .value[buttonIndex] = false;
                                      }
                                    }
                                  });
                                },
                                isSelected: userSettings
                                    .selectedCuisineFilterState.value,
                              ),
                            ),
                          ),
                          if (!userSettings.selectedCuisineFilterState.value[0])
                            FlutterTagging<CuisineOptionTag>(
                              initialItems: selectedCuisineOptionTags,
                              textFieldConfiguration: TextFieldConfiguration(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.black12,
                                  hintText: 'Search Cuisines',
                                  labelText: 'Select Cuisines',
                                ),
                              ),
                              findSuggestions: (String search) {
                                return ApiCuisineService()
                                    .getCuisineOptions()
                                    .then<List<CuisineOptionTag>>(
                                        (cuisineOptionsResponse) {
                                  return List.from((cuisineOptionsResponse)
                                      .cuisineOptions
                                      .map((option) {
                                    return CuisineOptionTag(
                                        cuisineOption: option);
                                  }));
                                }).catchError((error) {
                                  developer.log("ERROR!!!!! $error");
                                  return List<CuisineOptionTag>.from([]);
                                });
                              },
                              configureSuggestion: (cuisineTag) {
                                return SuggestionConfiguration(
                                  title: Text(cuisineTag.cuisineOption.name),
                                );
                              },
                              configureChip: (cuisineTag) {
                                return ChipConfiguration(
                                  label: Text(cuisineTag.cuisineOption.name),
                                  backgroundColor: Colors.amber[900],
                                  labelStyle: TextStyle(color: Colors.white),
                                  deleteIconColor: Colors.white,
                                );
                              },
                              onChanged: () {
                                userSettings.selectedCuisines.value =
                                    selectedCuisineOptionTags
                                        .map((cuisineOptionTag) =>
                                            cuisineOptionTag.cuisineOption)
                                        .toList();
                                // print();
                              },
                            ),
                          const SizedBox(height: 20),
                          Label(data: 'Diet'),
                          const SizedBox(height: 10),
                          AppShowcase(
                            showcaseKey: RxOnboardingState.globalKeyMap[
                                OnboardingStepParts.homeSettingsDiet],
                            description: 'Select a Diet you are adhering to.',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DropdownButton<String>(
                                  isExpanded: true,
                                  value: userSettings.selectedDiet.value,
                                  icon: Icon(Icons.arrow_downward),
                                  onChanged: (String newDiet) {
                                    setState(() {
                                      userSettings.selectedDiet.value = newDiet;
                                    });
                                  },
                                  items: <String>[
                                    'None',
                                    'Pescatarian',
                                    'Vegetarian',
                                    'Vegan'
                                  ].map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: viewportConstraints.maxWidth,
                      padding: EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                        left: 12,
                        right: 12,
                      ),
                      decoration: BoxDecoration(color: Colors.red),
                      child: Row(
                        children: [
                          Icon(
                            Icons.delivery_dining,
                            color: Colors.white,
                          ),
                          Text(
                            " Takeout/Delivery Options",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    AppShowcase(
                      showcaseKey: RxOnboardingState.globalKeyMap[
                          OnboardingStepParts.homeSettingsDelivery],
                      description: 'Select options to only see the\n Restaurants that support the\n services you actually use.',
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: allFulfillmentOptions
                                  .map((fulfillmentOption) => SwitchListTile(
                                      title: Text(fulfillmentOption.name),
                                      value: userSettings
                                          .selectedFulfillmentOptions
                                          .value[fulfillmentOption.key],
                                      onChanged: (bool value) {
                                        setState(() {
                                          userSettings
                                                  .selectedFulfillmentOptions
                                                  .value[
                                              fulfillmentOption.key] = value;
                                        });
                                      },
                                      secondary: fulfillmentOption.icon))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: viewportConstraints.maxWidth,
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.red.withOpacity(0.95), BlendMode.dstATop),
                          image: NetworkImage(
                              "http://lorempixel.com/output/nightlife-q-c-640-480-7.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Want your restaurant represented in options?',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          RaisedButton(
                            onPressed: () {},
                            child: Text('Sign up today'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AllergyOptionTag extends Taggable {
  final AllergyOption allergyOption;

  AllergyOptionTag({this.allergyOption});

  @override
  List<Object> get props => [allergyOption.name];

  Map<String, dynamic> toJson() => {
        'name': allergyOption?.name ?? '',
      };
}

class CuisineOptionTag extends Taggable {
  final CuisineOption cuisineOption;

  CuisineOptionTag({this.cuisineOption});

  @override
  List<Object> get props => [cuisineOption.name];
}

/*

discovery
  - range
  - location - user or entered - geoflutterfire?

cuisine preferences
  - any/vegetarian/vegan
  - allergies
  - exclude

restaurants that have delivery
  -  option per service (include in-house as option)

- are you a restaurant owner, add your menu today after signing up!

*/