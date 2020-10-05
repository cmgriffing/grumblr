import 'package:dio/dio.dart';
import 'dart:developer' as developer;

import 'package:grumblr/mocks/mocks.dart';

const String BASE_API_URL = 'https://api.grumblr.food/v1';
const bool shouldMockResponse = true;

class Http {
  static final Http _instance = Http._privateConstructor();

  factory Http() {
    return _instance;
  }

  Dio _dio = Dio();

  Http._privateConstructor() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      if (shouldMockResponse) {
        String mockedPath = options.path;
        if (options.extra.isNotEmpty && options.extra.containsKey("ids")) {
          options.extra["ids"].forEach((Map idMap) {
            mockedPath =
                mockedPath.replaceAll(idMap["realId"], idMap["mockId"]);
          });
        }
        developer.log("MOCKED PATH $mockedPath");

        if (!Mocks().routeMocks.containsKey(mockedPath)) {
          // attach token here?
          return options;
        }
        Map mockedRouteData = await Mocks().routeMocks[mockedPath](options);

        developer.log('OPTIONS $options');

        developer.log('Mocked Route Data: $mockedRouteData');

        return Response(
          data: {"mocked": true, ...mockedRouteData},
          statusCode: 200,
        );
      } else {
        // attach token here?
        return options; //continue
      }
    }, onResponse: (Response response) async {
      // eventually handle 401/403
      // developer.log("${response.statusCode} Response: ${response.data}");
      return response; // continue
    }, onError: (DioError e) async {
      developer.log("Error encountered: ${e.message}");
      return e; //continue
    }));
  }

  get(
    String path, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    void Function(int, int) onReceiveProgress,
  }) {
    return _dio.get(
      '$BASE_API_URL$path',
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  post(String path,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      void Function(int, int) onSendProgress,
      void Function(int, int) onReceiveProgress}) {
    return _dio.post(
      '$BASE_API_URL$path',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  put(String path,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      void Function(int, int) onSendProgress,
      void Function(int, int) onReceiveProgress}) {
    return _dio.put(
      '$BASE_API_URL$path',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  delete(String path,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken}) {
    return _dio.delete(
      '$BASE_API_URL$path',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
