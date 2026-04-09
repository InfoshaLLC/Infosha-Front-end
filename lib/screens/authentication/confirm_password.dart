import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/custom_textfield.dart.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class ConfirmPassword extends StatefulWidget {
  String number;
  ConfirmPassword({super.key, required this.number});

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();

  String number = "";
  bool ishide = true;
  bool ishidee = true;
  CountryCode country = CountryCode(
    code: "US",
    dialCode: "+1",
  );
  final TextEditingController _confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(
                image: AssetImage('images/background1.png'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIHelper.verticalSpaceMd,
                    CustomText(
                      text: "Set New Password",
                      fontSize: 22.0.px,
                      color: Colors.black,
                      weight: fontWeightSemiBold,
                    ),
                    UIHelper.verticalSpaceL,
                    CustomTextField(
                      required: true,
                      hint: "Password".tr,
                      isObscure: ishidee,
                      controller: _pass,
                      formate: [NoSpaceFormatter()],
                      suffix: InkWell(
                          onTap: () {
                            setState(() {
                              ishidee = !ishidee;
                            });
                          },
                          child: ishidee
                              ? Container(
                                  padding: const EdgeInsets.all(12),
                                  width: Get.width * 0.02,
                                  child: Image.asset(
                                      "assets/emojies/showpass.png"))
                              : const Icon(Icons.visibility_off)),
                      validator: (String? value) {
                        if (value!.trim().isEmpty) {
                          return "Please enter password".tr;
                        } else if (value.length < 6) {
                          return "At least 6 characters".tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    UIHelper.verticalSpaceMd,
                    CustomTextField(
                      required: true,
                      hint: "Confirm Password".tr,
                      isObscure: ishide,
                      controller: _confirmPass,
                      formate: [NoSpaceFormatter()],
                      suffix: InkWell(
                          onTap: () {
                            setState(() {
                              ishide = !ishide;
                            });
                          },
                          child: ishide
                              ? Container(
                                  padding: const EdgeInsets.all(11),
                                  width: Get.width * 0.02,
                                  child: Image.asset(
                                      "assets/emojies/showpass.png"))
                              : const Icon(Icons.visibility_off)),
                      validator: (String? value) {
                        if (value!.trim().isEmpty) {
                          return "Please enter confirm password".tr;
                        } else if (value.length < 6) {
                          return "At least 6 characters".tr;
                        } else if (value != _pass.text) {
                          return "Password and confirm password doesn't match"
                              .tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    UIHelper.verticalSpaceMd,
                    Consumer<UserViewModel>(
                        builder: (context, provider, child) {
                      return CustomButton(
                        () {
                          if (_form.currentState!.validate()) {
                            provider.setNewPassword(
                                widget.number, _confirmPass.text.trim());
                          }
                        },
                        text: provider.isForgetPassword
                            ? "loading"
                            : "Continue".tr,
                        textcolor: whiteColor,
                        color: primaryColor,
                      );
                    }),
                    UIHelper.verticalSpaceMd
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
