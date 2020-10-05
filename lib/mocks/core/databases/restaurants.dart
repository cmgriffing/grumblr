
import 'package:grumblr/mocks/core/data/restaurants.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';

class RestaurantsDatabase {
  Database db;
  StoreRef store = intMapStoreFactory.store('restaurants');

  openDatabase() async {
    DatabaseFactory dbFactory = databaseFactoryMemory;
    db = await dbFactory.openDatabase('restaurants.db', version: 1,
        onVersionChanged: (db, oldVersion, newVersion) async {
      // If the db does not exist, create some data
      if (oldVersion == 0) {
        await store.addAll(db, restaurantsMocks);
      }
    });
  }

  factory RestaurantsDatabase() {
    return _instance;
  }

  static final RestaurantsDatabase _instance =
      RestaurantsDatabase._privateConstructor();

  RestaurantsDatabase._privateConstructor() {
    openDatabase();
  }
}