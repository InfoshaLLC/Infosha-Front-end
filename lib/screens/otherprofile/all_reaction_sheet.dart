import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/ProfileScreen/profilerating.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AllReactionSheet extends StatefulWidget {
  @override
  State<AllReactionSheet> createState() => _AllReactionSheetState();
}

class _AllReactionSheetState extends State<AllReactionSheet>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 5);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(builder: (context, provider, child) {
      return SlidingUpPanel(
        minHeight: Get.height * 0.4,
        maxHeight: Get.height * 0.9,
        isDraggable: true,
        onPanelClosed: () {},
        margin: EdgeInsets.all(0),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35), topRight: Radius.circular(35)),
        panel: DefaultTabController(
          length: 5, // The number of tabs
          child: Container(
            decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35))),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image(
                      width: 35,
                      image: AssetImage('images/linee.png'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: 'List of people who reacted',
                        isHeading: true,
                        fontSize: 18.0,
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(Icons.close))
                    ],
                  ),
                  //UIHelper.verticalSpaceSm,
                  TabBar(
                    //  dividerColor: Color(0xFF1B2870),
                    controller: _controller,
                    indicatorSize: TabBarIndicatorSize.label,

                    indicatorColor: Color(0xFF1B2870),
                    labelPadding: EdgeInsets.all(5),
                    //indicatorPadding: EdgeInsets.only(top: 15),
                    indicatorPadding: EdgeInsets.only(top: 15),
                    padding: EdgeInsets.only(top: 10),
                    indicatorWeight: 2.5,
                    labelColor: primaryColor,
                    labelStyle: textStyleWorkSense(
                        fontSize: 13.0, weight: fontWeightSemiBold),

                    unselectedLabelColor: Colors.black,
                    unselectedLabelStyle: textStyleWorkSense(
                        fontSize: 13.0,
                        color: Colors.black,
                        weight: fontWeightMedium),
                    onTap: (insex) {
                      setState(() {
                        _controller!.index = insex;
                      });
                      setState;
                    },
                    tabs: [
                      tabReaction(provider, 0, "4"),
                      tabReaction(provider, 1, "1"),
                      tabReaction(provider, 2, "2"),
                      tabReaction(provider, 3, "3"),
                      tabReaction(provider, 4, "4"),
                      //
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        reactionList(provider.convertReactionIdToPath(0), 4),
                        reactionList(provider.convertReactionIdToPath(1), 1),
                        reactionList(provider.convertReactionIdToPath(2), 2),
                        reactionList(provider.convertReactionIdToPath(3), 3),
                        reactionList(provider.convertReactionIdToPath(4), 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget reactionList(imagepath, length) {
    // return Expanded(
    //   child: SliverList(
    //       delegate: SliverChildBuilderDelegate(
    //           (context, index) => Container(
    //                 color: Colors.red,
    //                 alignment: Alignment.centerLeft,
    //                 padding: EdgeInsets.symmetric(vertical: 10),
    //                 child: Text("$index"),
    //               ),
    //           childCount: 100)),
    // );
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                radius: 20,
                child: Image(
                  image: AssetImage('images/aysha.png'),
                ),
              ),
              title: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "3 min ago",
                        style:
                            TextStyle(color: Color(0xFFABAAB4), fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            Text(
                              "Aleena Shah",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 15,
                              child: Image(
                                image: AssetImage('images/vector.png'),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.verified,
                              size: 15,
                              color: Color(0xFF007EFF),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        imagepath,
                        width: 20,
                      )
                    ],
                  ),
                ],
              ),
              subtitle: Text(
                "+92 334 1234567",
                style: TextStyle(color: Color(0xFF767680), fontSize: 14),
              ),
            );
          }),
    );
  }

  Column tabReaction(UserViewModel provider, reaction, counts) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(
          width: 40,
          image: AssetImage(provider.convertReactionIdToPath(reaction)),
        ),
        CustomText(
            text: counts,
            fontSize: 14.0,
            weight: fontWeightExtraBold,
            color: _controller!.index == reaction ? primaryColor : Colors.grey)
      ],
    );
  }
}
