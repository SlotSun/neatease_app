import 'package:flutter/material.dart';
import 'package:neatease_app/constant/constants.dart';

class NeteaseListTitle extends StatelessWidget {
  const NeteaseListTitle({
    Key key,
    this.title,
    this.press,
    this.fontSize,
    this.fColor,
  }) : super(key: key);
  final String title;
  final Function press;
  final double fontSize;
  final Color fColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: kDefaultPadding,
        top: 12,
        bottom: 0,
      ),
      child: Row(
        children: [
          Container(
            height: 24,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: kDefaultPadding / 4),
                  child: GestureDetector(
                    onTap: press,
                    child: Text(
                      '$title>',
                      style: TextStyle(
                        color: fColor,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
