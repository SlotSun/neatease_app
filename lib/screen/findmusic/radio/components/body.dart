import 'package:flutter/material.dart';

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
        child: Text("尚未开发"),
      ),
    );
  }
}
