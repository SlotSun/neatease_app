import 'package:flutter/material.dart';
import 'package:neatease_app/constant/constants.dart';

class UniListVideoCard extends StatelessWidget {
  const UniListVideoCard({
    Key key,
    @required this.size,
    this.title,
    this.press,
    this.img,
  }) : super(key: key);
  final String title;
  final Function press;
  final String img;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.only(
          left: kDefaultPadding / 2,
          right: kDefaultPadding / 4,
          top: kDefaultPadding / 2,
          bottom: kDefaultPadding / 4,
        ),
        width: size.width,
        child: Column(
          children: [
            Container(
              height: size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('$img'),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                '$title',
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
