import 'package:get/get.dart';
import 'package:infosha/main.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/utils/utils.dart';
import 'package:infosha/config/const.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/screens/hscreen/settings.dart';
import 'package:infosha/views/widgets/dot_loader.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:infosha/searchscreens/searchscreen.dart';
import 'package:infosha/followerscreen/topfollowers.dart';
import 'package:infosha/views/widgets/nickname_view.dart';
import 'package:infosha/screens/hscreen/contact_list.dart';
import 'package:infosha/views/widgets/setting_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:infosha/views/widgets/call_number_view.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:infosha/screens/feed/component/feed_tile.dart';
import 'package:infosha/screens/feed/component/view_feed.dart';
import 'package:infosha/views/widgets/namewithlabel_view.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/feed/component/upload_feed.dart';
import 'package:infosha/screens/feed/controller/feed_model.dart';
import 'package:infosha/screens/ProfileScreen/profilescreen.dart';
import 'package:country_state_city/country_state_city.dart' as con;
import 'package:infosha/screens/ProfileScreen/visitor_screen.dart';
import 'package:infosha/Controller/models/profile_rating_model.dart';
import 'package:infosha/screens/otherprofile/add_review_dialog.dart';
import 'package:infosha/screens/otherprofile/show_review_dialog.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';
import 'package:infosha/followerscreen/controller/topfollowers_model.dart';

