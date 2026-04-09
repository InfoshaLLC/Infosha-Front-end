import 'package:flutter/material.dart';

class LogoView extends StatelessWidget {
  double? width;
  double? height;
  BoxFit? fit;
  bool? issimple;

  LogoView({Key? key, this.width, this.fit, this.height, this.issimple})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "mylogo",
      child: Image.asset(
        issimple == null ? "images/logo.png" : "images/logotext.png",
        width: width ?? 200,
        height: height ?? 200,
        fit: fit ?? BoxFit.fitWidth,
      ),
    );
  }
}
