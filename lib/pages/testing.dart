import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class TestingPage extends StatefulWidget {
  TestingPage({Key key}) : super(key: key);

  final String title = 'Testing';

  @override
  _TestingPageState createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
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
                Flexible(child: Text('Testing')),
              ],
            ),
          );
        },
      ),
    );
  }
}