class HomeScreen extends StatefulWidget {
  final bool fromLogin;
  const HomeScreen({super.key, this.fromLogin = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool isLoadingMorePost = false;
  DateTime? lastBackPressedTime;
  // int page = 1;
  late UserViewModel provider;
  late FeedModel providerFeed;
  ScrollController scrollController = ScrollController();
  int visibleTextIndex = -1;

  @override
  void initState() {
    super.initState(); // Always call super.initState() first
    WidgetsBinding.instance.addObserver(this);
    provider = Provider.of<UserViewModel>(context, listen: false);
    providerFeed = Provider.of<FeedModel>(context, listen: false);
    Future.microtask(() => context.read<FeedModel>().fetchPosts());
    if (!widget.fromLogin) {
      Future.microtask(() async {
        await provider.fetchDeviceContacts();
      });
    } else {
      print("Coming From Log In");
    }

    Future.microtask(() => context.read<TopFollowVisitorModel>().fetchCountry());

    Future.microtask(() => context.read<TopFollowVisitorModel>().selectedCountry = con.Country(
        name: "Country",
        isoCode: "isoCode",
        phoneCode: "phoneCode",
        flag: "flag",
        currency: "currency",
        latitude: "latitude",
        longitude: "longitude"));

    Future.microtask(() => context
        .read<TopFollowVisitorModel>()
        .fetchTopFollowers()
        .then((value) => Future.microtask(() => context.read<TopFollowVisitorModel>().fetchTopVisitors())));

    if (initialDynamic != "null") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ViewFeed(postUrl: initialDynamic)));
      });
    }

    initialmessage(); // Call after providers are initialized and context is fully valid
    // getProfileData();

    scrollController.addListener(_scrollListener);
  }

  Future<void> deeplinkemthod() async {
    debugPrint("initialDynamic ==> $initialDynamic");
    if (initialDynamic != "null") {
      try {
        if (initialDynamic.contains("feed")) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ViewFeed(postUrl: initialDynamic)));
          });
        } else {}
      } catch (e) {
        rethrow;
      }
    }
  }

  /// used to get logged user's data
  getProfileData() async {
    provider.userModel = await provider.getUserProfileById(Params.UserToken);
    provider.getProfessionByOtherUser(provider.userModel.id.toString(), true);
  }

  initialmessage() async {
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null && message.data["user_id"] != "" && message.data["user_id"] != null) {
      Future.microtask(() =>
          context.read<UserViewModel>().loadSharedPref().then((value) => Get.to(() => VisitorScreen(id: Params.Id))));
    }
  }

  /// used to fetch more data if pagination added
  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100 && !isLoadingMorePost) {
      setState(() {
        isLoadingMorePost = true;
      });
      providerFeed.page += 1;
      providerFeed.fetchMorePosts(providerFeed.page).whenComplete(() {
        if (mounted) {
          setState(() => isLoadingMorePost = false);
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    providerFeed.clearFeedData();
    // page = 1;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      debugPrint("App resumed → Checking contacts…");
      bool changed = await provider.hasDeviceContactsChanged();
      if (changed) {
        debugPrint("Contacts changed → Calling API…");
        await provider.fetchDeviceContacts();
      } else {
        debugPrint("Contacts unchanged → No API call.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('home_screen_visibility_detector'),
      onVisibilityChanged: (visibilityInfo) {
        final isVisible = visibilityInfo.visibleFraction > 0;
        if (providerFeed.isHomeScreenVisible != isVisible) {
          providerFeed.isHomeScreenVisible = isVisible;
          debugPrint("HomeScreen visibility updated: $isVisible");
        }
        // if (isVisible) {
        //   providerFeed.fetchPosts();
        // } else {
        //   providerFeed.page = 1;
        // }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<UserViewModel>(
          builder: (context, provider, child) {
            return Obx(
              () => provider.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: baseColor,
                      ),
                    )
                  : RefreshIndicator(
                      color: baseColor,
                      edgeOffset: Get.height * 0.55,
                      onRefresh: () async {
                        debugPrint("🔄 Feed refreshed");
                        await Provider.of<FeedModel>(context, listen: false).fetchPosts(isEvent: true);
                        providerFeed.page = 1;
                      },
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverAppBar(
                            backgroundColor: Colors.white,
                            expandedHeight: Get.height * 0.41,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: ShapeOfView(
                                      elevation: 3.0,
                                      shape: ArcShape(
                                          direction: ArcDirection.Outside, height: 30, position: ArcPosition.Bottom),
                                      child: Container(
                                        height: Get.height * 0.42,
                                        width: Get.width,
                                        color: secondaryColor,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            UIHelper.verticalSpaceSm,
                                            if (provider.userModel.profile != null)
                                              userProfilePhotoModel(
                                                  provider.userModel.profile!.profileUrl, provider.userModel.username),
                                            UIHelper.verticalSpaceSm,
                                            NamewithlabelView(
                                              displayName: provider.userModel.username!,
                                              fontsize: 18.0.sp,
                                              iconsize: 22.0,
                                              iconname: provider.userModel.is_subscription_active == true
                                                  ? provider.userModel.active_subscription_plan_name
                                                  : null,
                                              showIcon: provider.userModel.is_subscription_active,
                                            ),
                                            UIHelper.verticalSpaceSm,
                                            NicknameView(nickName: provider.userModel.getNickName ?? []),
                                            UIHelper.verticalSpaceSm,
                                            CallNumberView(
                                              userID: provider.userModel.id.toString(),
                                              name: provider.userModel.username,
                                              phoneNumber:
                                                  "${provider.userModel.counryCode ?? "+995"} ${provider.userModel.number}",
                                              callBack: () async {
                                                ProfileRatingModel profile =
                                                    await Utils.getUserRating(provider.userModel.id.toString());
                                                if (profile.data != null && profile.data!.isNotEmpty) {
                                                  if (profile.data!.first.isShowRating == 0) {
                                                    Get.dialog(ShowReviewDialog(
                                                      id: "${provider.userModel.counryCode ?? "+995"} ${provider.userModel.number}",
                                                      userID: provider.userModel.id.toString(),
                                                      profile: profile,
                                                    ));
                                                  }
                                                } else {
                                                  Get.dialog(AddReviewDialog(
                                                    id: "${provider.userModel.counryCode ?? "+995"} ${provider.userModel.number}",
                                                    userID: provider.userModel.id.toString(),
                                                  )).then((value) async {
                                                    var temp = await provider.viewProfile(provider.userModel.id);
                                                    setState(() {
                                                      provider.userModel.averageRating =
                                                          (temp.data != null && temp.data!.averageRating != null)
                                                              ? double.parse(temp.data!.averageRating.toString())
                                                              : 0.0;
                                                    });
                                                  });
                                                }
                                              },
                                            ),
                                            /* Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.call_outlined,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                provider.userModel.number!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ), */
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SettingIconWidget(
                                            imagesvgpath: APPICONS.followprofilesvg,
                                            ontap: () {
                                              Get.to(() => TopFollowersScreen());
                                            }),
                                        UIHelper.horizontalSpaceSm,
                                        SettingIconWidget(
                                            imagesvgpath: APPICONS.profilesvg,
                                            ontap: () {
                                              if (provider.userModel.visitsCount == null) {
                                                getProfileData();
                                              }
                                              Get.to(() => const ProfileScreen());
                                            }),
                                        UIHelper.horizontalSpaceSm,
                                        SettingIconWidget(
                                            imagesvgpath: APPICONS.searchsvg,
                                            ontap: () {
                                              Get.to(() => const SearchScreen());
                                            }),
                                        UIHelper.horizontalSpaceSm,
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => VisitorScreen(id: Params.Id));
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                                            child: Image.asset(
                                              "images/visitor.png",
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        UIHelper.horizontalSpaceSm,
                                        SettingIconWidget(
                                            imagesvgpath: APPICONS.settingsvg,
                                            ontap: () {
                                              Get.to(() => const SettingScreen());
                                            }),
                                        UIHelper.horizontalSpaceSm,
                                        InkWell(
                                          onTap: () {
                                            Get.to(() => const ContactList());
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                                            child: Image.asset(
                                              APPICONS.socialMedia,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const UploadFeed());
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF0BA7C1), borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      "Upload".tr,
                                      style: textStyleWorkSense(
                                          fontSize: 14, color: Colors.white, weight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Consumer<FeedModel>(
                            builder: (context, feedProvider, child) {
                              // if (feedProvider.isLoading) {
                              //   return const SliverFillRemaining(
                              //     child: Center(
                              //       child: CircularProgressIndicator(
                              //         color: baseColor,
                              //       ),
                              //     ),
                              //   );
                              // }

                              if (feedProvider.isLoading) {
                                return SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return feedTileSkeleton();
                                    },
                                    childCount: 10,
                                  ),
                                );
                              }

                              if (feedProvider.feedListModel.data == null ||
                                  feedProvider.feedListModel.data!.data!.isEmpty) {
                                return SliverFillRemaining(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.not_interested,
                                        color: Colors.black,
                                        size: Get.width * 0.15,
                                      ),
                                      SizedBox(height: Get.height * 0.02),
                                      Text(
                                        'No Feed Found'.tr,
                                        style: GoogleFonts.workSans(
                                          color: Colors.black,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (index < feedProvider.feedListModel.data!.data!.length) {
                                      return FeedTile(
                                        index: index,
                                        isVisible: visibleTextIndex == index,
                                        onButtonTap: () {
                                          setState(() {
                                            visibleTextIndex = visibleTextIndex == index ? -1 : index;
                                          });
                                        },
                                      );
                                    }
                                    // else if (isLoadingMorePost) {
                                    //   return const Center(
                                    //     child: Padding(
                                    //       padding: EdgeInsets.all(16.0),
                                    //       child: CircularProgressIndicator(color: baseColor),
                                    //     ),
                                    //   );
                                    // }
                                    else if (isLoadingMorePost) {
                                      return const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 24),
                                        child: Center(
                                          child: DancingDotsLoader(),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                  childCount: feedProvider.feedListModel.data!.data!.length + 1,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}

Widget feedTileSkeleton() {
  return Container(
    margin: const EdgeInsets.all(10.0),
    width: Get.width,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: ClipOval(
                  child: Container(
                    height: Get.height * 0.06,
                    width: Get.height * 0.06,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: Get.width * 0.4,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: Get.width * 0.25,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(height: 5, thickness: 2),
          ),

          /// ---------- MEDIA ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          /// ---------- TEXT ----------
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: double.infinity, color: Colors.grey.shade400),
                const SizedBox(height: 6),
                Container(height: 14, width: double.infinity, color: Colors.grey.shade400),
                const SizedBox(height: 6),
                Container(height: 14, width: Get.width * 0.6, color: Colors.grey.shade400),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(height: 5, thickness: 2),
          ),

          /// ---------- VOTE ----------
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(height: 20, width: 60, color: Colors.grey.shade400),
                const SizedBox(width: 20),
                Container(height: 20, width: 60, color: Colors.grey.shade400),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
