import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:grumblr/mocks/core/databases/settings.dart';
import 'package:sembast/sembast.dart';

const double USER_LATITUDE = 42.0;
const double USER_LONGITUDE = 42.0;

const String USER_ID = 'u42';

Map userSettingsRouteMocks = {
  "/users/$USER_ID/settings": (RequestOptions requestOptions) async {
    UserSettingsDatabase settingsDb = UserSettingsDatabase();
    String userId = USER_ID;

    requestOptions.extra["ids"].forEach((Map idMap) {
      if (idMap["mockId"] == USER_ID) {
        userId = idMap["realId"];
      }
    });

    if (requestOptions.method == 'GET') {
      var record = await settingsDb.store.findFirst(
        settingsDb.db,
        finder: Finder(
          filter: Filter.equals('user_id', userId),
        ),
      );

      developer.log('record: ${record.value}');
      return {"settings": record.value};
    } else {
      var recordCount = await settingsDb.store.update(
        settingsDb.db,
        requestOptions.data,
        finder: Finder(
          filter: Filter.equals('user_id', userId),
        ),
      );

      developer.log('records modified: $recordCount');
      return {"settings": requestOptions.data};
    }
  },
};
