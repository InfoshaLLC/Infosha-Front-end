// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';

import 'colors.dart';

class CustomNumber extends StatefulWidget {
  final String? hint;
  final String? text;
  final TextEditingController? controller;
  final bool? isObscure;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  TextInputType? keyboard;
  FocusNode? focusNode;
  bool? isvalid;
  Widget? suffix;
  bool? required;
  int? maxLines;
  bool? readOnly;
  double? fontSize;
  var onTap;
  var egText;
  var border;
  var fieldWidth;
  var height;
  var prefix;
  var elevation;
  var formate;
  var mainCrossAlignment;
  var textalign;
  var labeltext;

  CustomNumber(
      {this.controller,
      this.hint,
      this.isObscure,
      this.text,
      this.onChanged,
      this.focusNode,
      this.isvalid,
      this.suffix,
      required this.required,
      this.keyboard,
      this.maxLines,
      this.readOnly,
      this.fontSize,
      this.onTap,
      this.egText,
      this.border,
      this.formate,
      this.fieldWidth,
      this.height,
      this.prefix,
      this.elevation,
      this.mainCrossAlignment,
      this.textalign,
      this.labeltext,
      this.validator});

  @override
  State<CustomNumber> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomNumber> {
  bool iserror = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          widget.mainCrossAlignment ?? CrossAxisAlignment.center,
      children: [
        widget.text != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: CustomText(
                  text: widget.text!.tr,
                  fontSize: 14.0,
                  weight: fontWeightMedium,
                ),
              )
            : Container(),
        Container(
          width: widget.fieldWidth ?? MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(vertical: widget.text != null ? 8 : 0),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: widget.elevation ?? 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    widget.keyboard == TextInputType.multiline
                        ? 15
                        : widget.border ?? 5)),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText:
                      widget.isObscure != null ? widget.isObscure! : false,
                  maxLines: widget.keyboard == TextInputType.multiline
                      ? widget.maxLines ?? 6
                      : 1,
                  readOnly: widget.readOnly ?? false,
                  controller: widget.controller,
                  onChanged: widget.onChanged,
                  onTap: widget.onTap,
                  focusNode: widget.focusNode,
                  validator: widget.validator ?? defaultValidator,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10)
                  ],
                  textAlign: widget.textalign ?? TextAlign.start,
                  decoration: InputDecoration(
                      focusedBorder: widget.keyboard == TextInputType.multiline
                          ? InputBorder.none
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(widget.border ?? 3.0),
                              ),
                              borderSide: BorderSide(
                                width: 1,
                                color: primaryColor,
                                // style: BorderStyle.none,
                              ),
                            ),
                      border: widget.keyboard == TextInputType.multiline
                          ? InputBorder.none
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(widget.border ?? 3.0),
                              ),
                            ),
                      filled: false,
                      // contentPadding:
                      //     EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      focusColor: Colors.black,
                      hoverColor: Colors.black,
                      fillColor: lightGrey.withOpacity(0.4),
                      hintText: widget.hint,
                      labelStyle: textStyleWorkSense(
                          color: const Color(0xFF46464F), fontSize: 16.0),
                      // labelText:
                      //     widget.labeltext == "none" ? null : widget.hint,
                      suffixIcon: widget.suffix,
                      prefixIcon: widget.prefix,
                      hintStyle: textStyleWorkSense(
                          fontSize: 14.0,
                          color: const Color(0xFF46464F),
                          weight: fontWeightMedium)),
                )),
          ),
        ),
      ],
    );
  }

  String? defaultValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }
}
