import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:infosha/views/custom_number.dart';
import 'package:infosha/utils/error_boundary.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:infosha/views/custom_textfield.dart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:infosha/views/widgets/rewarded_ads_widget.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/authentication/forget_password.dart';
import 'package:infosha/screens/authentication/signupContinued.dart';
import 'package:infosha/screens/authentication/otp_verification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _sigUupScreenState();
}

class _sigUupScreenState extends State<LoginScreen> {
  bool ishidee = true;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String number = "";
  CountryCode country = CountryCode(
    code: "GE",
    dialCode: "+995",
  );

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const signupContinued());
                  },
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Don’t have an account?".tr,
                        style: textStyleWorkSense(color: Colors.black, fontSize: 15.0, weight: fontWeightMedium)),
                    const WidgetSpan(child: UIHelper.horizontalSpaceSm),
                    TextSpan(
                        text: "Sign Up".tr,
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
                            text: "Welcome Back",
                            fontSize: 22.0.px,
                            color: Colors.black,
                            weight: fontWeightSemiBold,
                          ),
                          UIHelper.verticalSpaceMd,
                          /*  CustomTextFieldPhone(
                            required: true,
                            hint: "Phone Number".tr,
                            controller: phone,
                            onChanged: (PhoneNumber phonenumber) {
                              number = phonenumber.completeNumber;
                              print("number ==> ${phonenumber.completeNumber}");
                            },
                          ), */
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
                          CustomTextField(
                            required: true,
                            hint: "Password".tr,
                            isObscure: ishidee,
                            controller: _pass,
                            formate: [NoSpaceFormatter()],
                            suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    ishidee = !ishidee;
                                  });
                                },
                                child: ishidee
                                    ? Container(
                                        padding: const EdgeInsets.all(12),
                                        width: Get.width * 0.02,
                                        child: Image.asset("assets/emojies/showpass.png"))
                                    : const Icon(Icons.visibility_off)),
                            validator: (String? value) {
                              if (value!.trim().isEmpty) {
                                return "Please enter password";
                              } else if (value.length < 6) {
                                return "At least 6 characters";
                              } else if (value != _pass.text) {
                                //  return "Password must be same as above";
                              } else {
                                return null;
                              }
                              return null;
                            },
                          ),
                          UIHelper.verticalSpaceSm1,
                          Align(
                            alignment: Alignment.centerRight,
                            child: MaterialButton(
                                onPressed: () {
                                  Get.to(() => const ForgetPassword());
                                },
                                child: CustomText(
                                  text: "Forgot Password?",
                                  weight: fontWeightRegular,
                                  fontSize: 14.0,
                                  color: blackbutton,
                                )),
                          ),
                          UIHelper.verticalSpaceMd,
                          Consumer<UserViewModel>(builder: (context, provider, child) {
                            return CustomButton(
                              () async {
                                UserViewModel provider = Provider.of(context, listen: false);

                                if (_form.currentState!.validate()) {
                                  showDiscloserDialog(context);
                                  /* var payload = {
                                    "number": phone.text.trim(),
                                    "password": _pass.text.trim(),
                                    "fcm_token": provider.fcmToken
                                  };
                                  provider
                                      .checkCredentials(payload)
                                      .then((value) {
                                    print("value ==> ${phone.text.trim()}");
                                    if (value) {
                                      if (phone.text.trim() == "1234512345") {
                                        provider.loginUser(payload);
                                      } else {
                                        Get.to(() => OTPVerification(
                                              isFromLogin: true,
                                              phoneNumber:
                                                  "$country${phone.text.trim()}",
                                              payload: payload,
                                            ));
                                      }
                                    }
                                  }); */
                                }
                              },
                              text: provider.isAuthenticating ? "loading" : "Login".tr,
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
      ),
    );
  }

  void showDiscloserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "This is important that you understand what information app collects and uses.",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\u2022 Contact List",
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                Text(
                  "By registering on Infosha app, you acknowledge and accept that you make your activity in app, your phone number, your contact list and contact list details public (contact list and details of every contact like photos, phone number, workplace, date of birth etc). By accepting our privacy policy, you confirm that you have a consent of the people in your contact list to make their contact details public which is used for app's main functionality that is search any phone number.If you do not have their consent, please, do not register on Infosha, as all the legal responsibility about making their contact details public lays upon you.",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  "\u2022 User Data",
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                Text(
                  "In order to provide the services, Infosha Corporation will transfer, process and store personal information in a number of countries, including but not limited to US, where Infosha Corporation is located, and may also use cloud-based services for this purpose. Infosha Corporation may also subcontract storage or processing of your information to third parties located in countries other than your home country. Information collected within one country may, for example, be transferred to and processed in another country, which may not provide the same level of protection for personal data as the country in which it was collected. You acknowledge and agree that Infosha Corporation may transfer your personal information as described above for purposes consistent with this Privacy Policy. We take all reasonable precautions to protect personal information from misuse, loss and unauthorized access. Infosha Corporation has implemented physical, electronic, and procedural safeguards in order to protect the information, including that the information will be stored on secured servers and protected by secured networks to which access is limited to a few authorized employees and personnel. However, no method of transmission over the Internet or method of electronic storage is 100% secure.",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                )
              ],
            ),
          ),
          actions: [
            Consumer<UserViewModel>(builder: (context, provider, child) {
              return StatefulBuilder(builder: (context, setState) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                  Colors.white,
                                ),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(color: Colors.black54),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Get.close(1);
                              },
                              child: Text(
                                'Decline'.tr,
                                style: const TextStyle(
                                  color: Color(0xff1B2870),
                                ),
                              ),
                            ),
                          ),
                          UIHelper.horizontalSpaceMd,
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                  Color(0xff1B2870),
                                ),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                PermissionStatus permissionStatus = await Permission.contacts.status;
                                if (permissionStatus.isGranted ||
                                    permissionStatus.isRestricted ||
                                    permissionStatus.isLimited) {
                                  provider.fetchDeviceContacts();
                                  var payload = {
                                    "number": phone.text.trim(),
                                    "password": _pass.text.trim(),
                                    "fcm_token": provider.fcmToken
                                  };
                                  provider.checkCredentials(payload).then((value) {
                                    if (value) {
                                      // if (phone.text.trim() == "555333993") {
                                      if (phone.text.trim() == "9475556003") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "8617244589") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "9398377155") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "9398377144") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "1357997531") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "2468008642") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "5555555555") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "6666666666") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "3434343434") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "1313131313") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "1919191919") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "9163882273") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "1233211235") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "555333993") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "0909090909") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "0010010014") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "2002002003") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "3026208388") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "6026617255") {
                                        provider.loginUser(payload);
                                      } else if (phone.text.trim() == "9475558010") {
                                        provider.loginUser(payload);
                                      } else {
                                        Get.to(
                                          () => OTPVerification(
                                            isFromLogin: true,
                                            phoneNumber: "$country${phone.text.trim()}",
                                            payload: payload,
                                          ),
                                        );
                                      }
                                    }
                                  });
                                } else if (permissionStatus.isDenied) {
                                  var status = await Permission.contacts.request();
                                  if (status.isDenied) {
                                    UIHelper.showMySnak(
                                        title: AppName,
                                        message: "Please allow contact permission to use Infosha".tr,
                                        isError: true);
                                  }
                                }
                              },
                              child: provider.isAuthenticating
                                  ? SizedBox(
                                      height: Get.height * 0.03,
                                      width: Get.width * 0.062,
                                      child: const CircularProgressIndicator(
                                        color: whiteColor,
                                      ),
                                    )
                                  : Text('Accept'.tr),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              });
            }),
          ],
        );
      },
    );
  }
}
