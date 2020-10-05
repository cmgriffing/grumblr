import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grumblr/components/app_showcase.dart';
import 'package:grumblr/pages/home.dart';
import 'package:grumblr/services/state/onboarding.dart';
import 'package:grumblr/services/state/results.dart';
import 'dart:developer' as developer;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import 'package:grumblr/services/state/user_settings.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeResultsView extends StatefulWidget {
  final Function buildHook;

  HomeResultsView({Key key, this.buildHook}) : super(key: key);

  @override
  _HomeResultsViewState createState() => _HomeResultsViewState();
}

class _HomeResultsViewState extends State<HomeResultsView> {
  RxUserSettings userSettings = RxUserSettings();
  RxSwipeResults swipeResults = RxSwipeResults();

  ScrollController favoritesScrollController = ScrollController();
  ScrollController likedScrollController = ScrollController();

  bool finished = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.buildHook();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, viewportConstraints) {
          return Center(
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (swipeResults.favoritedMeals.value.length > 0)
                    AppShowcase(
                      showcaseKey: RxOnboardingState
                          .globalKeyMap[OnboardingStepParts.homeResultsFavorites],
                      description: 'Your Favorites and will be here.\n You can manage them and\n your "Never Agains" with the button.',
                      child: Container(
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
                              Icons.favorite,
                              color: Colors.white,
                            ),
                            Text(
                              " Favorites",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Badge(
                              badgeColor: Colors.white,
                              badgeContent: Obx(
                                () => Text(
                                    "${swipeResults.favoritedMeals.value.length}",
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ),
                            Expanded(child: Text("")),
                            ElevatedButton(
                                onPressed: () {}, child: Text("Manage"))
                          ],
                        ),
                      ),
                    ),
                  if (swipeResults.favoritedMeals.value.length > 0)
                    Scrollbar(
                      controller: favoritesScrollController,
                      isAlwaysShown: true,
                      child: SizedBox(
                        height: 142,
                        child: GridView.count(
                          controller: favoritesScrollController,
                          scrollDirection: Axis.horizontal,
                          crossAxisCount: 1,
                          children: [
                            ...swipeResults.favoritedMeals.value,
                          ]
                              .map(
                                (meal) => GestureDetector(
                                  onTap: () {
                                    developer.log('tapped meal ${meal.name}');
                                    Get.toNamed('/meal/${meal.id}');
                                  },
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Image.network(meal.imageUrl),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  if (swipeResults.likedMeals.value.length > 0)
                    AppShowcase(
                      showcaseKey: RxOnboardingState
                          .globalKeyMap[OnboardingStepParts.homeResultsLiked],
                      description: 'The Liked meals from swiping will be here.',
                      child: Container(
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
                              Icons.thumb_up,
                              color: Colors.white,
                            ),
                            Text(
                              " Liked",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Badge(
                              badgeColor: Colors.white,
                              badgeContent: Obx(
                                () => Text(
                                    "${swipeResults.likedMeals.value.length}",
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (swipeResults.likedMeals.value.length > 0)
                    Expanded(
                      child: Scrollbar(
                        controller: likedScrollController,
                        isAlwaysShown: true,
                        child: GridView.count(
                          controller: likedScrollController,
                          crossAxisCount: 3,
                          children: [
                            ...swipeResults.likedMeals.value,
                          ].map((meal) {
                            Widget gridItem = GestureDetector(
                              onTap: () {
                                developer.log('tapped meal ${meal.name}');
                                Get.toNamed('/meal/${meal.id}');
                              },
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Image.network(meal.imageUrl),
                              ),
                            );

                            Widget wrappedGridItem = gridItem;
                            if (meal.id == 'm123') {
                              wrappedGridItem = AppShowcase(
                                  showcaseKey: RxOnboardingState.globalKeyMap[
                                      OnboardingStepParts.homeResultsLikedMeal],
                                  description: 'Click a liked meal to view\n the details, including Allergy info.',
                                  child: gridItem);
                            }
                            return wrappedGridItem;
                          }).toList(),
                        ),
                      ),
                    ),
                  if (swipeResults.likedMeals.value.length == 0)
                    Text('No Results found.', style: TextStyle(fontSize: 42)),
                  if (swipeResults.likedMeals.value.length == 0)
                    Text('Get to swiping to see some\n results to choose from.')
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Obx(
        () => SpeedDial(
          // both default to 16
          marginRight: 18,
          marginBottom: 20,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          // this is ignored if animatedIcon is non null
          // child: Icon(Icons.add),
          visible: swipeResults.likedMeals.value.length > 0,
          // If true user is forced to close dial manually
          // by tapping main button and overlay is not rendered.
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.red[700],
          foregroundColor: Colors.white,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.do_not_disturb),
              backgroundColor: Colors.red,
              label: 'Clear List',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                swipeResults.reset();
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.sync),
              backgroundColor: Colors.blue,
              label: 'Swipe Only These',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                Get.toNamed('/home/swiper/swiped');
              },
            ),
          ],
        ),
      ),
    );
  }
}
