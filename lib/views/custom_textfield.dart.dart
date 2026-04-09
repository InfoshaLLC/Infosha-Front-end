// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';

import 'colors.dart';

class CustomTextField extends StatefulWidget {
  final String? hint;
  final String? text;
  final TextEditingController? controller;
  final bool? isObscure;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  TextInputType? keyboard;
  FocusNode? focusNode;
  bool? isvalid;
  var suffix;
  bool? required;
  int? maxLines, minLine;
  var readOnly;
  var fontSize;
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

  CustomTextField(
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
      this.minLine,
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
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
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

          //   height: widget.height ?? 50.0,
          // height: widget.keyboard == TextInputType.multiline
          //     ? widget.maxLines != null
          //         ? 50 * widget.maxLines!.toDouble()
          //         : 200
          //     : 50,
          margin: EdgeInsets.symmetric(vertical: widget.text != null ? 8 : 0),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: widget.elevation ?? 0,
            shape: RoundedRectangleBorder(
                // side: BorderSide(width: 1, color: whiteColor),
                borderRadius: BorderRadius.circular(
                    widget.keyboard == TextInputType.multiline
                        ? 15
                        : widget.border ?? 5)),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  minLines: widget.keyboard == TextInputType.multiline
                      ? widget.minLine ?? 5
                      : 1,
                      
                  obscureText:
                      widget.isObscure != null ? widget.isObscure! : false,
                  keyboardType: widget.keyboard ?? TextInputType.text,
                  maxLines: widget.keyboard == TextInputType.multiline
                      ? widget.maxLines ?? 6
                      : 1,
                  readOnly: widget.readOnly ?? false,
                  controller: widget.controller,
                  onChanged: widget.onChanged,
                  onTap: widget.onTap,
                  focusNode: widget.focusNode,
                  validator: widget.validator ?? defaultValidator,
                  inputFormatters: widget.formate ?? [],
                  // inputFormatters: [
                  //   widget.keyboard == TextInputType.number ||
                  //           widget.keyboard ==
                  //               TextInputType.numberWithOptions(decimal: true)
                  //       ? ThousandsFormatter(allowFraction: true)
                  //       : TextInputFormatter.withFunction(
                  //           (oldValue, newValue) => newValue)
                  // ],
                  textAlign: widget.textalign ?? TextAlign.start,
                  // style: textStyleInter(
                  //   fontSize: 16,
                  //   color: Colors.black,
                  //   //  weight: FontWeight.w400
                  // ),
                  decoration: InputDecoration(
                      // label: widget.text != null
                      //     ? Text(widget.text!)
                      //     : Container(),
                      //   alignLabelWithHint: true,

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
                      hintText: widget.hint?.tr,
                      labelText:
                          widget.labeltext == "none" ? null : widget.hint?.tr,
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

class NoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Check if the new value contains any spaces
    if (newValue.text.contains(' ')) {
      // If it does, return the old value
      return oldValue;
    }
    // Otherwise, return the new value
    return newValue;
  }
}
