// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:planeat/views/colors.dart';
// import 'package:planeat/views/text_styles.dart';

// class CustomViewPager extends StatefulWidget {
//   List<Widget>? listViews;
//   List<String>? listTags;
//   var initIndex;
//   CustomViewPager({Key? key, this.listTags, this.listViews, this.initIndex})
//       : super(key: key);

//   @override
//   _CustomViewPagerState createState() => _CustomViewPagerState();
// }

// class _CustomViewPagerState extends State<CustomViewPager>
//     with SingleTickerProviderStateMixin {
//   TabController? _tabController;

//   @override
//   void initState() {
//     _tabController = TabController(
//         length: widget.listTags!.length,
//         vsync: this,
//         initialIndex: widget.initIndex ?? 0);

//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _tabController!.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = screenSize(context);
//     return Padding(
//       padding: const EdgeInsets.all(0.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // give the tab bar a height [can change hheight to preferred height]

//           TabBar(
//             controller: _tabController,

//             // give the indicator a decoration (color and border radius)
//             // indicator: BoxDecoration(
//             //   boxShadow: [
//             //     BoxShadow(
//             //         color: Color.fromRGBO(0, 0, 0, 0.30000000149011612),
//             //         offset: Offset(0, 10),
//             //         blurRadius: 10)
//             //   ],
//             //   borderRadius: BorderRadius.circular(
//             //     25.0,
//             //   ),
//             //   color: Colors.red,
//             // ),
//             labelColor: blackbutton,
//             indicatorColor: primaryColor,

//             labelStyle:
//                 infoshaInter(fontSize: 14.0, weight: fontWeightSemiBold),
//             unselectedLabelColor: Colors.grey,
//             unselectedLabelStyle:
//                 infoshaInter(fontSize: 14.0, weight: fontWeightSemiBold),

//             tabs: [
//               // first tab [you can add an icon using the icon property]
//               for (var tag in widget.listTags!)
//                 Tab(
//                   text: tag,
//                 ),

//               // second tab [you can add an icon using the icon property]
//             ],
//           ),
        
//          // tab bar view here
//           Expanded(
//             // height: Get.height,
//             child: TabBarView(
//               //    physics: NeverScrollableScrollPhysics(),

//               controller: _tabController,
//               children: widget.listViews!,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
