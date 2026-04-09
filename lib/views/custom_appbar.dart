import 'package:flutter/material.dart';

AppBar customAppBar(
    {title, elevation, color, actions, leading, leadingwidth, centerTitle}) {
  return AppBar(
    backgroundColor: color ?? Colors.white,
    elevation: elevation ?? 5,
    centerTitle: centerTitle ?? true,
    title: title ?? Container(),
    actions: actions ?? [],
    leading: leading,
    leadingWidth: leadingwidth,
    // title: Text(
    //   AppName,
    //   style: textStylePopinsMiddle(color: Colors.red, fontSize: 18.0),
    // ),
  );
}
