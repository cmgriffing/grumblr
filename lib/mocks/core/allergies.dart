import 'package:dio/dio.dart';

Map allergiesRouteMocks = {
  "/allergies/options": (RequestOptions requestOptions) => {
    "allergyOptions": [
      {
        "id": "a123",
        "name": "Peanut",
        "shortName": "Peanut"
      },
      {
        "id": "a124",
        "name": "Shellfish",
        "shortName": "Shellfish"
      },
      {
        "id": "a125",
        "name": "Milk",
        "shortName": "Milk"
      },
      {
        "id": "a126",
        "name": "Eggs",
        "shortName": "Eggs"
      },
    ]
  },
};
