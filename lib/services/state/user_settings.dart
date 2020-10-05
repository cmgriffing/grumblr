import 'package:get/get.dart';
import 'dart:developer' as developer;

class RxUserSettings extends GetxController {
  final discoveryRadius = 10.0.obs;
  final discoveryLatitude = 42.0.obs;
  final discoveryLongitude = 42.0.obs;

  final selectedAllergies = [].obs;

  final selectedCuisineFilterState = [
    true,
    false,
    false,
  ].obs;
  final selectedCuisines = [].obs;

  final selectedDiet = 'None'.obs;

  final selectedFulfillmentOptions = {
    'dineIn': true,
    'takeOut': true,
    'deliveryInHouse': true,
    'deliveryDoorDash': false,
    'deliveryUberEats': false,
    'deliveryJustEat': false,
    'deliveryMenuLog': false,
    'deliveryDeliveroo': false,
  }.obs;

  static final RxUserSettings _instance = RxUserSettings._privateConstructor();

  factory RxUserSettings() {
    return _instance;
  }

  RxUserSettings._privateConstructor();
}
