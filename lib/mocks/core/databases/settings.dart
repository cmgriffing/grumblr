import 'package:grumblr/mocks/core/data/settings.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';

class UserSettingsDatabase {
  Database db;
  StoreRef store = intMapStoreFactory.store('settings');

  openDatabase() async {
    DatabaseFactory dbFactory = databaseFactoryMemory;
    db = await dbFactory.openDatabase('settings.db', version: 1,
        onVersionChanged: (db, oldVersion, newVersion) async {
      // If the db does not exist, create some data
      if (oldVersion == 0) {
        await store.addAll(db, userSettingsMocks);
      }
    });
  }

  factory UserSettingsDatabase() {
    return _instance;
  }

  static final UserSettingsDatabase _instance = UserSettingsDatabase._privateConstructor();

  UserSettingsDatabase._privateConstructor() {
    openDatabase();
  }
}