import 'package:flutter/material.dart';

class ChipCounter extends StatelessWidget {
  ChipCounter({this.label, this.count, this.color, this.labelTextColor});

  final String label;
  final int count;
  final Color color;
  final Color labelTextColor;

  @override
  Widget build(BuildContext context) {
    Color _color = color;
    Color _labelTextColor = color;
    if (_color == null) {
      _color = Colors.red;
    }
    if (_labelTextColor == null) {
      _labelTextColor = Colors.white;
    }

    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: _color,
          ),
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 8,
                  right: 16,
                  top: 2,
                  bottom: 2,
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: _labelTextColor,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 2,
                    bottom: 2,
                  ),
                  child: Text("$count",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
