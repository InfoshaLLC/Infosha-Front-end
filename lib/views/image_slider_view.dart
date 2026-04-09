import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';

class ImageSliderView extends StatelessWidget {
  List<String>? listImages;
  ImageSliderView({Key? key, this.listImages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ImageSlideshow(
          width: double.infinity,
          height: Get.height * 0.35,
          initialPage: 0,
          indicatorColor: Colors.blue,
          indicatorBackgroundColor: Colors.grey,
          onPageChanged: (value) {
            // debugPrint('Page changed: $value');
          },
          autoPlayInterval: 3000,
          isLoop: true,
          children: listImages!.map((e) {
            return CachedNetworkImage(
              imageUrl: e,
              
              fit: BoxFit.cover,
            );
          }).toList()),
    );
  }
}
