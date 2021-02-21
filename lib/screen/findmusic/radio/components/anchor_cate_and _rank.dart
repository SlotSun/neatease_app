import 'package:flutter/material.dart';

class AnchorCateAndRank extends StatelessWidget {
  const AnchorCateAndRank({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size.width / 2,
          height: 59,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.ac_unit),
              Text('电台分类'),
            ],
          ),
        ),
        Container(
          width: size.width / 2,
          height: 59,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.ac_unit),
              Text('电台排行'),
            ],
          ),
        ),
      ],
    );
  }
}
