import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/custom_textfield.dart.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';

class PlaceInforView extends StatefulWidget {
  const PlaceInforView({Key? key}) : super(key: key);

  @override
  State<PlaceInforView> createState() => PlaceInforViewState();
}

class PlaceInforViewState extends State<PlaceInforView> {
  SingleValueDropDownController CountryController =
      SingleValueDropDownController();
  SingleValueDropDownController citycontroller =
      SingleValueDropDownController();
  TextEditingController address = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
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

              // initialValue: "name4",
              controller: CountryController,
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
                  CountryController.dropDownValue = val;
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
              required: false,
              hint: "Address".tr,
              labeltext: "Address",
              controller: address,
            ),
          ],
        ));
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
      },
      pickerTheme: DateTimePickerTheme(
          itemTextStyle:
              textStyleWorkSense(color: Colors.black, fontSize: 16.0)),
      onConfirm: (date, selectedIndex) {
        final DateFormat formatter = DateFormat('yyyy-MM-dd');

        final String formateDate = formatter.format(date);

        onPick(formateDate);

        print('confirm $formateDate');
      },
    );
  }
}
