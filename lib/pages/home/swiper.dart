import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:grumblr/components/app_showcase.dart';
import 'package:grumblr/mocks/core/meals.dart';
import 'package:grumblr/mocks/core/settings.dart';
import 'package:get/get.dart';

import 'package:grumblr/services/api/meals.dart';
import 'package:grumblr/services/state/onboarding.dart';
import 'package:grumblr/services/state/results.dart';
import 'package:grumblr/services/state/user_settings.dart';
import 'package:grumblr/types/meal.dart';
import 'package:showcaseview/showcaseview.dart';

const Map TriggerDirectionToCardSwipeDirection = {
  TriggerDirection.left: CardSwipeOrientation.LEFT,
  TriggerDirection.right: CardSwipeOrientation.RIGHT,
  TriggerDirection.up: CardSwipeOrientation.UP,
  TriggerDirection.down: CardSwipeOrientation.DOWN,
  TriggerDirection.none: CardSwipeOrientation.RECOVER,
};

const Map CardSwipeDirectionToTriggerDirection = {
  CardSwipeOrientation.LEFT: TriggerDirection.left,
  CardSwipeOrientation.RIGHT: TriggerDirection.right,
  CardSwipeOrientation.UP: TriggerDirection.up,
  CardSwipeOrientation.DOWN: TriggerDirection.down,
  CardSwipeOrientation.RECOVER: TriggerDirection.none,
};

const String TAB_CONTEXT_NONE = 'none';
const String TAB_CONTEXT_SWIPED = 'swiped';

class FoodImage {
  FoodImage(this.name, this.url, this.meal);

  Meal meal;

  String name;
  String url;
}

class HomeSwiperView extends StatefulWidget {
  final CardController controller;

  HomeSwiperView({Key key, this.controller}) : super(key: key);

  @override
  _HomeSwiperViewState createState() => _HomeSwiperViewState();
}

class _HomeSwiperViewState extends State<HomeSwiperView> {
  List<FoodImage> _images = [];

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

