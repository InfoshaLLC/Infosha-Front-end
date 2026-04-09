// ignore_for_file: unused_field

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/authentication/confirm_password.dart';
import 'package:infosha/utils/error_boundary.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:infosha/views/widgets/show_loader.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';

class ForgetOTPVerification extends StatefulWidget {
  String phoneNumber, number;

  ForgetOTPVerification(
      {super.key, required this.phoneNumber, required this.number});

  @override
  State<ForgetOTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<ForgetOTPVerification> {
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var formKey = GlobalKey<FormState>();

  String _otpCode = "";

  int _remainingSeconds = 60;
  bool _isTimerRunning = false;
  Timer? _timer;

  @override
  void initState() {
    if (widget.phoneNumber.startsWith("+995")) {
      Future.microtask(() => context
          .read<UserViewModel>()
          .sendOTPGeorgia(widget.phoneNumber.replaceAll("+", ""), context));
    } else {
      Future.microtask(() =>
          context.read<UserViewModel>().sendOTP(widget.phoneNumber, context));
    }
    super.initState();
  }

  void _startTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    setState(() {
      _remainingSeconds = 60;
      _isTimerRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _isTimerRunning = false;
            _timer!.cancel();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: Scaffold(
        body: Consumer<UserViewModel>(builder: (context, provider, child) {
          return Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  iconSize: 25,
                  onPressed: () {
                    Navigator.of(context).pop();
                    print('Back Button Called');
                  },
                ),
                const SizedBox(height: 50),
                CustomText(
                  text: 'OTP Verification'.tr,
                  fontSize: 24.0,
                  weight: fontWeightW600,
                ),
                CustomText(
                    text:
                        "\n${'Enter the six-digit OTP you received by SMS'.tr}"),
                Row(children: [
                  CustomText(text: "Didn't Receive the code?".tr),
                  _isTimerRunning
                      ? TextButton(
                          onPressed: () {},
                          child: CustomText(text: '(00:$_remainingSeconds)'))
                      : TextButton(
                          onPressed: () {
                            _startTimer();
    
                            _pinPutController.clear();
                            const LoaderDialog().showLoader();
                            if (widget.phoneNumber.startsWith("+995")) {
                              provider
                                  .sendOTPGeorgia(
                                      widget.phoneNumber.replaceAll("+", ""),
                                      context)
                                  .then((value) {
                                LoaderDialog().hideLoader();
                              });
                            } else {
                              provider
                                  .sendOTP(widget.phoneNumber, context)
                                  .then((value) {
                                LoaderDialog().hideLoader();
                              });
                            }
                          },
                          child: CustomText(
                            text: 'Resend'.tr,
                            weight: FontWeight.w500,
                            color: primaryColor,
                          )),
                ]),
                const SizedBox(height: 25),
                Form(
                  key: formKey,
                  child: Center(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        //   eachFieldAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        length: 6,
                        defaultPinTheme: PinTheme(
                            width: Get.width / 8,
                            height: Get.width / 8,
                            textStyle: textStyleAldrich(
                                color: blackbutton,
                                weight: fontWeightSemiBold,
                                fontSize: 18.0),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ))),
                        onCompleted: (String pin) {
                          setState(() {
                            _otpCode = pin;
                          });
                        },
    
                        focusNode: _pinPutFocusNode,
                        controller: _pinPutController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Please enter OTP".tr;
                          }
                          if (value.length < 6) {
                            return "Enter the six-digit OTP you received by SMS";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                UIHelper.verticalSpaceXL,
                Consumer<UserViewModel>(builder: (context, provider, child) {
                  return CustomButton(
                    () {
                      if (formKey.currentState!.validate()) {
                        if (widget.phoneNumber.startsWith("+995")) {
                          provider
                              .verifyOTPGeorgia(
                                  widget.phoneNumber.replaceAll("+", ""),
                                  _otpCode,
                                  context)
                              .then((value) {
                            if (value) {
                              _submitOTP();
                            }
                          });
                        } else {
                          if (provider.isOTPValidation == false) {
                            provider
                                .verifyOTP(widget.phoneNumber, _otpCode, context)
                                .then((value) {
                              if (value) {
                                _submitOTP();
                              }
                            });
                          }
                        }
                      }
                    },
                    text: provider.isOTPValidation ? "loading" : "Submit".tr,
                    color: primaryColor,
                    textcolor: whiteColor,
                    fsize: 18.0,
                  );
                })
              ],
            ),
          );
        }),
      ),
    );
  }

  void _submitOTP() {
    Get.to(() => ConfirmPassword(number: widget.number));
  }
}
