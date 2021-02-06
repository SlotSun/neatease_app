import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:neatease_app/entity/banner_entity.dart';
import 'package:neatease_app/util/cache_image.dart';

Widget buildBanner(List<BannerBanner> banners) {
  return Container(
    height: 116,
    child: Swiper(
      /*
        Flutter Swiper是一个轮播图组件，内部包含一个Widget List，
        当这个Widget List数量发生变化的时候如果出现类似这种异常情况导致轮播图不滑动或者其他红屏等错误，
        Swiper加一个LocalKey即可解决，我这里加了个UniqueKey，属于一个LocalKey
      */
      key: UniqueKey(),
      autoplay: true,
      duration: 500,
      autoplayDelay: 4000,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child:
              ImageHelper.getImage(banners[index].imageUrl + "?param=300y800"),
        );
      },
      itemCount: banners.length,
      viewportFraction: 1,
      scale: 0.8,
      onTap: (index) {},
    ),
  );
}
