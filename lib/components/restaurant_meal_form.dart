import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:grumblr/pages/home/settings.dart';
import 'package:grumblr/services/api/allergies.dart';
import 'package:grumblr/services/api/cuisines.dart';
import 'package:image_picker/image_picker.dart';

const String FIELD_VALIDATION_KEY_NAME = 'name';
const String FIELD_VALIDATION_KEY_DESCRIPTION = 'description';
const String FIELD_VALIDATION_KEY_CUISINES = 'cuisines';

class RestaurantMealFormState {
  Map fieldValidationMap = {
    FIELD_VALIDATION_KEY_NAME: false,
    FIELD_VALIDATION_KEY_DESCRIPTION: false,
    FIELD_VALIDATION_KEY_CUISINES: false,
  };
  String name = '';
  List<AllergyOptionTag> selectedAllergyOptionTags = [];
  List<CuisineOptionTag> selectedCuisineOptionTags = [];
  String image;
  String description;

  RestaurantMealFormState({
    this.fieldValidationMap,
    this.image,
    this.name,
    this.selectedAllergyOptionTags,
    this.selectedCuisineOptionTags,
    this.description,
  });
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'image': image,
      };
}

class RestaurantMealForm extends StatelessWidget {
  RestaurantMealForm(
      {Key key, this.viewportConstraints, this.changed, this.initialState})
      : super(key: key);

  final RestaurantMealFormState initialState;
  final BoxConstraints viewportConstraints;
  final Function changed;

  emitValidationMapChange(Map fieldValidationMap) {
    RestaurantMealFormState newFormState = RestaurantMealFormState(
      fieldValidationMap: fieldValidationMap,
      name: initialState.name,
      selectedAllergyOptionTags: initialState.selectedAllergyOptionTags,
      selectedCuisineOptionTags: initialState.selectedCuisineOptionTags,
      image: initialState.image,
      description: initialState.description,
    );
    changed(newFormState);
  }

  emitNameChange(String name) {
    bool valid = true;
    if (name.isEmpty) {
      valid = false;
    }

    var newFieldValidationMap = {
      ...initialState.fieldValidationMap,
    };

    newFieldValidationMap[FIELD_VALIDATION_KEY_NAME] = valid;

    RestaurantMealFormState newFormState = RestaurantMealFormState(
      fieldValidationMap: newFieldValidationMap,
      name: name,
      selectedAllergyOptionTags: initialState.selectedAllergyOptionTags,
      selectedCuisineOptionTags: initialState.selectedCuisineOptionTags,
      image: initialState.image,
      description: initialState.description,
    );
    changed(newFormState);
  }

  emitDescriptionChange(String description) {
    bool valid = true;
    if (description.isEmpty) {
      valid = false;
    }
    RestaurantMealFormState newFormState = RestaurantMealFormState(
      fieldValidationMap: {
        ...initialState.fieldValidationMap,
        FIELD_VALIDATION_KEY_DESCRIPTION: valid
      },
      name: initialState.name,
      selectedAllergyOptionTags: initialState.selectedAllergyOptionTags,
      selectedCuisineOptionTags: initialState.selectedCuisineOptionTags,
      image: initialState.image,
      description: description,
    );
    changed(newFormState);
  }

  emitSelectedAllergiesChange(
      List<AllergyOptionTag> selectedAllergyOptionTags) {
    RestaurantMealFormState newFormState = RestaurantMealFormState(
      fieldValidationMap: initialState.fieldValidationMap,
      name: initialState.name,
      selectedAllergyOptionTags: selectedAllergyOptionTags,
      selectedCuisineOptionTags: initialState.selectedCuisineOptionTags,
      image: initialState.image,
      description: initialState.description,
    );
    developer.log('EMITTING: ${jsonEncode(newFormState)}');
    changed(newFormState);
  }

  emitSelectedCuisinesChange(List<CuisineOptionTag> selectedCuisineOptionTags) {
    bool valid = true;
    if (selectedCuisineOptionTags.isEmpty) {
      valid = false;
    }
    RestaurantMealFormState newFormState = RestaurantMealFormState(
      fieldValidationMap: {
        ...initialState.fieldValidationMap,
        FIELD_VALIDATION_KEY_CUISINES: valid
      },
      name: initialState.name,
      selectedAllergyOptionTags: initialState.selectedAllergyOptionTags,
      selectedCuisineOptionTags: selectedCuisineOptionTags,
      image: initialState.image,
      description: initialState.description,
    );
    changed(newFormState);
  }

