import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/Controller/models/profession_model.dart';
import 'package:infosha/screens/otherprofile/view_profile_screen.dart';

import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/custom_textfield.dart.dart';
import 'package:infosha/views/dropdown_textfield-master/dropdown_textfield.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:provider/provider.dart';

class EditProfessionDialogUnregister extends StatefulWidget {
  bool? isAdd, isMe;
  String? id;
  Function? callback;
  EditProfessionDialogUnregister({
    Key? key,
    this.isAdd,
    this.id,
    required this.isMe,
    this.callback,
  }) : super(key: key);

  @override
  State<EditProfessionDialogUnregister> createState() => _EditProfessionDialogState();
}

class _EditProfessionDialogState extends State<EditProfessionDialogUnregister> {
  TextEditingController profcontroller = TextEditingController();

  SingleValueDropDownController professtionDropDownController = SingleValueDropDownController();
  String profession = "";

  @override
  void initState() {
    Provider.of<UserViewModel>(context, listen: false).getProfession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(builder: (context, provider, child) {
      return provider.listDummyProfesstions.isEmpty
          ? Container(
              width: Get.width,
              height: Get.height * 0.4,
              decoration: const BoxDecoration(
                  color: whiteColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35))),
              padding: const EdgeInsets.all(15),
              child: const Center(child: CircularProgressIndicator(color: baseColor)),
            )
          : Container(
              width: Get.width,
              decoration: const BoxDecoration(
                  color: whiteColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35))),
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Image(
                          width: 40,
                          image: AssetImage('images/linee.png'),
                        ),
                      ],
                    ),
                  ),
                  UIHelper.verticalSpaceL,
                  CustomText(
                    text: widget.isAdd != null ? "Add New Profession " : "Edit Profession of Username".tr,
                    isHeading: true,
                    fontSize: 16.0,
                  ),
                  UIHelper.verticalSpaceMd,
                  widget.isAdd != null
                      ? CustomDropdown<String>.search(
                          hintText: 'Profession'.tr,
                          items: provider.listDummyProfesstions.map((e) => e.profession!).toList(),
                          overlayHeight: Get.height * 0.6,
                          onChanged: (value) {
                            var temp = provider.listDummyProfesstions.where((element) => element.profession == value);
                            profession = temp.first.profession.toString();
                          },
                          searchHintText: "Profession".tr,
                          hintBuilder: (context, hint, bool enabled) => CustomText(text: "Profession", fontSize: 16.0),
                        )
                      : CustomTextField(
                          required: true,
                          labeltext: "Profession",
                          controller: profcontroller,
                          hint: "@Model",
                          formate: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                          ],
                        ),
                  UIHelper.verticalSpaceL,
                  CustomButton(
                    () async {
                      if (widget.isAdd == null) {
                        if (provider.listDummyProfesstions.any((element) => element.profession!.toLowerCase() == profcontroller.text.toLowerCase())) {
                          UIHelper.showMySnak(title: "Profession", message: "Profession is already in list", isError: true);
                        } else {
                          await provider.addNewProfession(profcontroller.text.trim().capitalize!);
                          Get.close(1);
                          Get.bottomSheet(EditProfessionDialogUnregister(isAdd: true, id: widget.id, isMe: widget.isMe, callback: widget.callback),
                              isScrollControlled: true);
                          if (widget.callback != null) {
                            widget.callback!(ViewProfileScreen(id: widget.id.toString()));
                          }
                        }
                      } else {
                        if (profession == "") {
                          UIHelper.showBottomFlash(context, title: "Invalid", message: "Please select Profession", isError: true);
                        } else {
                          if (widget.isMe == false) {
                            Map<String, String> payload = {};
                            payload.addAll({"number": widget.id.toString()});
                            payload.addIf(profession != "Profession", "profession", profession);

                            provider.editOtherSocialMediaUnregistered(payload);
                          } else {
                            var payload = {
                              "profession": profession != "Profession" ? profession : "",
                            };
                            provider.editBio(payload);
                          }
                        }
                      }
                    },
                    text: (widget.isMe == true ? provider.isAuthenticating : provider.isEditUnregisterUser)
                        ? "loading"
                        : widget.isAdd == null
                            ? "Save Changes".tr
                            : "Save",
                    color: primaryColor,
                    textcolor: whiteColor,
                  ),
                  UIHelper.verticalSpaceMd
                ],
              ),
            );
    });
  }
}
