import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/logo_view.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:infosha/screens/home/home_screen.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/subscription/controller/subscription_model.dart';
import 'package:infosha/screens/subscription/component/subscription_list_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  bool isNewUser;
  SubscriptionScreen({super.key, required this.isNewUser});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late SubscriptionModel provider;

  @override
  void initState() {
    provider = Provider.of<SubscriptionModel>(context, listen: false);
    Future.microtask(() => context.read<SubscriptionModel>().getSubscriptionData());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: Consumer<SubscriptionModel>(builder: (context, provider, child) {
        return provider.isLoading
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      () {
                        if (widget.isNewUser) {
                          Get.offAll(() => const HomeScreen(
                                fromLogin: true,
                              ));
                        } else {
                          Get.back();
                        }
                      },
                      text: "Back".tr,
                      textcolor: whiteColor,
                      color: primaryColor,
                    )
                  ],
                ),
              );
      }),
      body: Consumer<SubscriptionModel>(builder: (context, provider, child) {
        return provider.isLoading
            ? const Center(child: CircularProgressIndicator(color: baseColor))
            : NestedScrollView(
                headerSliverBuilder: (context, bool innerBoxIsScrolle) {
                  return [
                    SliverAppBar(
                        expandedHeight: 200,
                        floating: false,
                        leading: Container(),
                        surfaceTintColor: const Color(0xff07C6E5),
                        backgroundColor: Colors.white,
                        automaticallyImplyLeading: true,
                        pinned: false,
                        flexibleSpace: const FlexibleSpaceBar(
                          background: Image(
                            image: AssetImage('images/infosha.png'),
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ))
                  ];
                },
                body: Consumer<UserViewModel>(
                  builder: (context, provider, child) {
                    return body(context);
                  },
                ),
              );
      }),
    );
  }

  body(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 20),
                  child: Text(
                    "Welcome to Infosha".tr,
                    style: const TextStyle(fontSize: 22, fontWeight: fontWeightBold),
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: Text(
            "You are now a Standard User. To unlock all features subscribe status.".tr,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      child: Column(
                        children: [
                          /* Subscriptionwidget(
                              context,
                              "\$7.99",
                              "\$19.99",
                              "\$47.99",
                              "Lord Status",
                              APPICONS.lordstutspng,
                              "images/lordstuts.png",
                              const Color(0xFF30CCCA),
                              [
                                "Able to see contact list of others",
                                "Able to delete 1 comment",
                                "Able to block 1 user",
                                "Able to get 10 search results",
                              ],
                              widget.isNewUser), */
                          Subscriptionwidget(
                              context,
                              "\$ 1.99",
                              "\$ 4.99",
                              "\$ 11.99",
                              "King Status",
                              APPICONS.kingstutspicpng,
                              "images/kingstuts.png",
                              const Color(0xFFB42F69),
                              [
                                "able to delete unlimited comments",
                                "able to get notification momentarily when somebody visits their profile",
                                "able to see which user entered what kind of information on any profile",
                                "able to see which user enters his phone number using what nickname",
                                "able to write an anonymous comment on anyone's profile",
                                "no ads",
                                "able to see review makers",
                                "able to block unlimited users",
                                "unlimited search results"
                              ],
                              widget.isNewUser),
                          Subscriptionwidget(
                              context,
                              "\$ 9.99",
                              "\$ 24.99",
                              "\$ 59.99",
                              "God Status",
                              APPICONS.godstatuspng,
                              "images/godstuts.png",
                              const Color(0xFFF4851F),
                              [
                                "able to see followers of any user",
                                "able to see who does any user follow",
                                "able to get notification momentarily when somebody visits their profile",
                                "able to see which user entered what kind of information on any profile",
                                "Who deleted a comment on thier profile",
                                "Who visited your profile and which user visits which user's profile",
                                "able to write an anonymous comment on anyone's profile",
                                "no ads",
                                "able to see the list of other King and Gods users",
                                "able to block unlimited users",
                                "able to delete unlimited comments",
                                "Unlimited search results",
                                "able to see anonymous comment poster",
                                "able to see other users' activity, like writing a comment on someone's profile, rating them out of 5 stars or them filling in any information on other or their profile"
                              ],
                              widget.isNewUser),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget Subscriptionwidget(BuildContext context, String price1, String price2, String price3, String title, String titleImage, String image,
    Color backColor, List<String> features, bool isNewUser) {
  return GestureDetector(
    onTap: () {
      Get.to(() => SubscriptionListScreen(plan: title, isNewUser: isNewUser));
    },
    child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: Get.height * 0.11,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            image,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: Get.height * 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: Get.height * 0.045,
                                width: Get.width * 0.08,
                                child: Image(
                                  alignment: Alignment.topCenter,
                                  image: AssetImage(
                                    titleImage,
                                  ),
                                ),
                              ),
                              SizedBox(width: Get.width * 0.02),
                              Text(
                                title.tr,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: fontWeightBold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.black,
                                      offset: Offset(2.0, 3.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: Get.width,
              alignment: Alignment.center,
              transform: Matrix4.translationValues(0, -25, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: Get.height * 0.065,
                    width: Get.width * 0.25,
                    decoration: BoxDecoration(color: backColor, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          price1,
                          style: TextStyle(
                            fontSize: Get.width * 0.048,
                            color: Colors.white,
                            fontWeight: fontWeightBold,
                          ),
                        ),
                        Text(
                          "monthly".tr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Container(
                    height: Get.height * 0.065,
                    width: Get.width * 0.25,
                    decoration: BoxDecoration(color: backColor, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          price2,
                          style: TextStyle(
                            fontSize: Get.width * 0.048,
                            color: Colors.white,
                            fontWeight: fontWeightBold,
                          ),
                        ),
                        Text(
                          "quarterly".tr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Container(
                    height: Get.height * 0.065,
                    width: Get.width * 0.25,
                    decoration: BoxDecoration(color: backColor, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          price3,
                          style: TextStyle(
                            fontSize: Get.width * 0.048,
                            color: Colors.white,
                            fontWeight: fontWeightBold,
                          ),
                        ),
                        Text(
                          "yearly".tr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (title == "God Status") ...[Image.asset("assets/emojies/godSub.jpg")],
            if (title == "King Status") ...[Image.asset("assets/emojies/kingSub.jpg")],
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                () {
                  Get.to(() => SubscriptionListScreen(plan: title, isNewUser: isNewUser));
                },
                text: "Continue".tr,
                textcolor: whiteColor,
                color: primaryColor,
              ),
            ),
            UIHelper.verticalSpaceMd
          ],
        ),
      ],
    ),
  );
}

/* Widget Subscriptionwidget(
    BuildContext context,
    String price1,
    String price2,
    String price3,
    String title,
    String titleImage,
    String image,
    Color backColor,
    List<String> features,
    bool isNewUser) {
  return GestureDetector(
    onTap: () {
      Get.to(() => SubscriptionListScreen(plan: title, isNewUser: isNewUser));
    },
    child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: Get.height * 0.11,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            image,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: Get.height * 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: Get.height * 0.045,
                                width: Get.width * 0.08,
                                child: Image(
                                  alignment: Alignment.topCenter,
                                  image: AssetImage(
                                    titleImage,
                                  ),
                                ),
                              ),
                              SizedBox(width: Get.width * 0.02),
                              Text(
                                title.tr,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: fontWeightBold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.black,
                                      offset: Offset(2.0, 3.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: Get.width,
              alignment: Alignment.center,
              transform: Matrix4.translationValues(0, -25, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: Get.height * 0.065,
                    width: Get.width * 0.25,
                    decoration: BoxDecoration(
                        color: backColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          price1,
                          style: TextStyle(
                            fontSize: Get.width * 0.048,
                            color: Colors.white,
                            fontWeight: fontWeightBold,
                          ),
                        ),
                        Text(
                          "monthly".tr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Container(
                    height: Get.height * 0.065,
                    width: Get.width * 0.25,
                    decoration: BoxDecoration(
                        color: backColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          price2,
                          style: TextStyle(
                            fontSize: Get.width * 0.048,
                            color: Colors.white,
                            fontWeight: fontWeightBold,
                          ),
                        ),
                        Text(
                          "quarterly".tr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Container(
                    height: Get.height * 0.065,
                    width: Get.width * 0.25,
                    decoration: BoxDecoration(
                        color: backColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          price3,
                          style: TextStyle(
                            fontSize: Get.width * 0.048,
                            color: Colors.white,
                            fontWeight: fontWeightBold,
                          ),
                        ),
                        Text(
                          "yearly".tr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Theme(
              data: ThemeData().copyWith(
                dividerColor: Colors.transparent,
                listTileTheme: ListTileTheme.of(context).copyWith(
                  dense: true,
                  minVerticalPadding: 0,
                ),
              ),
              child: ExpansionTile(
                backgroundColor: Colors.white,
                collapsedBackgroundColor: Colors.white,
                initiallyExpanded: false,
                title: const Center(
                  child: Image(
                    width: 20,
                    image: AssetImage('images/downarrow.png'),
                  ),
                ),
                trailing: const SizedBox.shrink(),
                tilePadding: const EdgeInsets.only(left: 20, top: 0),
                children: [
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: features.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        horizontalTitleGap: 0,
                        visualDensity: const VisualDensity(vertical: -3),
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check,
                              color: backColor,
                            ),
                          ],
                        ),
                        title: Text(features[index].tr,
                            style: TextStyle(
                                fontFamily: GoogleFonts.workSans().fontFamily,
                                fontSize: 14,
                                color: Colors.black)),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomButton(
                      () {
                        Get.to(() => SubscriptionListScreen(
                            plan: title, isNewUser: isNewUser));
                      },
                      text: "Continue".tr,
                      textcolor: whiteColor,
                      color: primaryColor,
                    ),
                  )
                ],
              ),
            ),
            UIHelper.verticalSpaceMd
          ],
        ),
      ],
    ),
  );
} */
