import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/andriod_service/android_service.dart';

/*
* 图片选择
*
* void _upload() {
   if (file == null) return;
   String base64Image = base64Encode(file.readAsBytesSync());
   String fileName = file.path.split("/").last;

   http.post(phpEndPoint, body: {
     "image": base64Image,
     "name": fileName,
   }).then((res) {
     print(res.statusCode);
   }).catchError((err) {
     print(err);
   });
 }
* image_picker 0.6.7+22
* */
class AnchorRadioBody extends StatelessWidget {
  const AnchorRadioBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Center(
        child: IconButton(
          onPressed: () async {
            int i = await AndroidService.getBattery();
            // AndroidService.sendMessage();
            // AndroidService.openSetting();
            AndroidService.openView();
            Fluttertoast.showToast(msg: '$i');
          },
          icon: Icon(Icons.pause_circle_outline_sharp),
        ),
      ),
    );
    //   SingleChildScrollView(
    //   scrollDirection: Axis.vertical,
    //   child: Column(
    //     children: <Widget>[
    //       Container(
    //         width: size.width,
    //         height: 127,
    //         decoration: BoxDecoration(
    //           color: Colors.grey,
    //         ),
    //       ),
    //       AnchorCateAndRank(
    //         size: size,
    //       ),
    //       NeteaseListTitle(title: '每天听些好节目'),
    //       RadioCardList(),
    //       NeteaseListTitle(title: '电台个性推荐'),
    //       RadioPersonalComCardList(),
    //     ],
    //   ),
    // );
  }
}
