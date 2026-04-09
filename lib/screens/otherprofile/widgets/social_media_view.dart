import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/custom_textfield.dart.dart';
import 'package:infosha/views/ui_helpers.dart';

class SocialMediaView extends StatefulWidget {
  const SocialMediaView({Key? key}) : super(key: key);

  @override
  State<SocialMediaView> createState() => SocialMediaViewState();
}

class SocialMediaViewState extends State<SocialMediaView> {
  bool _valid = true;
  TextEditingController google = TextEditingController();
  TextEditingController facebook = TextEditingController();
  TextEditingController insta = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomText(
              text: "Social Media".tr,
              isHeading: true,
              fontSize: 16.0,
            ),
            UIHelper.verticalSpaceMd,
            CustomTextField(
              required: false,
              keyboard: TextInputType.emailAddress,
              hint: "Enter Your Email".tr,
              labeltext: "Email",
              suffix: Icon(Icons.link),
              controller: google,
            ),
            UIHelper.verticalSpaceMd,
            CustomTextField(
              required: false,
              hint: "Your Facebook Id".tr,
              labeltext: "Facebook id",
              suffix: Icon(Icons.link),
              controller: facebook,
              formate: [
                FilteringTextInputFormatter.deny(
                  RegExp(r'\s'),
                ),
              ],
            ),
            UIHelper.verticalSpaceMd,
            CustomTextField(
              required: false,
              hint: "Your Instagram Id".tr,
              labeltext: "Instagram".tr,
              controller: insta,
              suffix: Icon(Icons.link),
            ),
          ],
        ));
  }

  Future _validateInput(String input) async {
    // Define a regular expression for validating social links
    RegExp regExp = RegExp(
      r'^https?:\/\/(www\.)?(facebook|twitter|instagram)\.com\/.+',
      caseSensitive: false,
    );
    if (regExp.hasMatch(input)) {
      setState(() {
        _valid = true;
      });
    } else {
      setState(() {
        _valid = false;
      });
    }
  }
}
