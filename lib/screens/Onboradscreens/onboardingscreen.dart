// import 'package:flutter/material.dart';
// import 'package:infosha/views/text_styles.dart';

// class OnBoardingScreen extends StatelessWidget {
//   OnBoardingScreen({super.key});

//   final _controller = PageController();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       child: Scaffold(
//           body: PageView.builder(
//         physics: BouncingScrollPhysics(),
//         scrollDirection: Axis.horizontal,
//         controller: _controller,
//         itemCount: 3,
//         itemBuilder: (context, index) {
//           return Column(
//             children: [
//               Stack(
//                 children: [
//                   Container(
//                     height: MediaQuery.of(context).size.height,
//                     // height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         filterQuality: FilterQuality.high,
//                         image: AssetImage("images/onboarding1.png"),
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(top: 40, right: 20),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 "Skip",
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: fontWeightBold,
//                                     color: Color(0xFF1B2870)),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(top: 35, left: 25),
//                           child: Row(
//                             children: [
//                               Text(
//                                 "Ride The Social Wave",
//                                 style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: fontWeightBold,
//                                     color: Color(0xFF46464F)),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(top: 20, left: 25),
//                           child: Row(
//                             children: [
//                               Text(
//                                 "Welcome to Infosha, where social\npossibilities are endless. Ride the wave\nof connection.",
//                                 style: TextStyle(
//                                     fontSize: 17, color: Color(0xFF767680)),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 30,
//                     left: 10,
//                     right: 10,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.circle,
//                               size: 15,
//                               color: Colors.grey,
//                             ),
//                             Icon(
//                               Icons.circle,
//                               size: 15,
//                               color: Colors.grey,
//                             ),
//                             Icon(
//                               Icons.circle,
//                               size: 15,
//                               color: Colors.grey,
//                             ),
//                           ],
//                         ),
//                         Container(
//                           height: 35,
//                           width: 90,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(50)),
//                             color: Color(0xFF1B2870),
//                           ),
//                           child: Center(
//                               child: Text("Next",
//                                   style: TextStyle(
//                                       fontSize: 18, color: Colors.white))),
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           );
//         },
//       )),
//     );
//   }
// }
