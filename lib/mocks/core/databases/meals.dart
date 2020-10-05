
import 'package:grumblr/mocks/core/data/meals.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';

class MealsDatabase {
  Database db;
  StoreRef store = intMapStoreFactory.store('meals');

  openDatabase() async {
    DatabaseFactory dbFactory = databaseFactoryMemory;
    db = await dbFactory.openDatabase('meals.db', version: 1,
        onVersionChanged: (db, oldVersion, newVersion) async {
      // If the db does not exist, create some data
      if (oldVersion == 0) {
        await store.addAll(db, mealsMocks);
      }
    });
  }

  factory MealsDatabase() {
    return _instance;
  }

  static final MealsDatabase _instance = MealsDatabase._privateConstructor();

  MealsDatabase._privateConstructor() {
    openDatabase();
  }
}