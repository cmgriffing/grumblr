import 'package:get/get.dart';
import 'dart:developer' as developer;

class RxRouterState extends GetxController {
  final currentPage = '/'.obs;

  factory RxRouterState() {
    return _instance;
  }

  static final RxRouterState _instance = RxRouterState._privateConstructor();

  RxRouterState._privateConstructor();
}
