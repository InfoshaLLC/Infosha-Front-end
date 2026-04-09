import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../views/colors.dart';

class CustomTextFieldPhone extends StatefulWidget {
  final String? hint;
  final String? text;
  final TextEditingController? controller;
  final bool? isObscure;
  final Function(PhoneNumber)? onChanged;
  final FormFieldValidator<String>? validator;
  void Function(Country)? onCountryChanged;
  TextInputType? keyboard;
  FocusNode? focusNode;
  bool? isvalid;
  var suffix;
  bool? required;
  CustomTextFieldPhone(
      {this.controller,
      this.hint,
      this.isObscure,
      this.text,
      this.onChanged,
      this.onCountryChanged,
      this.focusNode,
      this.isvalid,
      this.suffix,
      required this.required,
      this.keyboard,
      this.validator});

  @override
  State<CustomTextFieldPhone> createState() => _CustomTextFieldPhoneState();
}

class _CustomTextFieldPhoneState extends State<CustomTextFieldPhone> {
  bool iserror = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: IntlPhoneField(
          autovalidateMode: AutovalidateMode.disabled,
          onChanged: widget.onChanged,
          disableLengthCheck: false,
          showCountryFlag: true,
          controller: widget.controller,
          onCountryChanged: widget.onCountryChanged,
          dropdownTextStyle: textStyleWorkSense(fontSize: 16.0),
          focusNode: widget.focusNode,
          keyboardType: TextInputType.number,
          autofocus: true,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10)
          ],
          disableAutoFillHints: true,
          //  style: textStyleWorkSense(fontSize: 16),
          validator: (p0) {
            if (p0!.isValidNumber()) {
              return "Enter valid number";
            }
          },
          decoration: InputDecoration(
              // labelText: widget.hint,
              alignLabelWithHint: true,
              counterText: "",
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(
                  width: 1,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              fillColor: Colors.transparent,
              hintText: widget.hint,
              hintStyle: textStyleWorkSense(color: hintColor)),
        ),
      );
    });
  }

  String? defaultValidator(value) {
    if (widget.hint == "Email") {
      if (!GetUtils.isEmail(widget.controller!.text)) {
        setState(() {
          iserror = true;
        });
      } else {
        setState(() {
          iserror = false;
        });
      }
    }
    return null;
  }
}
