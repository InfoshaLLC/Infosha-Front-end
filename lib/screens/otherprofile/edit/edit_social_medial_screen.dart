import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/Controller/models/user_full_model.dart';
import 'package:infosha/screens/otherprofile/widgets/social_media_view.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/custom_textfield.dart.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:provider/provider.dart';

class EditSocialMedialScreen extends StatefulWidget {
  bool isMyProfile;
  UserFullModel viewProfileModel;
  String id;
  EditSocialMedialScreen(
      {Key? key,
      required this.isMyProfile,
      required this.viewProfileModel,
      required this.id})
      : super(key: key);

  @override
  _EditSocialMedialScreenState createState() => _EditSocialMedialScreenState();
}

class _EditSocialMedialScreenState extends State<EditSocialMedialScreen> {
  GlobalKey<SocialMediaViewState> socialInfo = GlobalKey();
  TextEditingController google = TextEditingController();
  TextEditingController facebook = TextEditingController();
  TextEditingController insta = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    UserViewModel provider = Provider.of<UserViewModel>(context, listen: false);
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (widget.isMyProfile) {
        setState(() {
          google.text = widget.viewProfileModel.data!.profile!.email!;
          facebook.text = widget.viewProfileModel.data!.profile!.facebookId!;
          insta.text = widget.viewProfileModel.data!.profile!.instagramId!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: CustomText(
          text: 'Edit Social Media'.tr,
          isHeading: true,
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
                    Map<String, String> payload = {};
                    payload.addAll({"user_id": widget.id});

                    payload.addIf(google.text.trim().isNotEmpty, "email",
                        google.text.trim());
                    payload.addIf(facebook.text.trim().isNotEmpty,
                        "facebook_id", facebook.text.trim());
                    payload.addIf(insta.text.trim().isNotEmpty, "instagram_id",
                        insta.text.trim());
                    print(payload);
                    provider.editOtherUserSocialMedia(payload);
                  }
                },
                text:
                    provider.isEditSocialMedia ? "loading" : "Save Changes".tr,
                color: primaryColor,
                textcolor: whiteColor,
              );
            }),
          ),
          //  UIHelper.verticalSpaceSm,
        ],
      ),
      body: Container(
        width: Get.width,
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
            child: Form(
          key: _form,
          child: SizedBox(
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(
                    text: "Social Media".tr,
                    isHeading: true,
                    fontSize: 16.0,
                  ),
                  UIHelper.verticalSpaceMd,
                  CustomTextField(
                    required: false,
                    keyboard: TextInputType.emailAddress,
                    hint: "Enter Your Email".tr,
                    labeltext: "Email",
                    suffix: const Icon(Icons.link),
                    controller: google,
                    validator: (value) {
                      /* if (value!.isEmpty) {
                        return "Please enter email".tr;
                      } */
                      if (!value!.isEmail && value.isNotEmpty) {
                        return "Please enter valid email".tr;
                      }
                      return null;
                    },
                  ),
                  UIHelper.verticalSpaceMd,
                  CustomTextField(
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
                      /*  if (value!.isEmpty) {
                        return "Please enter id".tr;
                      } */
                      /* if (!RegExp(
                            r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?",
                            caseSensitive: false,
                          ).hasMatch(value!) &&
                          value.isNotEmpty) {
                        return "Please enter valid link".tr;
                      } */
                      return null;
                    },
                  ),
                  UIHelper.verticalSpaceMd,
                  CustomTextField(
                    required: false,
                    hint: "Your Instagram Id".tr,
                    labeltext: "Instagram".tr,
                    controller: insta,
                    suffix: const Icon(Icons.link),
                    validator: (value) {
                      /* if (value!.trim().isEmpty) {
                        return "Please enter id".tr;
                      } */
                      /*  if (!RegExp(
                            r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?",
                            caseSensitive: false,
                          ).hasMatch(value!) &&
                          value.isNotEmpty) {
                        return "Please enter valid id".tr;
                      } */
                      return null;
                    },
                  ),
                ],
              )),
        )),
      ),
    );
  }
}
