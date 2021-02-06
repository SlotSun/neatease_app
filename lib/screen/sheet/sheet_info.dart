import 'package:flutter/material.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/util/cache_image.dart';

class SheetInfo extends StatelessWidget {
  const SheetInfo({Key key, this.sheet}) : super(key: key);
  final SheetDetailsPlaylist sheet;
  Widget buildChips() {
    List<Widget> chips = [];
    sheet.tags.forEach((label) {
      chips.add(Chip(
        label: Text(label),
      ));
    });
    return Row(
      children: chips,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 25, left: 5, right: 5),
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.only(right: 0, left: 300),
                leading: IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: ImageHelper.getImage(
                    sheet.coverImgUrl + "?param=500y500",
                    height: MediaQuery.of(context).size.width - 50),
              ),
              Center(
                child: Text(
                  '${sheet.name}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  sheet.description ?? '',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, height: 1.5),
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Text('标签：'),
                    buildChips(),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: InkWell(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 15, top: 8, bottom: 8, right: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(15)),
                    child: Wrap(
                      children: <Widget>[
                        Text('保存封面'),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
