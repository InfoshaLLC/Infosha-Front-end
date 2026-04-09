/* import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_feed_reaction/flutter_feed_reaction.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/reaction.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/Controller/models/contact_model.dart';
import 'package:infosha/Controller/models/dummy_reviewmodel.dart';
import 'package:infosha/Controller/models/user_model.dart';
import 'package:infosha/followerscreen/followerscreen.dart';
import 'package:infosha/screens/ProfileScreen/menupop.dart';
import 'package:infosha/screens/ProfileScreen/profilerating.dart';
import 'package:infosha/screens/otherprofile/add_review_dialog.dart';
import 'package:infosha/screens/otherprofile/edit/edit_bio_screen.dart';
import 'package:infosha/screens/otherprofile/edit/edit_profession_dialog.dart';
import 'package:infosha/screens/otherprofile/edit/edit_social_medial_screen.dart';
import 'package:infosha/screens/otherprofile/view_profile_screen.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:infosha/views/widgets/call_number_view.dart';
import 'package:infosha/views/widgets/change_name_view.dart';
import 'package:infosha/views/widgets/like_dislike_button.dart';
import 'package:infosha/views/widgets/my_reactionButton.dart';
import 'package:infosha/views/widgets/namewithlabel_view.dart';
import 'package:infosha/views/widgets/nickname_view.dart';
import 'package:infosha/views/widgets/rating_view.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

import '../../Controller/models/user_full_model.dart';
import '../home/DraggableHome/dragable_home.dart';

import 'package:shimmer/shimmer.dart';

class OtheruserprofileScreen extends StatefulWidget {
  String id;
  OtheruserprofileScreen({Key? key, required this.id}) : super(key: key);

  @override
  _OtheruserprofileScreenState createState() => _OtheruserprofileScreenState();
}

class _OtheruserprofileScreenState extends State<OtheruserprofileScreen> {
  int selectedLikeState = -1;
  UserViewModel? provider;

  @override
  void initState() {
    provider = Provider.of<UserViewModel>(context, listen: false);
    print("id ==> ${widget.id}");

    provider!.getOtherUserId(widget.id.toString()).then((value) {
      setState(() {
        if (provider!.otherUserModel!.data!.likeStatus == true) {
          selectedLikeState = 0;
        } else if (provider!.otherUserModel!.data!.dislikeStatus == true) {
          selectedLikeState = 1;
        } else {
          selectedLikeState = -1;
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<UserViewModel>(builder: (context, provider, child) {
      return provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: baseColor,
            ))
          : DraggableHome(
              centerTitle: false,
              headerBottomBar: Container(
                transform: Matrix4.translationValues(0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LikeDislikeButton(
                      usercounts: int.parse(
                          provider.otherUserModel!.data!.likeCount.toString()),
                      isLikeButton: true,
                      likestatus: 0,
                      isActive: selectedLikeState == 0,
                      oncallback: (value) {
                        if (value != null) {
                          setState(() {
                            if (selectedLikeState == 0) {
                              selectedLikeState = -1;
                            } else {
                              selectedLikeState = value;
                              provider.likeDislike(widget.id, true);
                            }
                          });
                          print(selectedLikeState);
                        }
                      },
                    ),
                    UIHelper.horizontalSpaceSm,
                    LikeDislikeButton(
                      usercounts: provider.otherUserModel!.data != null
                          ? int.parse(provider
                              .otherUserModel!.data!.dislikeCount
                              .toString())
                          : 0,
                      isLikeButton: false,
                      likestatus: 1,
                      isActive: selectedLikeState == 1,
                      oncallback: (value) {
                        setState(() {
                          if (value != null) {
                            setState(() {
                              if (selectedLikeState == 1) {
                                selectedLikeState = -1;
                              } else {
                                selectedLikeState = value;
                                provider.likeDislike(widget.id, false);
                              }
                            });
                            print(selectedLikeState);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),

              title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(APPICONS.profileicon),
                    radius: 20.0,
                  ),
                  UIHelper.horizontalSpaceSm,
                  CustomText(
                    text: provider.otherUserModel!.data!.username != null
                        ? provider.otherUserModel!.data!.username!
                        : "",
                    fontSize: 16.0,
                    weight: fontWeightMedium,
                    color: Colors.black,
                  ),
                ],
              ),
              // headerExpandedHeight: selectedHeaderTextHeight / Get.height,
              // stretchMaxHeight: selectedHeaderTextHeight / Get.height + 0.05,

              actions: [UIHelper.horizontalSpaceSm, menuPopClass()],
              headerExpandedHeight: 0.64,
              expandedHeight: Get.height * 0.64,
              alwaysShowLeadingAndAction: true,
              headerWidget: headerWidget(
                  UserFullModel.fromJson(provider.otherUserModel!.toJson())),
              // physics: ClampingScrollPhysics(),

              curvedBodyRadius: 0,

              body: [
                Container(
                  //  height: Get.height,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Consumer<UserViewModel>(
                      builder: (context, provider, child) {
                    return Column(
                      children: [
                        headerWithEdit(
                            label: "Bio".tr,
                            ontap: () {
                              Get.to(() => EditBioScreen(
                                  isMyProfile: false,
                                  id: widget.id,
                                  viewProfileModel: provider.otherUserModel!));
                            }),
                        UIHelper.verticalSpaceSm,
                        ListTilewidget(
                            txt: provider.otherUserModel!.data!.profile!
                                        .gender !=
                                    null
                                ? provider
                                    .otherUserModel!.data!.profile!.gender!
                                : "-"),
                        ListTilewidget(
                            image: "images/cases.png",
                            txt: provider.otherUserModel!.data!.profile!.dob !=
                                    null
                                ? DateFormat('yyyy-MM-dd').format(
                                    provider.otherUserModel!.data!.profile!.dob)
                                : '-'),
                        ListTilewidget(
                            image: "images/locationnn.png",
                            txt: provider.otherUserModel!.data!.profile!
                                        .location !=
                                    null
                                ? provider
                                    .otherUserModel!.data!.profile!.location!
                                : "Location not found"),
                        ListTilewidget(
                            image: "images/location.png",
                            txt: provider.otherUserModel!.data!.profile!
                                        .address !=
                                    null
                                ? provider
                                    .otherUserModel!.data!.profile!.address!
                                : "Address not found"),
                        UIHelper.verticalSpaceMd,
                        headerWithEdit(
                            label: "Social Media".tr,
                            ontap: () {
                              Get.to(() => EditSocialMedialScreen(
                                    isMyProfile: false,
                                  ));
                            }),
                        UIHelper.verticalSpaceSm,
                        // Wrap(
                        //   children: widget.contact.accounts
                        //       .map((e) => ListTilewidget(
                        //           image: "images/message.png",
                        //           txt: "ayesha@gmail.com",
                        //           isFullWidth: false))
                        //       .toList(),
                        // ),
                        SizedBox(
                          width: Get.width,
                          child: Wrap(
                            spacing: 20.0,
                            children: [
                              ListTilewidget(
                                  image: "images/message.png",
                                  txt: provider.otherUserModel!.data!.profile!
                                              .email !=
                                          null
                                      ? provider
                                          .otherUserModel!.data!.profile!.email!
                                      : "--",
                                  isFullWidth: false,
                                  isimageicon: true),
                              ListTilewidget(
                                  image: "images/facebook.png",
                                  txt: provider.otherUserModel!.data!.profile!
                                              .facebookId !=
                                          null
                                      ? provider.otherUserModel!.data!.profile!
                                          .facebookId!
                                      : "--",
                                  isimageicon: true,
                                  isFullWidth: false),
                              ListTilewidget(
                                  image: "images/instagram.png",
                                  txt: provider.otherUserModel!.data!.profile!
                                              .instagramId !=
                                          null
                                      ? provider.otherUserModel!.data!.profile!
                                          .instagramId!
                                      : "--",
                                  isimageicon: true,
                                  isFullWidth: false),
                            ],
                          ),
                        ),
                        UIHelper.verticalSpaceMd,
                        if (provider.otherUserModel!.data!.followers !=
                            null) ...[
                          headerWithEdit(
                            label: "Followers".tr,
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => allFollowers(
                                      isMyFollowers: false,
                                    ));
                              },
                              child: Text(
                                "See All".tr,
                                style: const TextStyle(
                                    color: Color(0xFf1B2870),
                                    fontSize: 14,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                          UIHelper.verticalSpaceSm,
                          SizedBox(
                            height: Get.height * 0.25,
                            child: ListView.builder(
                                itemCount: provider
                                    .otherUserModel!.data!.followers!.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return followerAdaptor(provider
                                      .otherUserModel!.data!.followers![index]);
                                }),
                          ),
                        ],
                        UIHelper.verticalSpaceSm,
                        // provider.otherUserModel!.data == null
                        //     ? Container()
                        //     : provider.otherUserModel!.data.following.isEmpty
                        //         ? Container(
                        //             alignment: Alignment.centerLeft,
                        //             child: CustomText(
                        //               text: "Not have any follower",
                        //             ),
                        //           )
                        //         : Container(
                        //             height: 185,
                        //             alignment: Alignment.centerLeft,
                        //             child: ListView.builder(
                        //                 shrinkWrap: true,
                        //                 itemCount: provider.otherUserModel!.data.following.length,
                        //                 scrollDirection: Axis.horizontal,
                        //                 itemBuilder: (context, index) {
                        //                   Follower model = provider.otherUserModel!.data.following[index];
                        //                   return followerAdaptor(model);
                        //                 }),
                        //           ),
                        UIHelper.verticalSpaceMd,
                        headerWithEdit(
                          label: "Reviews".tr,
                          child: addReviewButton(),
                        ),
                        UIHelper.verticalSpaceSm,
                        Column(
                          children: provider.listReviews.map((e) {
                            return reviewAdaptor(context, e);
                          }).toList(),
                        )
                      ],
                    );
                  }),
                ),
              ],
              fullyStretchable: false,
              // expandedBody: const CameraPreview(),
              backgroundColor: Colors.white,
              //  bottomNavigationBar: MyCustomNav(0),

              appBarColor: Colors.white,
            );
    }));
  }

  SizedBox loadingWidget() {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Column(
        children: [
          SizedBox(
            width: Get.width,
            height: 300,
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              child: ShapeOfView(
                elevation: 3.0,
                shape: ArcShape(
                    direction: ArcDirection.Outside,
                    height: 30,
                    position: ArcPosition.Bottom),
                child: Container(
                  // height: 300,
                  width: Get.width,
                  color: secondaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding reviewAdaptor(BuildContext context, DummyReviewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          // height: 210,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Color(0xFFF2F7F7),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 22,
                  child: Image(
                    filterQuality: FilterQuality.high,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    image: const AssetImage('images/oval.png'),
                  ),
                ),
                title: Text(
                  model.nickname,
                  style: const TextStyle(fontSize: 12),
                ),
                subtitle: Text(
                  Jiffy.parse(model.createdAt.toString()).fromNow(),
                  style:
                      const TextStyle(color: Color(0xFFABAAB4), fontSize: 13),
                ),

                trailing: SizedBox(
                  height: 40,
                  // width: 108,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyCustomRatingView(
                        starSize: 12.0,
                        ratinigValue: model.rating,
                      ),
                      menuPopClass(),
                    ],
                  ),
                ),
                //subtitle:
                contentPadding: const EdgeInsets.only(right: 1, left: 20),
              ),
              model.imgPath != ""
                  ? Image.file(
                      File(model.imgPath),
                      width: 100.w,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
                child: Row(
                  children: [
                    SizedBox(
                      // width: MediaQuery.of(context).size.width,
                      width: 350,
                      child: Text(
                        model.comment,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF767680),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          width: 1,
                          height: 24,
                          color: Colors.black38,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              print("like/...");
                            },
                            child: const SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Image(
                                    width: 40,
                                    height: 20,
                                    image: AssetImage('images/like_unfill.png'),
                                  ),
                                  Text("1.5K",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          width: 1,
                          height: 24,
                          color: Colors.black38,
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Image(
                                    height: 20,
                                    width: 30,
                                    image: AssetImage('images/unlike.png')),
                                Text("1.5K",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          width: 1,
                          height: 24,
                          color: Colors.black38,
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Image(
                                    height: 17,
                                    width: 30,
                                    image: AssetImage('images/comments.png')),
                                Text("1.5K",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  MyReactionButton(
                    reactionCount: "0",
                    commentid: "",
                    oncallback: (val) {},
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell addReviewButton() {
    return InkWell(
      onTap: () {
        Get.dialog(AddReviewDialog(id: widget.id));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            children: [
              const Icon(
                Icons.star_border_outlined,
                color: whiteColor,
                size: 18,
              ),
              const SizedBox(
                width: 5,
              ),
              CustomText(
                text: "Add review".tr,
                fontSize: 15.0.sp,
                weight: fontWeightMedium,
                color: whiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  followerAdaptor(Followers data) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ViewProfileScreen(id: data.id.toString())));
        // Get.to(() => OtheruserprofileScreen(id: data.id.toString()));
      },
      child: Card(
        color: lightBlue,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: Get.width * 0.4,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(APPICONS.profileicon),
                radius: Get.width * 0.06,
              ),
              MyCustomRatingView(
                starSize: 12.0,
                ratinigValue: 3.2,
              ),
              CustomText(
                text: data.profile!.profession ?? "",
                fontSize: 12.0,
                weight: fontWeightMedium,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // width: Get.width * 0.25,
                    // color: Colors.red,
                    constraints: BoxConstraints(maxWidth: Get.width * 0.25),
                    child: AutoSizeText(
                      data.username ?? "",
                      maxLines: 1,
                      minFontSize: 10,
                      maxFontSize: 16.0,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: textStyleWorkSense(
                          weight: fontWeightSemiBold, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Image(
                    height: 14.0,
                    image: AssetImage(
                      APPICONS.lordicon,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.verified,
                    color: Color(0xFF007EFF),
                    size: 14.0,
                  ),
                ],
              ),
              CallNumberView(
                phoneNumber: data.number,
                color: Colors.grey,
                size: 12.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget ListTilewidget({image, txt, colorr, isFullWidth, isimageicon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: isFullWidth == null ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Image(
            color:
                isimageicon != null ? null : colorr ?? const Color(0xFF767680),
            height: 20,
            image: AssetImage(
              image ?? "images/person.png",
            ),
          ),
          isFullWidth == null
              ? UIHelper.horizontalSpaceMd
              : UIHelper.horizontalSpaceSm,
          CustomText(
            text: txt ?? "Male".tr,
            fontSize: 16.0.sp,
            weight: fontWeightMedium,
            color: Colors.black,
          )
        ],
      ),
    );
  }

  Widget headerWidget(UserFullModel? model) {
    return Column(
      children: [
        ShapeOfView(
          elevation: 3.0,
          shape: ArcShape(
              direction: ArcDirection.Outside,
              height: 30,
              position: ArcPosition.Bottom),
          child: Container(
            height: Get.height * 0.64,
            width: Get.width,
            color: secondaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UIHelper.verticalSpaceL,
                userProfilePhotoModel(
                    model!.data!.profile!.profileUrl, model.data!.username),
                UIHelper.verticalSpaceSm,
                GestureDetector(
                  onTap: () {
                    Get.to(() => const profileRating());
                  },
                  child: MyCustomRatingView(
                    starSize: 19.0,
                    ratinigValue: 3.2,
                    extratext: "by 2.1K",
                    fontcolor: whiteColor,
                    fontsize: 13.0,
                  ),
                ),
                UIHelper.verticalSpaceSm,
                NamewithlabelView(
                  displayName: model.data!.username != "null"
                      ? model.data!.username!
                      : model.data!.username!,
                  fontsize: 18.0.sp,
                  iconsize: 30.0,
                ),
                UIHelper.verticalSpaceSm,
                NicknameView(nickName: model.data!.getNickName ?? []),
                UIHelper.verticalSpaceSm,
                CallNumberView(
                  phoneNumber: model.data!.number,
                ),
                headerWithEdit(
                    label: "Profession".tr,
                    color: whiteColor,
                    ontap: () {
                      Get.bottomSheet(
                          EditProfessionDialog(
                            isAdd: true,
                            id: widget.id,
                          ),
                          isScrollControlled: true);
                    }),
                const Divider(
                  color: whiteColor,
                  thickness: 0.3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      professionBox(
                          byuser: "By User",
                          professiontext:
                              model.data!.profile!.profession ?? "-"),
                      professionBox(
                          byuser: "By Ali Usman", professiontext: "Model".tr),
                    ],
                  ),
                ),
                const Divider(
                  color: whiteColor,
                  thickness: 0.3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    followerBox(
                        quantity: model.data != null
                            ? model.data!.followersCount.toString()
                            : "0",
                        text: "Followers".tr),
                    Container(
                      width: 1,
                      height: 50.0,
                      color: lightGrey,
                    ),
                    followerBox(
                        quantity: model.data != null
                            ? model.data!.followingCount.toString()
                            : "0",
                        text: "Following".tr),
                  ],
                ),
                const Divider(
                  color: whiteColor,
                  thickness: 0.3,
                ),
                UIHelper.verticalSpaceMd,
                // UIHelper.verticalSpaceMd,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Expanded professionBox({
    required byuser,
    required professiontext,
  }) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: byuser,
          fontSize: 14.0,
          color: whiteColor,
          weight: fontWeightMedium,
        ),
        UIHelper.verticalSpaceSm,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 17,
              child: Image(
                alignment: Alignment.center,
                image: AssetImage(APPICONS.casespng),
              ),
            ),
            UIHelper.horizontalSpaceSm,
            CustomText(
              text: professiontext,
              fontSize: 12.0,
              color: lightGrey,
              weight: fontWeightRegular,
            ),
          ],
        )
      ],
    ));
  }

  Expanded followerBox({
    required quantity,
    required text,
  }) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: quantity,
          fontSize: 24.0,
          color: whiteColor,
          weight: fontWeightSemiBold,
        ),
        UIHelper.verticalSpaceSm1,
        CustomText(
          text: text,
          fontSize: 12.0,
          color: lightGrey,
          weight: fontWeightRegular,
        )
      ],
    ));
  }

  Widget headerWithEdit({required label, color, child, ontap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          fontSize: 18.0.sp,
          weight: fontWeightBold,
          color: color ?? Colors.black,
        ),
        child ??
            GestureDetector(
              onTap: ontap,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                color: primaryColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: GestureDetector(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit_outlined,
                          color: whiteColor,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        CustomText(
                          text: "Edit".tr,
                          fontSize: 15.0.sp,
                          weight: fontWeightMedium,
                          color: whiteColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ],
    );
  }

  Widget userProfilePhotoModel(url, name) {
    // Default to US if not recognized

    return url != "https://via.placeholder.com/150"
        ? ClipOval(
            child: CachedNetworkImage(
              imageUrl: url,
              width: Get.width * 0.23,
              height: Get.height * 0.11,
              fit: BoxFit.fill,
              errorWidget: (context, url, error) => CircleAvatar(
                radius: Get.height * 0.052,
                child: CustomText(
                  text: UIHelper.getShortName(string: name, limitTo: 2),
                  fontSize: 20.0,
                  color: Colors.black,
                  weight: fontWeightMedium,
                ),
              ),
            ),
          )
        : CircleAvatar(
            radius: Get.height * 0.052,
            child: CustomText(
              text: UIHelper.getShortName(string: name, limitTo: 2),
              fontSize: 20.0,
              color: Colors.black,
              weight: fontWeightMedium,
            ),
          );
  }
}
 */