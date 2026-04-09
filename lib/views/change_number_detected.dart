import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/authentication/otp_verification.dart';
import 'package:infosha/screens/home/home_screen.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_number.dart';

import 'package:infosha/views/text_styles.dart';
import 'package:provider/provider.dart';

class ChangeNumberDetected extends StatefulWidget {
  const ChangeNumberDetected({super.key});

  @override
  State<ChangeNumberDetected> createState() => _ChangeNumberDetectedState();
}

class _ChangeNumberDetectedState extends State<ChangeNumberDetected> {
  TextEditingController numberController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late UserViewModel provider;
  CountryCode country = CountryCode(
    code: "US",
    dialCode: "+1",
  );

  @override
  void initState() {
    provider = Provider.of<UserViewModel>(context, listen: false);

    Future.delayed(const Duration(microseconds: 500), () {
      showNumberDialogs(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        // child: ElevatedButton(
        //     onPressed: () => showNumberDialogs(context), child: Text("Show")),
      ),
    );
  }

  showNumberDialogs(BuildContext context) async {
    numberController.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            shape: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: SizedBox(
                width: Get.width * 0.9,
                height: Get.height * 0.37,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text(
                            'Change in'.tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
                      ),
                      const SizedBox(height: 05),
                      Text(
                        'Number Detected'.tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: CustomNumber(
                          required: true,
                          hint: "Enter New Phone Number".tr,
                          isObscure: false,
                          controller: numberController,
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
                              return "Please Enter Phone Number".tr;
                            }
                            if (value!.length < 10) {
                              return "Enter valid number".tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, right: 25),
                            child: TextButton(
                              onPressed: () {
                                // Get.close(1);
                                if (formKey.currentState!.validate()) {
                                  Get.to(() => OTPVerification(
                                        isFromLogin: false,
                                        phoneNumber:
                                            "$country${numberController.text.trim()}",
                                        isChangeNumber: true,
                                      ));
                                  // provider
                                  //     .newNumber(
                                  //         "+${numberController.text.trim()}")
                                  //     .then((value) {
                                  //       print("changed ==> $value");
                                  //     });
                                  // Get.close(1);
                                  // Get.offAll(() => const HomeScreen());
                                }
                              },
                              child: provider.isAuthenticating
                                  ? const CircularProgressIndicator(
                                      color: baseColor,
                                    )
                                  : Text(
                                      'Continue'.tr,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: fontWeightBold,
                                        color: Color(0xff1B2870),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
