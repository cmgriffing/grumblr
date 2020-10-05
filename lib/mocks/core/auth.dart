import 'package:dio/dio.dart';

Map authRouteMocks = {
  "/login": (RequestOptions requestOptions) => {
    "authToken": "abc123",
    "refreshToken": "def456"
  },
  "/register":(RequestOptions requestOptions) =>  {
    "authToken": "abc123",
    "refreshToken": "def456"
  },
  "/validate": (RequestOptions requestOptions) => {
    "valid": true,
  }
};
