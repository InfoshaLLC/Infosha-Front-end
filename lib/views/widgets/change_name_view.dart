import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/models/contact_model.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChangeNameView extends StatefulWidget {
  ContactModel? contact;

  var fontcolor;
  var fontsize;
  var imgsize;
  ChangeNameView(
      {Key? key, this.contact, this.fontcolor, this.fontsize, this.imgsize})
      : super(key: key);

  @override
  _ChangeNameViewState createState() => _ChangeNameViewState();
}

class _ChangeNameViewState extends State<ChangeNameView> {
  final GlobalKey _buttonKey = GlobalKey();
  Map<String, String> list = {
    'Ayesha Ahmad': " Allena Saad",
    'Asho Ali': " Allena Saad",
    'Ashi Khan': " Allena Saad",
    'Ashi G': " Allena Saad",
  };
  var selectedName = "Ayesha Ahmad";
  late SingleValueDropDownController nickNameController =
      SingleValueDropDownController();
  @override
  void initState() {
    super.initState();
    setState(() {
      nickNameController.dropDownValue =
          DropDownValueModel(name: selectedName, value: selectedName);
      if (widget.contact != null && widget.contact!.name != "") {
        selectedName = widget.contact!.name ?? "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      constraints: BoxConstraints(
          maxHeight: Get.height * 0.6,
          maxWidth: Get.width * 0.7,
          minWidth: Get.width * 0.4),
      //offset: Offset(5, 6),
      position: PopupMenuPosition.under,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: selectedName,
            color: widget.fontcolor ?? whiteColor,
            fontSize: widget.fontsize ?? 16.sp,
            weight: fontWeightMedium,
          ),
          const SizedBox(
            width: 5,
          ),
          Image(
            fit: BoxFit.cover,
            height: widget.imgsize ?? 35,
            width: widget.imgsize ?? 35,
            filterQuality: FilterQuality.high,
            image: AssetImage(
              APPICONS.copyicon,
            ),
          ),
        ],
      ),
      itemBuilder: (context) {
        return list.entries.map((e) {
          return PopupMenuItem<String>(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              value: e.key,
              child: RichText(
                  text: TextSpan(children: [
                WidgetSpan(
                    child: CustomText(
                  text: e.key,
                  color: Colors.black,
                  fontSize: 16.sp,
                  weight: fontWeightMedium,
                )),
                WidgetSpan(
                    child: CustomText(
                  text: " (By ${e.value})",
                  color: hintColor,
                  fontSize: 14.sp,
                  weight: fontWeightRegular,
                ))
              ])));
        }).toList();
      },
      onSelected: (data) {
        setState(() {
          selectedName = data;
        });
      },
    );
  }

  void showDialogRelativeToButton(BuildContext context) {
    final RenderBox buttonBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset buttonPosition = buttonBox.localToGlobal(Offset.zero);

    showOverlay(
      context,
      buttonPosition,
    );
  }

  Positioned showOverlay(BuildContext context, Offset buttonPosition) {
    OverlayState overlayState = Overlay.of(context)!;
    OverlayEntry overlayEntry;
    return Positioned(
      top: buttonPosition.dy + 50, // Adjust the position as needed
      //  left: buttonPosition.dx,
      child: AlertDialog(
        title: Text('Smart Dialog'),
        content: Text('This is a smart dialog based on button position.'),
      ),
    );
  }
}
