import 'package:dio/dio.dart';

Map cuisinesRouteMocks = {
  "/cuisines/options":(RequestOptions requestOptions) =>  {
    "cuisineOptions": [
      {
        "id": "c123",
        "name": "Pizza",
        "shortName": "Pizza"
      },
      {
        "id": "c124",
        "name": "Seafood",
        "shortName": "Seafood"
      },
      {
        "id": "c125",
        "name": "Pub",
        "shortName": "Pub"
      },
      {
        "id": "c126",
        "name": "Breakfast",
        "shortName": "Breakfast"
      },
    ]
  },
};
