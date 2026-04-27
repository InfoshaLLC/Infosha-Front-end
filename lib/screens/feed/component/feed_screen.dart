import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/screens/feed/component/feed_tile.dart';
import 'package:infosha/screens/feed/component/upload_feed.dart';
import 'package:infosha/screens/feed/controller/feed_model.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with AutomaticKeepAliveClientMixin {
  late FeedModel provider;
  int visibleTextIndex = -1;
  // int page = 1;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    provider = Provider.of<FeedModel>(context, listen: false);

    Future.microtask(() => context.read<FeedModel>().fetchPosts());

    scrollController.addListener(_fetchMorePost);

    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    scrollController.removeListener(_fetchMorePost);
    scrollController.dispose();
    super.dispose();
  }

  _fetchMorePost() {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    // Spec step 6: when the user nears the end of the currently-loaded data
    // (about ~1500px before the absolute bottom — roughly while they're
    // still reading the last visible page), silently fire the next page in
    // the background. The provider guards against concurrent calls and
    // bounds memory at one page ahead.
    final triggerOffset = position.maxScrollExtent - 1500;
    if (position.pixels >= triggerOffset &&
        provider.hasMore &&
        provider.isLoadingMorePost == false) {
      provider.prefetchNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // backgroundColor: const Color(0xFFE1EBEC),
      backgroundColor: Colors.white,
      /* appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // backgroundColor: const Color(0xFF0BA7C1),
        title: Text(
          "Feeds".tr,
          style: textStyleWorkSense(fontSize: 22),
        ),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => const UploadFeed());
                },
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "Upload".tr,
                    style: textStyleWorkSense(
                        fontSize: 14,
                        color: const Color(0xFF0BA7C1),
                        weight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(width: Get.width * 0.03)
            ],
          )
        ],
      ), */
      body: Consumer<FeedModel>(builder: (context, provider, child) {
        return provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: baseColor,
                ),
              )
            : Stack(
                children: [
                  /*  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      APPICONS.feedBackground,
                      height: Get.height * 0.4,
                      width: Get.width,
                      fit: BoxFit.fill,
                    ),
                  ), */
                  provider.feedListModel.data == null || provider.feedListModel.data!.data!.isEmpty
                      ? SizedBox(
                          width: Get.width,
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
                        )
                      : Builder(builder: (context) {
                          final items = provider.feedListModel.data!.data!;
                          // +1 for header (Upload button), +1 for footer (loader / end).
                          final itemCount = items.length + 2;
                          return ListView.builder(
                            controller: scrollController,
                            padding: EdgeInsets.zero,
                            physics: const AlwaysScrollableScrollPhysics(),
                            cacheExtent: 1200,
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => const UploadFeed());
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFF0BA7C1),
                                            borderRadius: BorderRadius.circular(8)),
                                        child: Text(
                                          "Upload".tr,
                                          style: textStyleWorkSense(
                                              fontSize: 14, color: Colors.white, weight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              final dataIndex = index - 1;
                              if (dataIndex < items.length) {
                                return FeedTile(
                                  index: dataIndex,
                                  isVisible: visibleTextIndex == dataIndex,
                                  onButtonTap: () {
                                    setState(() {
                                      visibleTextIndex =
                                          visibleTextIndex == dataIndex ? -1 : dataIndex;
                                    });
                                  },
                                );
                              }
                              // Footer
                              if (provider.isLoadingMorePost) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(color: baseColor),
                                  ),
                                );
                              }
                              return const SizedBox(height: 24);
                            },
                          );
                        })
                ],
              );
      }),
    );
  }
}