    fetchMeals();
  }

  fetchMeals() async {
    String tabContext;
    if (Get.parameters != null) {
      tabContext = Get.parameters['tabContext'];
    }
    if (tabContext == TAB_CONTEXT_NONE || tabContext == null) {
      double latitude = RxUserSettings().discoveryLatitude.value;
      double longitude = RxUserSettings().discoveryLongitude.value;

      List<Meal> meals =
          (await ApiMealService().getLocalMeals(latitude, longitude)).meals;

      List<FoodImage> newImages = List.from(meals.map((meal) {
        return FoodImage(meal.name, meal.imageUrl, meal);
      }));

      setState(() {
        _images = newImages;
      });
    } else if (tabContext == TAB_CONTEXT_SWIPED) {
      List<Meal> meals = [
        ...RxSwipeResults().favoritedMeals.value,
        ...RxSwipeResults().likedMeals.value
      ];

      List<FoodImage> newImages = List.from(
        meals.map(
          (meal) {
            return FoodImage(meal.name, meal.imageUrl, meal);
          },
        ),
      );

      setState(() {
        _images = newImages;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    RxSwipeResults swipeResults = RxSwipeResults();

    String tabContext = Get.parameters['tabContext'];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, viewportConstraints) {
          return Stack(children: [
            // Container(
            //                       alignment: Alignment(0, 0),
            //                       height: 100,
            //                       width: 100,
            //                       decoration: BoxDecoration(color: Colors.blue),
            //                       child: AppShowcase(
            //                     key: RxOnboardingState.globalKeyMap[OnboardingStepParts.homeSwiperSwipeRight],
            //                     description: 'Tap to see menu options',
            //                     child: Text('foo'),
            //                     ),
            // ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (tabContext == TAB_CONTEXT_SWIPED)
                    Container(
                      color: Colors.yellowAccent[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 2),
                            child: Text(
                              "Showing Filtered Results ",
                              style: TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.offAllNamed('/home/swiper/none');
                            },
                            child: Text("Show All"),
                          ),
                        ],
                      ),
                    ),
                  if (!finished)
                    Flexible(
                      child: TinderSwapCard(
                        swipeUp: true,
                        swipeDown: true,
                        orientation: AmassOrientation.BOTTOM,
                        totalNum: _images.length,
                        stackNum: 3,
                        swipeEdge: 4.0,
                        maxWidth: MediaQuery.of(context).size.width * 0.98,
                        maxHeight: MediaQuery.of(context).size.height * 0.75,
                        minWidth: MediaQuery.of(context).size.width * 0.80,
                        minHeight: MediaQuery.of(context).size.height * 0.70,
                        cardBuilder: (context, index) {
                          Widget image = FittedBox(
                            child: Card(
                                child: Image.network('${_images[index].url}')),
                            fit: BoxFit.fitHeight,
                          );
                          Widget wrappedImage = image;
                          if (index == 0) {
                            wrappedImage = AppShowcase(
                              showcaseKey: RxOnboardingState.globalKeyMap[
                                  OnboardingStepParts.homeSwiperSwipeRight],
                              description: 'Swipe Right to Like a meal.',
                              child: image,
                            );
                          }

                          if (index == 1) {
                            wrappedImage = AppShowcase(
                              showcaseKey: RxOnboardingState.globalKeyMap[
                                  OnboardingStepParts.homeSwiperSwipeLeft],
                              description: 'Swipe Left to dislike a meal.',
                              child: image,
                            );
                          }

                          if (index == 2) {
                            wrappedImage = AppShowcase(
                              showcaseKey: RxOnboardingState.globalKeyMap[
                                  OnboardingStepParts.homeSwiperSwipeUp],
                              description: 'Swiping up, favorites a meal \n and saves it for future use.',
                              child: image,
                            );
                          }

                          if (index == 3) {
                            wrappedImage = AppShowcase(
                              showcaseKey: RxOnboardingState.globalKeyMap[
                                  OnboardingStepParts.homeSwiperSwipeDown],
                              description: 'Swiping Down makes it so you \n never see a certain meal again.',
                              child: image,
                            );
                          }

                          return wrappedImage;
                        },
                        cardController: widget.controller,
                        swipeUpdateCallback:
                            (DragUpdateDetails details, Alignment align) {
                          /// Get swiping card's alignment
                          if (align.x < 0) {
                            //Card is LEFT swiping
                          } else if (align.x > 0) {
                            //Card is RIGHT swiping
                          }
                        },
                        swipeCompleteCallback:
                            (CardSwipeOrientation orientation, int index) {
                          TriggerDirection coercedOrientation =
                              CardSwipeDirectionToTriggerDirection[orientation];

                          developer.log(
                              'SWIPE COMPLETE $index $orientation $coercedOrientation');
                          if (index == _images.length - 1) {
                            setState(() {
                              finished = true;
                            });
                          }

                          const directionTitleText = {
                            CardSwipeOrientation.DOWN: 'Yikes!',
                            CardSwipeOrientation.LEFT: 'Noted.',
                            CardSwipeOrientation.RIGHT: 'Yum!',
                            CardSwipeOrientation.UP: 'Wow!',
                          };

                          // bail out with no handled direction
                          if (!directionTitleText.containsKey(orientation)) {
                            return Container();
                          }

                          SwipedMealType swipedMealType;

                          if (orientation == CardSwipeOrientation.RIGHT) {
                            swipedMealType = SwipedMealType.liked;
                          } else if (orientation == CardSwipeOrientation.LEFT) {
                            swipedMealType = SwipedMealType.disliked;
                          } else if (orientation == CardSwipeOrientation.UP) {
                            swipedMealType = SwipedMealType.favorited;
                          } else if (orientation == CardSwipeOrientation.DOWN) {
                            swipedMealType = SwipedMealType.hated;
                          }

                          if (tabContext == TAB_CONTEXT_NONE ||
                              tabContext == null) {
                            swipeResults.swipeMeal(
                              meal: _images[index].meal,
                              swipedMealType: swipedMealType,
                            );
                          } else if (tabContext == TAB_CONTEXT_SWIPED) {
                            if (swipedMealType == SwipedMealType.hated ||
                                swipedMealType == SwipedMealType.disliked) {
                              var favoritedMeals = [
                                ...RxSwipeResults().favoritedMeals.value
                              ];
                              favoritedMeals.removeWhere(
                                  (meal) => meal.id == _images[index].meal.id);
                              RxSwipeResults().favoritedMeals.value =
                                  favoritedMeals;

                              var likedMeals = [
                                ...RxSwipeResults().likedMeals.value
                              ];
                              likedMeals.removeWhere(
                                  (meal) => meal.id == _images[index].meal.id);
                              RxSwipeResults().likedMeals.value = likedMeals;
                            }
                          }

                          return Container();
                        },
                      ),
                    ),
                  if (finished && tabContext != TAB_CONTEXT_SWIPED)
                    Flexible(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            "No more meals found.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Text(
                            "Try modifying your settings to expand your search."),
                        ElevatedButton(
                            onPressed: () {
                              Get.toNamed("/home/settings/none");
                            },
                            child: Text("Settings"))
                      ],
                    )),
                  if (finished && tabContext == TAB_CONTEXT_SWIPED)
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              "No more liked items.",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Text("Check out the results of your filtering."),
                          ElevatedButton(
                            onPressed: () {
                              Get.toNamed('/home/results');
                            },
                            child: Text("Results"),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 40, bottom: 40),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Text(
                              "Start looking through more meals you havent seen yet."),
                          ElevatedButton(
                            onPressed: () {
                              Get.offAllNamed('/home/swiper/none');
                            },
                            child: Text("See all meals"),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ]);
        },
      ),
      bottomNavigationBar: AppShowcase(
        showcaseKey: RxOnboardingState
            .globalKeyMap[OnboardingStepParts.homeSwiperButtons],
        description: 'You can use these buttons instead of swiping.',
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.red[700],
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.thumb_down),
              title: Text('Dislike'),
              backgroundColor: Colors.red[700],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fireplace),
              title: Text('Hate'),
              backgroundColor: Colors.red[700],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Love'),
              backgroundColor: Colors.red[700],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.thumb_up),
              title: Text('Like'),
              backgroundColor: Colors.red[700],
            ),
          ],
          onTap: (index) {
            developer.log("index: $index");
            if (index == 0) {
              widget.controller.triggerLeft();
            } else if (index == 1) {
              developer.log('hmmmmm');
              widget.controller.triggerDown();
            } else if (index == 2) {
              widget.controller.triggerUp();
            } else if (index == 3) {
              widget.controller.triggerRight();
            }
          },
        ),
      ),
    );
  }
}
