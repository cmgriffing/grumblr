import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

class DonePage extends StatefulWidget {
  DonePage({Key key}) : super(key: key);

  final String title = 'Done';

  @override
  _DonePageState createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
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
                Flexible(child: Text('Done')),
                Flexible(
                  child: ElevatedButton(
                    child: Text('Testing'),
                    onPressed: () {
                      Get.toNamed('/testing');
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
