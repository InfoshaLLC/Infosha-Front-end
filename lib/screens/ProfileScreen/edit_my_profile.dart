import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/colors.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:infosha/views/custom_number.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:infosha/searchscreens/searchscreen.dart';
import 'package:infosha/views/custom_textfield.dart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/views/dropdown_textfield-master/dropdown_textfield.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
// ignore_for_file: use_build_context_synchronously

class EditMyProfile extends StatefulWidget {
  const EditMyProfile({super.key});

  @override
  State<EditMyProfile> createState() => _EditMyProfileState();
}

class _EditMyProfileState extends State<EditMyProfile> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  XFile? pickedFile;
  final _picker = ImagePicker();
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController profession = TextEditingController();
  TextEditingController dateofbirthController = TextEditingController();
  TextEditingController address = TextEditingController();
  final TextEditingController phone = TextEditingController();
  TextEditingController google = TextEditingController();
  TextEditingController facebook = TextEditingController();
  TextEditingController insta = TextEditingController();

  // final FocusNode nicknameNode = FocusNode();
  // final FocusNode numberNode = FocusNode();
  // final FocusNode professionNode = FocusNode();
  // final FocusNode addressNode = FocusNode();
  // final FocusNode emailNode = FocusNode();
  // final FocusNode facebookNode = FocusNode();
  // final FocusNode instagramNode = FocusNode();

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String gender = "Gender";
  CountryCode country = CountryCode(
    code: "US",
    dialCode: "+1",
  );
  late UserViewModel provider;
  String selectedProfession = "Profession";
  List<String> professionList = [];

  @override
  void initState() {
    super.initState();

    provider = Provider.of<UserViewModel>(context, listen: false);
    professionList.clear();

    setState(() {
      List<String> splitName = provider.userModel.username!.split(' ');

      name.text = splitName.isNotEmpty ? splitName[0] : '';

      surname.text = splitName.length > 1 ? splitName.sublist(1).join(' ') : '';

      print("=========================${provider.userModel.profile!.profession}");
      profession.text = provider.userModel.profile!.profession ?? "";
      if (provider.userModel.profile!.gender != "") {
        gender = toBeginningOfSentenceCase(provider.userModel.profile!.gender)!;
      }

      if (provider.userModel.profile!.dob != null && provider.userModel.profile!.dob != "") {
        dateofbirthController.text = DateFormat('yyyy-MM-dd').format(DateFormat("yyyy-MM-dd").parse(provider.userModel.profile!.dob.toString()));
      }

      countryValue = provider.userModel.profile!.country != null ? toBeginningOfSentenceCase(provider.userModel.profile!.country)! : "";
      stateValue = provider.userModel.profile!.state != null ? toBeginningOfSentenceCase(provider.userModel.profile!.state)! : "";
      cityValue = provider.userModel.profile!.city != null ? toBeginningOfSentenceCase(provider.userModel.profile!.city)! : "";

      address.text = provider.userModel.profile!.address;
      google.text = provider.userModel.profile!.email;
      facebook.text = provider.userModel.profile!.facebookId;
      insta.text = provider.userModel.profile!.instagramId;

      getCode();

      if (provider.listDummyProfesstions.isNotEmpty) {
        professionList = provider.listDummyProfesstions.map((e) => e.profession!).toList();
        professionList.insert(0, "Profession");
      }
      print("professionList ===> ${professionList}");

      // if (provider.userModel.profile != null && (provider.userModel.profile!.profession != null && provider.userModel.profile!.profession != "")) {
      //   for (int i = 0; i < professionList.length; i++) {
      //     if (professionList[i].toLowerCase().contains(provider.userModel.profile!.profession.toString().toLowerCase())) {
      //       selectedProfession = professionList[i];
      //       print(selectedProfession);
      //     }
      //   }
      // }
    });
  }

  getCode() async {
    setState(() {
      if (provider.userModel.counryCode == null) {
        country = CountryCode(
          code: "US",
          dialCode: "+1",
        );
      } else {
        var temp = CountryPickerUtils.getCountryByPhoneCode(provider.userModel.counryCode!.replaceAll("+", "")).isoCode.toLowerCase();
        country = CountryCode(
          code: temp,
          dialCode: provider.userModel.counryCode ?? "US",
        );
      }
      phone.text = provider.userModel.number ?? "";
    });
    /* final phoneNumber = PhoneNumber.fromCompleteNumber(
        completeNumber: provider.userModel.number!.isNotEmpty
            ? provider.userModel.number!.replaceAll(' ', '')
            : provider.userModel.number!);

    setState(() {
      country = CountryCode(code: phoneNumber.countryISOCode);
      phone.text = phoneNumber.number;
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: CustomText(
            text: 'Edit Bio'.tr,
            isHeading: true,
          ),
        ),
        body: Container(
          width: Get.width,
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                children: [
                  profileicon(context),
                  UIHelper.verticalSpaceMd,
                  basicInfoContainer(),
                  UIHelper.verticalSpaceL,
                  placeContainer(),
                  UIHelper.verticalSpaceL,
                  socialContainer(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //  UIHelper.verticalSpaceSm,
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Consumer<UserViewModel>(builder: (context, provider, child) {
                return CustomButton(
                  () {
                    if (_form.currentState!.validate()) {
                      var payload = {
                        "gender": gender,
                        "dob": dateofbirthController.text.isNotEmpty ? dateofbirthController.text.trim() : "",
                        "country": countryValue.isEmpty ? "" : countryValue,
                        "state": stateValue.isEmpty ? "" : stateValue,
                        "city": cityValue.isEmpty ? "" : cityValue,
                        "address": address.text.isNotEmpty ? address.text.trim() : "",
                        "profession": selectedProfession != "Profession" ? selectedProfession : "",
                        "nickname": "${name.text.trim()} ${surname.text.trim()}",
                      };

                      var payload2 = {};
                      payload2.addIf(facebook.text.trim().isNotEmpty, "facebook_id", facebook.text.trim());
                      payload2.addIf(insta.text.trim().isNotEmpty, "instagram_id", insta.text.trim());
                      payload2.addIf(google.text.trim().isNotEmpty, "email", google.text.trim());

                      provider.editSocialMedia(payload2);
                      provider.editBio(payload, img: pickedFile);
                      // }
                    }
                  },
                  text: provider.isAuthenticating ? "loading" : "Save Changes".tr,
                  color: primaryColor,
                  textcolor: whiteColor,
                );
              }),
            ),
            //  UIHelper.verticalSpaceSm,
          ],
        ));
  }

  profileicon(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(children: [
        provider.userModel.profile != null && provider.userModel.profile!.profileUrl != "https://via.placeholder.com/150" && pickedFile == null
            ? CircleAvatar(
                radius: 50.0,
                backgroundImage: CachedNetworkImageProvider(provider.userModel.profile!.profileUrl!),
              )
            : pickedFile != null
                ? CircleAvatar(
                    radius: 50.0,
                    backgroundImage: FileImage(File(pickedFile!.path)),
                  )
                : CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage(APPICONS.profileicon),
                  ),
        Positioned(
          right: 5,
          bottom: 0,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(border: Border.all(), shape: BoxShape.circle, color: whiteColor),
            child: IconButton(
                padding: const EdgeInsets.all(3),
                onPressed: () async {
                  PermissionStatus status = await Permission.camera.status;
                  if (status.isGranted) {
                    showAlertForImageSelection(context);
                  } else if (status.isDenied) {
                    var temp = await Permission.camera.request();
                    if (temp.isGranted) {
                      showAlertForImageSelection(context);
                    }
                  } else {
                    openAppSettings();
                  }
                },
                icon: const Icon(Icons.camera_alt)),
          ),
        )
      ]),
    );
  }

  basicInfoContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomText(
          text: "Basic Information",
          isHeading: true,
          fontSize: 16.0,
        ),
        UIHelper.verticalSpaceMd,
        CustomTextField(
          // focusNode: nicknameNode,
          required: true,
          hint: "Name",
          labeltext: "Name",
          keyboard: TextInputType.text,
          controller: name,
          validator: (value) {
            if (value!.trim().isEmpty) {
              // nicknameNode.requestFocus();
              return "Enter name".tr;
            }
            if (value.trim().length < 3) {
              return "Please enter 3 character at least";
            }
            return null;
          },
        ),
        UIHelper.verticalSpaceMd,
        CustomTextField(
          // focusNode: nicknameNode,
          required: true,
          hint: "Surname",
          labeltext: "Surname",
          keyboard: TextInputType.text,
          controller: surname,
          validator: (value) {
            if (value!.trim().isEmpty) {
              // nicknameNode.requestFocus();
              return "Enter Surname".tr;
            }
            if (value.trim().length < 3) {
              return "Please enter 3 character at least";
            }
            return null;
          },
        ),
        UIHelper.verticalSpaceMd,
        CustomNumber(
          readOnly: true,
          // focusNode: numberNode,
          required: false,
          hint: "Phone Number".tr,
          isObscure: false,
          controller: phone,
          prefix: IgnorePointer(
            ignoring: true,
            child: CountryCodePicker(
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
          ),
          validator: (String? value) {
            /* if (value == "") {
              // numberNode.requestFocus();
              return "Please Enter Phone Number".tr;
            }
            if (value!.length < 9) {
              // numberNode.requestFocus();
              return "Enter valid number".tr;
            } */
            return null;
          },
        ),
        UIHelper.verticalSpaceMd,
        /* CustomTextField(
          // focusNode: professionNode,
          required: false,
          hint: "Profession",
          labeltext: "Profession",
          controller: profession,
          validator: (value) {
            /*  if (value!.trim().isEmpty) {
              // professionNode.requestFocus();
              return "Please Enter Profession".tr;
            } */
            return null;
          },
        ), */
        Container(
          width: Get.width,
          height: Get.height * 0.07,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 1,
              color: Colors.grey.shade400,
              // style: BorderStyle.none,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: selectedProfession,
              items: professionList
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedProfession = value!;
                });
              },
            ),
          ),
        ),
        UIHelper.verticalSpaceMd,
        Container(
          width: Get.width,
          height: Get.height * 0.07,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 1,
              color: Colors.grey.shade400,
              // style: BorderStyle.none,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: ["Gender", "Male", "Female"].contains(gender) ? gender : "Gender",
              items: [
                DropdownMenuItem(
                  value: "Gender",
                  child: Text("Gender".tr),
                ),
                DropdownMenuItem(
                  value: "Male",
                  child: Text("Male".tr),
                ),
                DropdownMenuItem(
                  value: "Female",
                  child: Text("Female".tr),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
          ),
        ),
        UIHelper.verticalSpaceMd,
        CustomTextField(
          required: false,
          hint: "Date of Birth".tr,
          controller: dateofbirthController,
          labeltext: "Date of Birth",
          suffix: const Icon(Icons.calendar_month_outlined),
          readOnly: true,
          validator: (value) {
            return null;
          },
          onTap: () {
            myDateBirthPicker(context, (date) {
              setState(() {
                dateofbirthController.text = date.toString();
              });
            });
          },
        ),
      ],
    );
  }

  void myDateBirthPicker(context, onPick) {
    DateTime date = DateTime.now();
    DatePicker.showDatePicker(
      context,
      maxDateTime: DateTime(date.year, date.month - 0, date.day),
      initialDateTime: DateTime.parse(dateofbirthController.text),
      dateFormat: "dd, MMMM, yyyy",
      onChange: (dateTime, selectedIndex) {
        print('change $selectedIndex');
        final DateFormat formatter = DateFormat('dd-MM-yyyy');

        final String formateDate = formatter.format(dateTime);

        onPick(formateDate);
      },
      pickerTheme: DateTimePickerTheme(itemTextStyle: textStyleWorkSense(color: Colors.black, fontSize: 16.0)),
      onConfirm: (date, selectedIndex) {
        final DateFormat formatter = DateFormat('dd-MM-yyyy');

        final String formateDate = formatter.format(date);

        onPick(formateDate);

        print('confirm $formateDate');
      },
    );
  }

  placeContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomText(
          text: "Place".tr,
          isHeading: true,
          fontSize: 16.0,
        ),
        UIHelper.verticalSpaceMd,
        CSCPicker(
          layout: Layout.vertical,
          showStates: true,
          showCities: true,
          flagState: CountryFlag.DISABLE,
          dropdownDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)), color: Colors.white, border: Border.all(color: Colors.grey, width: 1)),

          disabledDropdownDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)), color: Colors.white, border: Border.all(color: Colors.grey, width: 1)),

          currentCountry: provider.userModel.profile!.country != null ? toBeginningOfSentenceCase(provider.userModel.profile!.country!) : null,
          currentState: provider.userModel.profile!.state != null ? toBeginningOfSentenceCase(provider.userModel.profile!.state!) : null,
          currentCity: provider.userModel.profile!.city != null ? toBeginningOfSentenceCase(provider.userModel.profile!.city)! : null,

          ///placeholders for dropdown search field
          countrySearchPlaceholder: "Country".tr,
          stateSearchPlaceholder: "State".tr,
          citySearchPlaceholder: "City".tr,

          ///labels for dropdown
          countryDropdownLabel: "Country".tr,
          stateDropdownLabel: "State".tr,
          cityDropdownLabel: "City".tr,

          countryFilter: [],
          selectedItemStyle: textStyleInter(
            fontSize: 16,
            color: Colors.black,
          ),

          dropdownHeadingStyle: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          dropdownItemStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          dropdownDialogRadius: 5.0,
          searchBarRadius: 5.0,
          onCountryChanged: (value) {
            countryValue = value;
            stateValue = "";
            cityValue = "";
          },
          onStateChanged: (value) {
            stateValue = value ?? "";
          },
          onCityChanged: (value) {
            cityValue = value ?? "";
          },
        ),
        UIHelper.verticalSpaceMd,
        CustomTextField(
          // focusNode: addressNode,
          required: false,
          hint: "Address".tr,
          labeltext: "Address",
          controller: address,
          validator: (value) {
            /* if (value!.trim().isEmpty) {
              // addressNode.requestFocus();
              return "Please Enter Address".tr;
            } */
            return null;
          },
        ),
      ],
    );
  }

  showAlertForImageSelection(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Gallery".tr),
      onPressed: () {
        Navigator.pop(context);
        _selectImage(false);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Camera".tr),
      onPressed: () {
        Navigator.pop(context);
        _selectImage(true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Profile Photo".tr),
      content: Text("Choose a Photo Source".tr),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _selectImage(bool isFromCamera) async {
    if (isFromCamera) {
      pickedFile = await _picker.pickImage(source: ImageSource.camera);
      int sizeInBytes = await pickedFile!.length();
      double sizeInMB = sizeInBytes / (1024 * 1024);
      if (sizeInMB > 3) {
        UIHelper.showMySnak(title: "Media", message: 'Maximum allowed size is 3 MB', isError: true);
        pickedFile = null;
      }
    } else {
      pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      int sizeInBytes = await pickedFile!.length();
      double sizeInMB = sizeInBytes / (1024 * 1024);
      if (sizeInMB > 3) {
        UIHelper.showMySnak(title: "Media", message: 'Maximum allowed size is 3 MB', isError: true);
        pickedFile = null;
      }
    }
    setState(() {});
  }

  socialContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomText(
          text: "Social Media".tr,
          isHeading: true,
          fontSize: 16.0,
        ),
        UIHelper.verticalSpaceMd,
        CustomTextField(
          // focusNode: emailNode,
          required: false,
          keyboard: TextInputType.emailAddress,
          hint: "Enter Your Email".tr,
          labeltext: "Email",
          suffix: const Icon(Icons.link),
          controller: google,
          validator: (value) {
            /* if (value!.isEmpty) {
              // emailNode.requestFocus();
              return "Please enter email".tr;
            } */
            if (!value!.isEmail && value.isNotEmpty) {
              // emailNode.requestFocus();
              return "Please enter valid email".tr;
            }
            return null;
          },
        ),
        UIHelper.verticalSpaceMd,
        CustomTextField(
          // focusNode: facebookNode,
          required: false,
          hint: "Your Facebook Id".tr,
          labeltext: "Facebook id",
          suffix: const Icon(Icons.link),
          controller: facebook,
          formate: [
            FilteringTextInputFormatter.deny(
              RegExp(r'\s'),
            ),
          ],
          validator: (value) {
            /* if (value!.isEmpty) {
              // facebookNode.requestFocus();
              return "Please enter Facebook id".tr;
            } */
            /* if (!RegExp(
                  r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?",
                  caseSensitive: false,
                ).hasMatch(value!) &&
                value.isNotEmpty) {
              // facebookNode.requestFocus();
              return "Please enter valid Facebook id".tr;
            } */
            return null;
          },
        ),
        UIHelper.verticalSpaceMd,
        CustomTextField(
          // focusNode: instagramNode,
          required: false,
          hint: "Your Instagram Id".tr,
          labeltext: "Instagram".tr,
          controller: insta,
          suffix: const Icon(Icons.link),
          validator: (value) {
            /* if (value!.isEmpty) {
              // instagramNode.requestFocus();
              return "Please enter Instagram id".tr;
            } */
            /* if (!RegExp(
                  r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?",
                  caseSensitive: false,
                ).hasMatch(value!) &&
                value.isNotEmpty) {
              // instagramNode.requestFocus();
              return "Please enter valid Instagram id".tr;
            } */
            return null;
          },
        ),
      ],
    );
  }
}
