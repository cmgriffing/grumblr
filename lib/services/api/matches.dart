import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:grumblr/http.dart';
import 'dart:developer' as developer;

import 'package:grumblr/types/meal.dart';

class Match {
  final Meal meal;

  Match({this.meal});
}

class MatchesResponse {
  List<Match> matches;

  MatchesResponse({this.matches});

  factory MatchesResponse.fromJson(dynamic json) {
    List matches = List.from(json['matches'])
        .map(
          (rawMatch) => Match(
            meal: Meal(
              name: rawMatch['meal'].name,
              id: rawMatch['meal'].id,
              imageUrl: rawMatch['meal'].imageUrl,
            ),
          ),
        )
        .toList();

    return MatchesResponse(matches: matches);
  }
}

class ApiMatchService {
  Future<MatchesResponse> getMatches() {
    return Http().get('/matches').then<MatchesResponse>((Response response) {
      return MatchesResponse.fromJson(response.data);
    });
  }


  /*
  Future<MatchesResponse> clearMatches() {
    return Http().get('/matches').then<MatchesResponse>((Response response) {
      return MatchesResponse.fromJson(response.data);
    });
  }

// how should we handle previously added items


  */
}
