import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum FulfillmentOptions {
  dineIn,
  takeOut,
  deliveryInHouse,
  deliveryDoorDash,
  deliveryUberEats,
  deliveryJustEat,
  deliveryMenuLog,
  deliveryDeliveroo
}

const Map fulfillmentOptionsKeyMap = {
  FulfillmentOptions.dineIn: 'dineIn',
  FulfillmentOptions.takeOut: 'takeOut',
  FulfillmentOptions.deliveryInHouse: 'deliveryInHouse',
  FulfillmentOptions.deliveryDoorDash: 'deliveryDoorDash',
  FulfillmentOptions.deliveryUberEats: 'deliveryUberEats',
  FulfillmentOptions.deliveryJustEat: 'deliveryJustEat',
  FulfillmentOptions.deliveryMenuLog: 'deliveryMenuLog',
  FulfillmentOptions.deliveryDeliveroo: 'deliveryDeliveroo',
};

class FulfillmentOption {
  final FulfillmentOptions type;
  final String name;
  final String key;
  final bool defaultValue;
  final Icon icon;

  FulfillmentOption(
      {this.type, this.name, this.key, this.defaultValue, this.icon});

  toMap() {
    return {
      "type": fulfillmentOptionsKeyMap[type],
      "name": name,
      "key": key,
      "defaultValue": defaultValue,
      "icon": icon
    };
  }
}

final List<FulfillmentOption> allFulfillmentOptions = [
  FulfillmentOption(
      name: "Dine-in",
      key: fulfillmentOptionsKeyMap[FulfillmentOptions.dineIn],
      defaultValue: true,
      icon: Icon(Icons.restaurant)),
  FulfillmentOption(
      name: "Takeout",
      key: fulfillmentOptionsKeyMap[FulfillmentOptions.takeOut],
      defaultValue: true,
      icon: Icon(Icons.restaurant_menu)),
  FulfillmentOption(
    name: "Delivery (in-house)",
    key: fulfillmentOptionsKeyMap[FulfillmentOptions.deliveryInHouse],
    defaultValue: true,
    icon: Icon(Icons.delivery_dining),
  ),
  FulfillmentOption(
    name: "Delivery (DoorDash)",
    key: fulfillmentOptionsKeyMap[FulfillmentOptions.deliveryDoorDash],
    defaultValue: false,
    icon: Icon(Icons.sensor_door),
  ),
  FulfillmentOption(
    name: "Delivery (Uber Eats)",
    key: fulfillmentOptionsKeyMap[FulfillmentOptions.deliveryUberEats],
    defaultValue: false,
    icon: Icon(Icons.car_rental),
  ),
  FulfillmentOption(
    name: "Delivery (Just Eat)",
    key: fulfillmentOptionsKeyMap[FulfillmentOptions.deliveryJustEat],
    defaultValue: false,
    icon: Icon(Icons.set_meal),
  ),
];
