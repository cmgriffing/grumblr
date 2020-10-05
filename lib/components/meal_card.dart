import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grumblr/components/chip_counter.dart';
import 'package:grumblr/mocks/core/restaurants.dart';
import 'package:grumblr/services/api/restaurants.dart';
import 'package:grumblr/types/meal.dart';

const double CARD_CONTENT_WIDTH = 210;

enum MealMenuOption { delete, edit, setAsFeatured, removeFeatured }

class MealCard extends StatelessWidget {
  MealCard({
    this.viewportConstraints,
    this.meal,
    this.isFeatured,
    this.featuredSet,
    this.featuredUnset,
  });

  final BoxConstraints viewportConstraints;
  final Meal meal;
  final bool isFeatured;
  final Function featuredSet;
  final Function featuredUnset;

  @override
  Widget build(BuildContext context) {
    String favoritedStar = '';
    if (isFeatured) {
      favoritedStar = '⭑';
    }

    var mealImage;
    if (meal == null || meal.imageUrl == null) {
      mealImage = NetworkImage('http://www.fillmurray.com/400/300');
    } else if (meal.imageUrl.startsWith(
      new RegExp("(http:)|(https:)"),
    )) {
      mealImage = NetworkImage(meal.imageUrl);
    } else {
      mealImage = FileImage(File(meal.imageUrl));
    }

    return Container(
      padding: EdgeInsets.all(8),
      child: Card(
        color: isFeatured ? Color.fromRGBO(255, 235, 235, 1) : Colors.white,
        elevation: isFeatured ? 8 : 2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: 120,
                minWidth: viewportConstraints.maxWidth * 0.15,
                maxWidth: viewportConstraints.maxWidth * 0.15,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image(image: mealImage),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: CARD_CONTENT_WIDTH,
                      child: Text(
                        "$favoritedStar${meal.name}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                      ),
                    ),
                    Container(
                      width: CARD_CONTENT_WIDTH,
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        meal.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if (meal.allergies.isNotEmpty)
                      ChipCounter(
                        label: "Allergies",
                        count: meal.allergies.length,
                      ),
                  ],
                ),
              ),
            ),
            Expanded(child: Text("")),
            Container(
                child: PopupMenuButton(
              icon: Icon(Icons.settings),
              onSelected: (MealMenuOption result) {
                if (result == MealMenuOption.edit) {
                  Get.toNamed('/restaurant/meals/${meal.id}/edit');
                } else if (result == MealMenuOption.setAsFeatured) {
                  ApiRestaurantService()
                      .setMealAsFeatured(CURRENT_RESTAURANT_ID, meal.id)
                      .then((result) {
                    featuredSet(meal.id);
                  });
                } else if (result == MealMenuOption.removeFeatured) {
                  ApiRestaurantService()
                      .removeMealAsFeatured(CURRENT_RESTAURANT_ID, meal.id)
                      .then((result) {
                    featuredUnset(meal.id);
                  });
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<MealMenuOption>>[
                PopupMenuItem<MealMenuOption>(
                  value: MealMenuOption.edit,
                  child: Text('Edit'),
                ),
                if (!isFeatured)
                  PopupMenuItem<MealMenuOption>(
                    value: MealMenuOption.setAsFeatured,
                    child: Text('Set as Featured'),
                  ),
                if (isFeatured)
                  PopupMenuItem<MealMenuOption>(
                    value: MealMenuOption.removeFeatured,
                    child: Text('Remove as Featured'),
                  ),
                PopupMenuItem<MealMenuOption>(
                  value: MealMenuOption.delete,
                  child: Text('Delete'),
                ),
              ],
            )

                // IconButton(
                //   icon: Icon(Icons.settings),
                //   onPressed: null,
                // ),
                )
          ],
        ),
      ),
    );
  }
}
