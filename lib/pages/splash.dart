import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import 'package:grumblr/services/state/onboarding.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  final String title = 'Splash';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    if (!RxOnboardingState().hasDoneOnboarding.value) {
      RxOnboardingState().isShowingOnboarding.value = true;
    }

    Get.offAllNamed("/home/swiper/none");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(child: Text('Welcome')),
              ],
            ),
          );
        },
      ),
    );
  }
}
