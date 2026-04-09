// ignore_for_file: unused_field
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/home/home_screen.dart';
import 'package:infosha/screens/hscreen/termsandConditions.dart';
import 'package:infosha/utils/error_boundary.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:infosha/views/widgets/show_loader.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';

class OTPVerification extends StatefulWidget {
  OTPVerification(
      {super.key,
      required this.isFromLogin,
      required this.phoneNumber,
      this.isChangeNumber,
      this.payload});
  bool isFromLogin;
  String phoneNumber;
  bool? isChangeNumber;
  var payload;

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var formKey = GlobalKey<FormState>();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(25.0),
    color: Colors.black12,
  );

  bool isCodeReceived = false;
  String verificationIdFinal = "";
  String smsCode = "";
  bool isOtpSubmit = false;
  bool otpsent = false;
  bool valuefirst = false;
  String contrypick = '+1';
  var selectedMethod = "Phone";
  bool isPhone = true;
  bool isResendCodeEnable = false;
  late AuthCredential _phoneAuthCredential;
  String _otpCode = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var verificationId;

  int _remainingSeconds = 120;
  bool _isTimerRunning = false;
  Timer? _timer;
  String hashKey = "";

  @override
  void initState() {
    super.initState();

    if (widget.phoneNumber.startsWith("+995")) {
      Future.microtask(() => context
          .read<UserViewModel>()
          .sendOTPGeorgia(widget.phoneNumber.replaceAll("+", ""), context));
    } else {
      Future.microtask(() =>
          context.read<UserViewModel>().sendOTP(widget.phoneNumber, context));
    }
  }

  /// The below functions are the callbacks, separated so as to make code more redable
  void verificationCompleted(AuthCredential phoneAuthCredential) {
    _phoneAuthCredential = phoneAuthCredential;
  }

  void verificationFailed(dynamic error) {
    UIHelper.showBottomFlash(context,
        title: "OTP", message: error.toString(), isError: true);
  }

  void codeSent(String mverificationId, [var code]) {
    print("codeSent ==> $code");
    UIHelper.showBottomFlash(context,
        title: "OTP",
        message: "${"Verification Code sent to".tr} ${widget.phoneNumber}",
        isError: false);
    setState(() {
      verificationId = mverificationId;
      verificationIdFinal = mverificationId;
      otpsent = true;
    });
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    verificationId = verificationId;
  }

  Future<void> _submitPhoneNumber() async {
    String phoneNumber = widget.phoneNumber;
    print("phoneNumber ==> $phoneNumber");

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(milliseconds: 100000),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future signInwithPhoneNumber(String? smsCode, BuildContext context) async {
    if (smsCode != null && verificationId != null) {
      // Create a PhoneAuthCredential with the code
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      try {
        // Sign the user in (or link) with the credential
        await _auth.signInWithCredential(credential).then((value) async {
          print(value.user!.uid);
        });
        if (widget.isChangeNumber == true) {
          // ignore: use_build_context_synchronously
          Provider.of<UserViewModel>(context, listen: false)
              .newNumber(widget.phoneNumber)
              .then((value) {
            if (value) {
              Get.offAll(() => const HomeScreen());
            } else {}
          });
        } else {
          _submitOTP();
        }
      } on FirebaseAuthException catch (e) {
        print("error ==> ${e.code}");

        String message = e.code == "invalid-verification-code"
            ? "Please enter valid OTP"
            : e.code == "expired-action-code"
                ? "OTP is expired"
                : e.message ?? "";

        UIHelper.showMySnak(title: AppName, message: message.tr, isError: true);
      }
    }
  }

  void _startTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    setState(() {
      _remainingSeconds = 120;
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
                        if (provider.isOTPValidation == false) {
                          if (widget.phoneNumber.startsWith("+995")) {
                            provider
                                .verifyOTPGeorgia(
                                    widget.phoneNumber.replaceAll("+", ""),
                                    _otpCode,
                                    context)
                                .then((value) {
                              if (value) {
                                if (widget.isChangeNumber == true) {
                                  provider
                                      .newNumber(widget.phoneNumber)
                                      .then((value) {
                                    if (value) {
                                      Get.offAll(() => const HomeScreen());
                                    }
                                  });
                                } else {
                                  _submitOTP();
                                }
                              }
                            });
                          } else {
                            provider
                                .verifyOTP(
                                    widget.phoneNumber, _otpCode, context)
                                .then((value) {
                              if (value) {
                                if (widget.isChangeNumber == true) {
                                  provider
                                      .newNumber(widget.phoneNumber)
                                      .then((value) {
                                    if (value) {
                                      Get.offAll(() => const HomeScreen());
                                    }
                                  });
                                } else {
                                  _submitOTP();
                                }
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
    UserViewModel provider = Provider.of<UserViewModel>(context, listen: false);
    if (!widget.isFromLogin) {
      // provider.registerUser(widget.payload);
      Get.offAll(() => TermsAndConditions(payload: widget.payload));
    } else {
      provider.loginUser(widget.payload);
    }
  }
}
