import 'package:flutter/material.dart';
import 'package:neatease_app/constant/constants.dart';

class RadioCardList extends StatelessWidget {
  const RadioCardList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            RadioCard(
              img: 'assets/images/image_1.png',
              press: () {},
            ),
            RadioCardTitleAndAuthor(
              title: '凉凉-丸子/神秘男友',
              author: '丸子www',
            ),
          ],
        ),
        Row(
          children: <Widget>[
            RadioCard(
              img: 'assets/images/image_1.png',
              press: () {},
            ),
            RadioCardTitleAndAuthor(
              title: '[3D环绕合集] 你也要来玩吗？很...',
              author: '[高能环绕]戴耳机入场哦',
            ),
          ],
        ),
        Row(
          children: <Widget>[
            RadioCard(
              img: 'assets/images/image_1.png',
              press: () {},
            ),
            RadioCardTitleAndAuthor(
              title: '<这一跪>朗诵-任志宏 作者-苗晓',
              author: '任志宏诵读经典',
            ),
          ],
        ),
      ],
    );
  }
}

class RadioCardTitleAndAuthor extends StatelessWidget {
  const RadioCardTitleAndAuthor({
    Key key,
    this.title,
    this.author,
  }) : super(key: key);
  final String title;
  final String author;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('$title\n'),
        Text(
          '$author',
          style: TextStyle(fontSize: 13),
        )
      ],
    );
  }
}

class RadioCard extends StatelessWidget {
  const RadioCard({
    Key key,
    this.img,
    this.press, this.size,
  }) : super(key: key);
  final String img;
  final Function press;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        margin: EdgeInsets.only(
            right: kDefaultPadding / 2,
            top: kDefaultPadding / 2,
            bottom: kDefaultPadding / 2,
            left: kDefaultPadding),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey,
          image: DecorationImage(
            image: AssetImage('$img'),
            fit: BoxFit.fill,
          ),
        ),
        child: Text(''),
      ),
    );
  }
}
