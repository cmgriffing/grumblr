import 'package:grumblr/mocks/core/data/meals.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';

class FeaturedMealsDatabase {
  Database db;
  StoreRef store = intMapStoreFactory.store('featured_meals');

  openDatabase() async {
    DatabaseFactory dbFactory = databaseFactoryMemory;
    db = await dbFactory.openDatabase(
      'featured_meals.db',
      version: 1,
    );
  }

  factory FeaturedMealsDatabase() {
    return _instance;
  }

  static final FeaturedMealsDatabase _instance =
      FeaturedMealsDatabase._privateConstructor();

  FeaturedMealsDatabase._privateConstructor() {
    openDatabase();
  }
}
