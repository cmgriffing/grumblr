import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:showcaseview/showcase.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

class AppShowcase extends StatefulWidget {
  final GlobalKey showcaseKey;
  final String description;
  final Widget child;

  AppShowcase({this.showcaseKey, this.description, this.child});


  @override
  _AppShowcaseState createState() => _AppShowcaseState();
}

class _AppShowcaseState extends State<AppShowcase> {
  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: widget.showcaseKey,
      description: widget.description,
      child: widget.child,
      // descTextStyle: TextStyle(),
      // container: Container(
      //   // alignment: Alignment(-1,0),
      //   // height: 142,
      //   width: 142,
      //   transform: Matrix4.translation(VectorMath.Vector3(-71, 0, 0)),
      //   padding: EdgeInsets.all(8),
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.all(Radius.circular(2)),
      //   ),
      //   child: Text(
      //     widget.description,
      //     softWrap: true,
      //   ),
      // ),
      // width: 0,
      // height: 142,
    );
  }
}
