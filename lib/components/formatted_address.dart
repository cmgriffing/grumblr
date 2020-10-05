import 'package:flutter/material.dart';
import 'package:grumblr/types/restaurant.dart';

class FormattedAddress extends StatelessWidget {
  FormattedAddress({this.address, this.viewportConstraints});

  final Address address;
  final BoxConstraints viewportConstraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(address.line1),
          if (address.line2 != null && address.line2 != '') Text(address.line2),
          if (address.line2 != null && address.line3 != '') Text(address.line3),
          if (address.line2 != null && address.line4 != '') Text(address.line4),
          Text(
              "${address.municipality}, ${address.province} ${address.postalCode}"),
        ],
      ),
    );
  }
}
