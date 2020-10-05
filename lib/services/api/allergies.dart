import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:grumblr/http.dart';
import 'dart:developer' as developer;

class AllergyOption {
  final String id;
  final String name;
  final String shortName;

  AllergyOption({this.id, this.name, this.shortName});

  toMap() {
    return {
      "id": id,
      "name": name,
      "shortName": shortName,
    };
  }
}

class AllergyOptionsResponse {
  List<AllergyOption> allergyOptions;

  AllergyOptionsResponse({this.allergyOptions});

  factory AllergyOptionsResponse.fromJson(dynamic json) {
    developer.log("Transforming!!!! ${json['allergyOptions']}");
    // developer.log("Transforming json $json");

    List allergyOptions = List.from(json['allergyOptions'])
        .map((rawOption) =>
            AllergyOption(id: rawOption['id'], name: rawOption['name']))
        .toList();

    return AllergyOptionsResponse(allergyOptions: allergyOptions);
  }
}

class ApiAllergyService {
  Future<AllergyOptionsResponse> getAllergyOptions() {
    return Http()
        .get('/allergies/options')
        .then<AllergyOptionsResponse>((Response response) {
      developer.log("api allergy response ${response.data.runtimeType}");
      return AllergyOptionsResponse.fromJson(response.data);
    });
  }
}
