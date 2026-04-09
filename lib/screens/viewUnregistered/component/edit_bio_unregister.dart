import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/colors.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:infosha/views/custom_textfield.dart.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:infosha/Controller/models/user_full_model.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/otherprofile/widgets/placeinformation_view.dart';
import 'package:infosha/screens/otherprofile/widgets/basic_information_view.dart';
import 'package:infosha/screens/viewUnregistered/model/unregistered_user_model.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

class EditBioUnregister extends StatefulWidget {
  String id;
  UnregisteredUserModel viewProfileModel;
  EditBioUnregister({Key? key, required this.id, required this.viewProfileModel}) : super(key: key);

  @override
  _EditBioScreenState createState() => _EditBioScreenState();
}

class _EditBioScreenState extends State<EditBioUnregister> {
  final _picker = ImagePicker();
  GlobalKey<BasicInfoViewState> basicInfo = GlobalKey();
  GlobalKey<PlaceInforViewState> placeInfo = GlobalKey();

  TextEditingController name = TextEditingController();
  TextEditingController profession = TextEditingController();
  String selectedGender = "Male";
  String selectedDob = "";
  // SingleValueDropDownController genderController =
  //     SingleValueDropDownController();
  TextEditingController dateofbirthController = TextEditingController();
  // SingleValueDropDownController countryController =
  //     SingleValueDropDownController();
  // SingleValueDropDownController citycontroller =
  //     SingleValueDropDownController();
  TextEditingController address = TextEditingController();
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String gender = "Gender";
  String selectedProfession = "Profession";
  List<String> professionList = [];
  late UserViewModel provider;
  XFile? pickedFile;

