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

class BasicInfoView extends StatefulWidget {
  const BasicInfoView({Key? key}) : super(key: key);

  @override
  State<BasicInfoView> createState() => BasicInfoViewState();
}

class BasicInfoViewState extends State<BasicInfoView> {
  bool _valid = true;
  SingleValueDropDownController genderController =
      SingleValueDropDownController();
  TextEditingController dateofbirthController = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController profession = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.width,
        child: Form(
          key: widget.key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomText(
                text: "Basic Information".tr,
                isHeading: true,
                fontSize: 16.0,
              ),
              UIHelper.verticalSpaceMd,
              CustomTextField(
                required: false,
                hint: "Nickname".tr,
                labeltext: "Nickname",
                keyboard: TextInputType.text,
                controller: name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter name";
                  }
                },
              ),
              UIHelper.verticalSpaceMd,
              CustomTextField(
                required: false,
                hint: "Profession".tr,
                labeltext: "Profession",
                controller: profession,
              ),
              UIHelper.verticalSpaceMd,
              SizedBox(
                child: DropDownTextField(
                  padding: const EdgeInsets.all(0),
                  dropdownRadius: 0,

                  textFieldDecoration: InputDecoration(
                    hintText: 'Gender',
                    hintStyle: TextStyle(color: Colors.black),
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(05),
                    ),
                    //   contentPadding: EdgeInsets.only(left: 10)
                  ),

                  // initialValue: "name4",
                  controller: genderController,
                  clearOption: true,
                  enableSearch: true,

                  clearIconProperty: IconProperty(color: lightGrey),
                  searchDecoration: InputDecoration(hintText: "League Name".tr),

                  dropDownItemCount: 5,

                  dropDownList: [
                    DropDownValueModel(name: "Male", value: "Male"),
                    DropDownValueModel(name: "Female", value: "Female"),
                  ],

                  onChanged: (val) {
                    // genderController.dropDownValue = val;
                  },
                ),
              ),
              UIHelper.verticalSpaceMd,
              CustomTextField(
                required: false,
                hint: "Date of Birth".tr,
                controller: dateofbirthController,
                labeltext: "Date of Birth",
                suffix: Icon(Icons.calendar_month_outlined),
                readOnly: true,
                onTap: () {
                  myDateBirthPicker(context, (date) {
                    setState(() {
                      dateofbirthController.text = date.toString();
                    });
                  });
                },
              ),
            ],
          ),
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
