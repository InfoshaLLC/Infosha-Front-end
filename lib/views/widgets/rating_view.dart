import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';

class MyCustomRatingView extends StatelessWidget {
  var starSize;
  double? ratinigValue;
  var extratext;
  var fontsize;
  var fontcolor;
  var padding;
  MyCustomRatingView(
      {super.key,
      this.starSize,
      this.ratinigValue,
      this.extratext,
      this.fontcolor,
      this.padding,
      this.fontsize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBar.builder(
          initialRating: ratinigValue ?? 0.0,
          //minRating: user.rating+.0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          ignoreGestures: true,

          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: padding ?? 1.0),
          itemSize: starSize ?? 12.0,
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        ratinigValue != null
            ? CustomText(
                text: " ${ratinigValue!.toStringAsFixed(1)} ${extratext ?? ""}",
                color: fontcolor ?? Colors.black,
                weight: fontWeightMedium,
                fontSize: (fontsize ?? starSize) ?? (fontsize ?? 14.0),
              )
            : Container()
      ],
    );
  }
}
