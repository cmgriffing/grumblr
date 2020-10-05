import 'package:flutter/material.dart';
import 'package:grumblr/components/formatted_address.dart';
import 'package:grumblr/types/restaurant.dart';

class MealRestaurantDetails extends StatelessWidget {
  MealRestaurantDetails({this.restaurant, this.viewportConstraints});

  final Restaurant restaurant;
  final BoxConstraints viewportConstraints;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: viewportConstraints.maxWidth - 16,
            height: 142,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(restaurant.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Icon(Icons.favorite)),
        Row(
          children: [
            Container(
              width: viewportConstraints.maxWidth / 2 - 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FormattedAddress(address: restaurant.address),
                ],
              ),
            ),
            Container(
              width: viewportConstraints.maxWidth / 2 - 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(restaurant.description)],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
