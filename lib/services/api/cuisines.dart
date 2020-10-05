import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:grumblr/http.dart';
import 'dart:developer' as developer;

class CuisineOption {
  final String id;
  final String name;
  final String shortName;

  CuisineOption({this.id, this.name, this.shortName});
}

class CuisineOptionsResponse {
  List<CuisineOption> cuisineOptions;

  CuisineOptionsResponse({this.cuisineOptions});

  factory CuisineOptionsResponse.fromJson(dynamic json) {
    List cuisineOptions = List.from(json['cuisineOptions']).map((rawOption) =>
        CuisineOption(id: rawOption['id'], name: rawOption['name'])).toList();

    return CuisineOptionsResponse(cuisineOptions: cuisineOptions);
  }
}

class ApiCuisineService {
  Future<CuisineOptionsResponse> getCuisineOptions() {
    return Http().get('/cuisines/options').then<CuisineOptionsResponse>((Response response) {
      return CuisineOptionsResponse.fromJson(response.data);
    });
  }
}
