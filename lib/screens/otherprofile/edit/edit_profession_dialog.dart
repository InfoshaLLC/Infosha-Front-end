import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:infosha/views/custom_textfield.dart.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/Controller/models/profession_model.dart';
import 'package:infosha/views/dropdown_textfield-master/dropdown_textfield.dart';

class EditProfessionDialog extends StatefulWidget {
  bool? isAdd;
  String? id;
  String? existingProfession;
  EditProfessionDialog({Key? key, this.isAdd, this.id, this.existingProfession}) : super(key: key);

  @override
  State<EditProfessionDialog> createState() => _EditProfessionDialogState();
}

class _EditProfessionDialogState extends State<EditProfessionDialog> {
  TextEditingController profcontroller = TextEditingController();

  SingleValueDropDownController professtionDropDownController = SingleValueDropDownController();
  String profession = "";
  String? selectedProfession = "";

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
                            selectedProfession = value;
                            profession = temp.first.id.toString();
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
                          Get.bottomSheet(EditProfessionDialog(isAdd: true, id: widget.id), isScrollControlled: true);
                        }
                      } else {
                        if (profession == "") {
                          UIHelper.showBottomFlash(context, title: "Invalid", message: "Please select Profession", isError: true);
                        } else if (widget.existingProfession == selectedProfession) {
                          UIHelper.showBottomFlash(context, title: "Invalid", message: "Please add a new profession", isError: true);
                        } else {
                          provider.editOtherProfession(widget.id!, profession).then((value) => Get.close(1));
                        }
                      }
                    },
                    text: provider.isEditSocialMedia
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