  @override
  void initState() {
    super.initState();

    provider = Provider.of<UserViewModel>(context, listen: false);
    professionList.clear();
    setState(() {
      name.text = widget.viewProfileModel.data!.name!;

      profession.text = widget.viewProfileModel.data!.profession ?? "";

      if (widget.viewProfileModel.data!.gender != null && widget.viewProfileModel.data!.gender != "") {
        gender = toBeginningOfSentenceCase(widget.viewProfileModel.data!.gender)!;
      }

      if (widget.viewProfileModel.data!.dob != null && widget.viewProfileModel.data!.dob != "") {
        dateofbirthController.text = DateFormat('yyyy-MM-dd').format(DateFormat("yyyy-MM-dd").parse(widget.viewProfileModel.data!.dob!));
      }

      if (provider.listDummyProfesstions.isNotEmpty) {
        professionList = provider.listDummyProfesstions.map((e) => e.profession!).toList();
        professionList.insert(0, "Profession");
      }
    });
  }

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Consumer<UserViewModel>(builder: (context, provider, child) {
              return CustomButton(
                () async {
                  if (_form.currentState!.validate()) {
                    /* if (gender == "Gender") {
                      UIHelper.showBottomFlash(context,
                          title: "Invalid",
                          message: "Please select Gender",
                          isError: true);
                    } else if (countryValue == "") {
                      UIHelper.showBottomFlash(context,
                          title: "Invalid",
                          message: "Please select Country",
                          isError: true);
                    } else if (stateValue == "") {
                      UIHelper.showBottomFlash(context,
                          title: "Invalid",
                          message: "Please select State",
                          isError: true);
                    } else if (cityValue == "") {
                      UIHelper.showBottomFlash(context,
                          title: "Invalid",
                          message: "Please select City",
                          isError: true);
                    } /* else if (pickedFile == null) {
                        UIHelper.showBottomFlash(context,
                            title: "Invalid",
                            message: "Please select profile photo",
                            isError: true);
                      }  */
                    else { */
                    Map<String, String> payload = {};
                    payload.addAll({"number": widget.id});
                    // payload.addIf(
                    //     name.text.trim().isNotEmpty, "name", name.text.trim());
                    payload.addIf(name != "Name", "name", name.text);
                    payload.addIf(gender != "Gender", "gender", gender);
                    payload.addIf(selectedProfession != "Profession", "profession", selectedProfession);
                    // payload.addIf(profession.text.trim().isNotEmpty,
                    //     "profession", profession.text.trim());
                    payload.addIf(dateofbirthController.text.trim().isNotEmpty, "dob", dateofbirthController.text.trim());
                    payload.addIf(countryValue != "", "country", countryValue);
                    payload.addIf(stateValue != "", "state", stateValue);
                    payload.addIf(cityValue != "", "city", cityValue);
                    payload.addIf(address.text.trim().isNotEmpty, "address", address.text.trim());

                    // if (pickedFile != null) {
                    //   payload.addIf(pickedFile != null, "photo", base64.encode(await pickedFile!.readAsBytes()));
                    // }
                    print("payload ==> $payload");

                    provider.editOtherSocialMediaUnregistered(payload, img: pickedFile);
                    // }
                  }
                },
                text: provider.isEditUnregisterUser ? "loading" : "Save Changes".tr,
                color: primaryColor,
                textcolor: whiteColor,
              );
            }),
          ),
          // UIHelper.verticalSpaceSm,
        ],
      ),
      body: Container(
        width: Get.width,
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                profileicon(context),
                UIHelper.verticalSpaceMd,
                basicInfoContainer(),
                UIHelper.verticalSpaceL,
                placeContainer(),
                UIHelper.verticalSpaceMd,
              ],
            ),
          ),
        ),
      ),
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

  Container profileicon(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Stack(children: [
        pickedFile != null
            ? CircleAvatar(
                radius: 50.0,
                backgroundImage: FileImage(File(pickedFile!.path)),
              )
            // : CircleAvatar(
            //     radius: 50.0,
            //     backgroundImage: CachedNetworkImageProvider(""),
            //   ),
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
                onPressed: () {
                  showAlertForImageSelection(context);
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
          required: false,
          // readOnly: true,
          hint: "Nickname",
          labeltext: "Nickname",
          keyboard: TextInputType.text,
          controller: name,
          validator: (value) {
            if (value!.trim().isEmpty) {
              return "Enter name".tr;
            }
            return null;
          },
        ),
        UIHelper.verticalSpaceMd,
        /* CustomTextField(
          required: false,
          hint: "Profession",
          labeltext: "Profession",
          controller: profession,
          validator: (value) {
            // if (value!.trim().isEmpty) {
            //   return "Please Enter Profession".tr;
            // }
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
              value: gender,
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
      //),
      maxDateTime: DateTime(date.year, date.month - 0, date.day),
      //dateFormat: "dd, MMMM, yyyy",
      dateFormat: "dd, MMMM, yyyy",
      onChange: (dateTime, selectedIndex) {
        print('change $selectedIndex');
        final DateFormat formatter = DateFormat('yyyy-MM-dd');

        final String formateDate = formatter.format(dateTime);

        onPick(formateDate);
      },
      pickerTheme: DateTimePickerTheme(itemTextStyle: textStyleWorkSense(color: Colors.black, fontSize: 16.0)),
      onConfirm: (date, selectedIndex) {
        final DateFormat formatter = DateFormat('yyyy-MM-dd');

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

          /* currentCountry: widget.viewProfileModel.data!.profile!.country != null
              ? toBeginningOfSentenceCase(
                  widget.viewProfileModel.data!.profile!.country!)
              : null,
          currentState: widget.viewProfileModel.data!.profile!.state != null
              ? toBeginningOfSentenceCase(
                  widget.viewProfileModel.data!.profile!.state!)
              : null,
          currentCity: widget.viewProfileModel.data!.profile!.city != null
              ? toBeginningOfSentenceCase(
                  widget.viewProfileModel.data!.profile!.city!)
              : null,
 */
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
          required: true,
          hint: "Address".tr,
          labeltext: "Address",
          controller: address,
          validator: (value) {
            /* if (value!.trim().isEmpty) {
              return "Please Enter Address".tr;
            } */
            return null;
          },
        ),
      ],
    );

    /* return Container(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomText(
              text: "Place".tr,
              isHeading: true,
              fontSize: 16.0,
            ),
            UIHelper.verticalSpaceMd,
            DropDownTextField(
              padding: const EdgeInsets.all(0),
              dropdownRadius: 0,
              textFieldDecoration: InputDecoration(
                hintText: 'Country'.tr,
                hintStyle: TextStyle(color: Colors.black),
                labelText: 'Country'.tr,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(05),
                ),
              ),
              dropdownColor: lightBlue,

              // initialValue: "name4",
              controller: countryController,
              clearOption: true,
              enableSearch: true,

              clearIconProperty: IconProperty(color: lightGrey),
              searchDecoration: InputDecoration(hintText: "Country Name".tr),

              dropDownItemCount: 5,

              dropDownList: [
                DropDownValueModel(name: "America", value: "America"),
                DropDownValueModel(name: "Pakistan", value: "Pakistan"),
                DropDownValueModel(name: "India", value: "India"),
              ],

              onChanged: (val) {
                setState(() {
                  countryController.dropDownValue = val;
                });
              },
            ),
            UIHelper.verticalSpaceMd,
            DropDownTextField(
              padding: const EdgeInsets.all(0),
              dropdownRadius: 0,
              textFieldDecoration: InputDecoration(
                hintText: 'City'.tr,
                hintStyle: TextStyle(color: Colors.black),
                labelText: 'City'.tr,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(05),
                ),
              ),
              dropdownColor: lightBlue,

              // initialValue: "name4",
              controller: citycontroller,
              clearOption: true,
              enableSearch: true,

              clearIconProperty: IconProperty(color: lightGrey),
              searchDecoration: InputDecoration(hintText: "City Name".tr),

              dropDownItemCount: 5,

              dropDownList: [
                DropDownValueModel(name: "Gujranwala", value: "Gujranwala"),
                DropDownValueModel(name: "Lahore", value: "Lahore"),
                DropDownValueModel(name: "Sialkot", value: "Sialkot"),
              ],

              onChanged: (val) {
                setState(() {
                  citycontroller.dropDownValue = val;
                });
              },
            ),
            UIHelper.verticalSpaceSm,
            CustomTextField(
              required: true,
              hint: "Address".tr,
              labeltext: "Address",
              controller: address,
            ),
          ],
        ));
   */
  }
}