  emitImageChange(String image) {
    RestaurantMealFormState newFormState = RestaurantMealFormState(
      fieldValidationMap: initialState.fieldValidationMap,
      name: initialState.name,
      selectedAllergyOptionTags: initialState.selectedAllergyOptionTags,
      selectedCuisineOptionTags: initialState.selectedCuisineOptionTags,
      image: image,
      description: initialState.description,
    );
    changed(newFormState);
  }

  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var mealImage;
    if (initialState == null || initialState.image == null) {
      mealImage = NetworkImage('http://www.fillmurray.com/400/300');
    } else if (initialState.image.startsWith(
      new RegExp("(http:)|(https:)"),
    )) {
      mealImage = NetworkImage(initialState.image);
    } else {
      mealImage = FileImage(File(initialState.image));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          width: viewportConstraints.maxWidth,
          height: viewportConstraints.maxHeight / 2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: mealImage,
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final pickedFile =
                      await imagePicker.getImage(source: ImageSource.camera);

                  emitImageChange(pickedFile.path);
                },
                child: Text("Change"),
              ),
            ],
          ),
        ),
        Container(
          width: viewportConstraints.maxWidth,
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(initialState.name ?? ''),
              TextFormField(
                initialValue: initialState.name ?? '',
                decoration: InputDecoration(labelText: "Meal Name"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onChanged: (change) {
                  developer.log("CHANGED $change");
                  emitNameChange(change);
                },
              ),
              FlutterTagging<AllergyOptionTag>(
                initialItems: initialState.selectedAllergyOptionTags ?? [],
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
                      .then<List<AllergyOptionTag>>((allergyOptionsResponse) {
                    return List.from(
                      (allergyOptionsResponse).allergyOptions.map(
                        (option) {
                          developer.log('OPTION $option');
                          return AllergyOptionTag(allergyOption: option);
                        },
                      ),
                    );
                  }).catchError((error) {
                    return List<AllergyOptionTag>.from([]);
                  });
                },
                configureSuggestion: (allergyTag) {
                  return SuggestionConfiguration(
                    title: Text(allergyTag?.allergyOption?.name ?? ''),
                  );
                },
                configureChip: (allergyTag) {
                  return ChipConfiguration(
                    label: Text(allergyTag?.allergyOption?.name ?? ''),
                    backgroundColor: Colors.red,
                    labelStyle: TextStyle(color: Colors.white),
                    deleteIconColor: Colors.white,
                  );
                },
                onChanged: () {
                  emitSelectedAllergiesChange(
                      initialState.selectedAllergyOptionTags);
                },
              ),
              FlutterTagging<CuisineOptionTag>(
                initialItems: initialState.selectedCuisineOptionTags ?? [],
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
                      .then<List<CuisineOptionTag>>((cuisineOptionsResponse) {
                    return List.from(
                        (cuisineOptionsResponse).cuisineOptions.map((option) {
                      return CuisineOptionTag(cuisineOption: option);
                    }));
                  }).catchError((error) {
                    developer.log("ERROR!!!!! $error");
                    return List<CuisineOptionTag>.from([]);
                  });
                },
                configureSuggestion: (cuisineTag) {
                  return SuggestionConfiguration(
                    title: Text(cuisineTag?.cuisineOption?.name ?? ''),
                  );
                },
                configureChip: (cuisineTag) {
                  return ChipConfiguration(
                    label: Text(cuisineTag?.cuisineOption?.name ?? ''),
                    backgroundColor: Colors.amber[900],
                    labelStyle: TextStyle(color: Colors.white),
                    deleteIconColor: Colors.white,
                  );
                },
                onChanged: () {
                  emitSelectedCuisinesChange(
                      initialState.selectedCuisineOptionTags);
                },
              ),
              TextFormField(
                initialValue: initialState.description,
                minLines: 3,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
                onChanged: (change) {
                  emitDescriptionChange(change);
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 60),
      ],
    );
  }
}
