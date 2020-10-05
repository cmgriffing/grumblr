import 'package:flutter/material.dart';
import 'package:grumblr/services/api/allergies.dart';
import 'package:grumblr/types/meal.dart';

class MealAllergiesList extends StatelessWidget {
  MealAllergiesList({this.allergies, this.width});

  final List<AllergyOption> allergies;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Colors.red,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.red),
            child: Row(
              children: [
                Icon(
                  Icons.report_problem,
                  color: Colors.white,
                ),
                Text(
                  "Allergy Info",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Wrap(
            children: [
              ...allergies.map(
                (allergy) => Container(
                  height: 36,
                  padding: EdgeInsets.only(
                    left: 4,
                    right: 4,
                    top: 2,
                    bottom: 2,
                  ),
                  child: Chip(
                    padding: EdgeInsets.all(0),
                    label: Text(allergy.name),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
