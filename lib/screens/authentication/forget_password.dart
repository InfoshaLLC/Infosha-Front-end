import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/authentication/forget_otp_verification.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:infosha/views/custom_number.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController phone = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String number = "";
  CountryCode country = CountryCode(
    code: "GE",
    dialCode: "+995",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => UserViewModel(),
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                children: [
                  const Image(
                    image: AssetImage('images/background1.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UIHelper.verticalSpaceMd,
                        CustomText(
                          text: "Forgot Password?",
                          fontSize: 22.0.px,
                          color: Colors.black,
                          weight: fontWeightSemiBold,
                        ),
                        UIHelper.verticalSpaceMd,
                        CustomNumber(
                          required: true,
                          hint: "Phone Number".tr,
                          isObscure: false,
                          controller: phone,
                          prefix: CountryCodePicker(
                            flagWidth: Get.width * 0.07,
                            onChanged: (value) {
                              country = value;
                              print("value ==> $value");
                            },
                            initialSelection: country.code,
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                          ),
                          validator: (String? value) {
                            if (value == "") {
                              return "Please enter phone number".tr;
                            }
                            if (value!.length < 9) {
                              return "Enter valid number".tr;
                            }
                            return null;
                          },
                        ),
                        UIHelper.verticalSpaceMd,
                        UIHelper.verticalSpaceMd,
                        Consumer<UserViewModel>(
                            builder: (context, provider, child) {
                          return CustomButton(
                            () {
                              UserViewModel provider =
                                  Provider.of(context, listen: false);

                              if (_form.currentState!.validate()) {
                                provider
                                    .checkRegisterNumber(phone.text.trim())
                                    .then((value) {
                                  if (value == true) {
                                    Get.to(() => ForgetOTPVerification(
                                        number: phone.text.trim(),
                                        phoneNumber:
                                            "$country${phone.text.trim()}"));
                                  }
                                });
                              }
                            },
                            text:
                                provider.isRegister ? "loading" : "Continue".tr,
                            textcolor: whiteColor,
                            color: primaryColor,
                          );
                        })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "Already have an account?".tr,
                      style: textStyleWorkSense(
                          color: Colors.black,
                          fontSize: 15.0,
                          weight: fontWeightMedium)),
                  const WidgetSpan(child: UIHelper.horizontalSpaceSm),
                  TextSpan(
                      text: "Login".tr,
                      style: textStyleWorkSense(
                          color: primaryColor,
                          fontSize: 16,
                          textDecoration: TextDecoration.underline,
                          weight: fontWeightExtraBold))
                ])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
