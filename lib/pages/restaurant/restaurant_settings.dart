import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grumblr/components/chip_counter.dart';
import 'dart:developer' as developer;

import 'package:grumblr/components/formatted_address.dart';
import 'package:grumblr/components/meal/meal_allergies_list.dart';
import 'package:grumblr/components/meal_card.dart';
import 'package:grumblr/mocks/core/restaurants.dart';
import 'package:grumblr/services/api/restaurants.dart';
import 'package:grumblr/services/state/router.dart';
import 'package:grumblr/types/restaurant.dart';
import 'package:grumblr/types/restaurant_details.dart';

class RestaurantSettingsPage extends StatefulWidget {
  RestaurantSettingsPage({Key key}) : super(key: key);

  final String title = 'Restaurant Settings';

  @override
  _RestaurantSettingsPageState createState() => _RestaurantSettingsPageState();
}

class _RestaurantSettingsPageState extends State<RestaurantSettingsPage> {
  RestaurantDetails restaurantDetails;
  StreamSubscription routeSubscription;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRestaurantSettings(CURRENT_RESTAURANT_ID);

    routeSubscription = RxRouterState().currentPage.listen((page) {
      developer.log('fetching');
      if (page == '/restaurant/settings') {
        fetchRestaurantSettings(CURRENT_RESTAURANT_ID);
      }
    });
  }

  fetchRestaurantSettings(restaurantId) async {
    RestaurantDetailsResponse response =
        await ApiRestaurantService().getRestaurantDetails(restaurantId);
    setState(() {
      developer.log("before $restaurantDetails");
      restaurantDetails = response.restaurantDetails;
      developer.log("after $restaurantDetails");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
        builder: (context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Center(
                child: Container(
                  constraints:
                      BoxConstraints(minHeight: viewportConstraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              minHeight: 120,
                              maxWidth: viewportConstraints.maxWidth * 0.4,
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    "http://www.fillmurray.com/400/400"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            constraints: BoxConstraints(
                              minHeight: 120,
                              maxWidth: viewportConstraints.maxWidth * 0.6,
                            ),
                            child: Column(
                              children: [
                                Text('Restaurant Title'),
                                TextField(
                                  minLines: 3,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Description',
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: viewportConstraints.maxWidth,
                        padding: EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          left: 12,
                          right: 12,
                        ),
                        decoration: BoxDecoration(color: Colors.red),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: Colors.white,
                            ),
                            Text(
                              "Address",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.white),
                            ),
                            Expanded(child: Text("")),
                            RaisedButton.icon(
                              color: Colors.red,
                              textColor: Colors.white,
                              elevation: 12,
                              onPressed: () {},
                              icon: Icon(Icons.map),
                              label: Text("Change"),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            constraints: BoxConstraints(
                              minHeight: 120,
                              minWidth: viewportConstraints.maxWidth * 0.6,
                              maxWidth: viewportConstraints.maxWidth * 0.6,
                            ),
                            child: FormattedAddress(
                              address: Address(
                                  line1: "123 Foo Drive",
                                  municipality: "Seattle",
                                  province: "WA",
                                  postalCode: "12345"),
                            ),
                          ),
                          // Container(
                          //   padding: EdgeInsets.all(8),
                          //   constraints: BoxConstraints(
                          //     minHeight: 120,
                          //     minWidth: viewportConstraints.maxWidth * 0.4,
                          //     maxWidth: viewportConstraints.maxWidth * 0.4,
                          //   ),
                          //   child: FittedBox(

                          //     fit: BoxFit.contain,
                          //     child: Image.network(
                          //         'https://www.fillmurray.com/240/240'),
                          //   ),
                          // ),
                        ],
                      ),
                      Container(
                        width: viewportConstraints.maxWidth,
                        padding: EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          left: 12,
                          right: 12,
                        ),
                        decoration: BoxDecoration(color: Colors.red),
                        child: Row(
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              color: Colors.white,
                            ),
                            Text(
                              "Featured Meals",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.white),
                            ),
                            Expanded(child: Text("")),
                            RaisedButton.icon(
                              textColor: Colors.white,
                              color: Colors.red,
                              elevation: 12,
                              onPressed: () {
                                Get.toNamed('/restaurant/meals/manage');
                              },
                              icon: Icon(Icons.settings),
                              label: Text("Manage"),
                            ),
                          ],
                        ),
                      ),
                      if (restaurantDetails?.featuredMeals != null)
                        ...restaurantDetails.featuredMeals.map(
                          (meal) => MealCard(
                            meal: meal,
                            viewportConstraints: viewportConstraints,
                            isFeatured: true,
                          ),
                        )
                      else
                        Text('No Featured Meals set.'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/*

Restaurant Details

name field

address lookup field

image picker

description textarea

meals management

*/
