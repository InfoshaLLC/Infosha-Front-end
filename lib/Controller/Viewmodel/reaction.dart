import 'package:flutter/material.dart';
import 'package:flutter_feed_reaction/flutter_feed_reaction.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class EmojiReactions {
  static List<FeedReaction> reactions = [
    FeedReaction(
      id: 0,
      header: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.6),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 3.0,
          vertical: 2.0,
        ),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: const Text(
          "like",
          style: TextStyle(fontSize: 8.0, color: Colors.white),
        ),
      ),
      reaction: Container(
        width: Get.width * 0.12,
        height: 40.0,
        padding: const EdgeInsets.only(top: 3),
        child: const Text('👍', style: TextStyle(fontSize: 25)),
      ),
    ),
    FeedReaction(
      id: 1,
      header: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.6),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 3.0,
          vertical: 2.0,
        ),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: const Text(
          "dislike",
          style: TextStyle(fontSize: 8.0, color: Colors.white),
        ),
      ),
      reaction: SizedBox(
        width: Get.width * 0.12,
        height: 40.0,
        child: const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text('👎', style: TextStyle(fontSize: 25)),
        ),
      ),
    ),
    FeedReaction(
      id: 2,
      header: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.6),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 3.0,
          vertical: 2.0,
        ),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: const Text(
          "love",
          style: TextStyle(fontSize: 8.0, color: Colors.white),
        ),
      ),
      reaction: Lottie.asset(
        'assets/lottie/heart.json',
        width: Get.width * 0.12,
        height: 40.0,
      ),
    ),
    FeedReaction(
      id: 3,
      header: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.6),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 3.0,
          vertical: 2.0,
        ),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: const Text(
          "haha",
          style: TextStyle(fontSize: 8.0, color: Colors.white),
        ),
      ),
      reaction: Container(
        width: Get.width * 0.12,
        height: 40.0,
        padding: const EdgeInsets.only(top: 3),
        child: const Text('😂', style: TextStyle(fontSize: 25)),
      ),
    ),
    FeedReaction(
      id: 4,
      header: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.6),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 3.0,
          vertical: 2.0,
        ),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: const Text(
          "wow",
          style: TextStyle(fontSize: 8.0, color: Colors.white),
        ),
      ),
      reaction: Lottie.asset(
        'assets/lottie/wow.json',
        width: Get.width * 0.12,
        height: 40.0,
      ),
    ),
    FeedReaction(
      id: 5,
      header: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.6),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 3.0,
          vertical: 2.0,
        ),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: const Text(
          "angry",
          style: TextStyle(fontSize: 8.0, color: Colors.white),
        ),
      ),
      reaction: Lottie.asset(
        'assets/lottie/angry.json',
        width: Get.width * 0.12,
        height: 40.0,
      ),
    ),
    FeedReaction(
      id: 6,
      header: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.6),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 3.0,
          vertical: 2.0,
        ),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: const Text(
          "cry",
          style: TextStyle(fontSize: 8.0, color: Colors.white),
        ),
      ),
      reaction: Lottie.asset(
        'assets/lottie/sad.json',
        width: Get.width * 0.12,
        height: 40.0,
      ),
    ),
    FeedReaction(
      id: 7,
      header: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.6),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 3.0,
          vertical: 2.0,
        ),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: const Text(
          "facepalm",
          style: TextStyle(fontSize: 8.0, color: Colors.white),
        ),
      ),
      reaction: SizedBox(
        width: Get.width * 0.12,
        height: 40.0,
        child: const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text('🤦‍♂️', style: TextStyle(fontSize: 25)),
        ),
      ),
    ),
  ];

  static List<FeedReaction> reactions1 = [
    FeedReaction(
      id: 0,
      header: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.6),
        ),
        padding: const EdgeInsets.only(
          left: 3.0,
          right: 3.0,
          top: 2.0,
          bottom: 2.0,
        ),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: const Text(
          "Love",
          style: TextStyle(fontSize: 8.0, color: Colors.white),
        ),
      ),
      reaction: Lottie.asset(
        'assets/lottie/heart.json',
        width: 40.0,
        height: 40.0,
      ),
    ),
    FeedReaction(
      id: 1,
      header: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.6),
        ),
        padding: const EdgeInsets.only(
          left: 3.0,
          right: 3.0,
          top: 2.0,
          bottom: 2.0,
        ),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: const Text(
          "Wow",
          style: TextStyle(fontSize: 8.0, color: Colors.white),
        ),
      ),
      reaction: Lottie.asset(
        'assets/lottie/wow.json',
        width: 40.0,
        height: 40.0,
      ),
    ),
    FeedReaction(
      id: 2,
      header: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.6),
        ),
        padding: const EdgeInsets.only(
          left: 3.0,
          right: 3.0,
          top: 2.0,
          bottom: 2.0,
        ),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: const Text(
          "Lol",
          style: TextStyle(fontSize: 8.0, color: Colors.white),
        ),
      ),
      reaction: Lottie.asset(
        'assets/lottie/lol.json',
        width: 40.0,
        height: 40.0,
      ),
    ),
    FeedReaction(
      id: 3,
      header: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.6),
        ),
        padding: const EdgeInsets.only(
          left: 3.0,
          right: 3.0,
          top: 2.0,
          bottom: 2.0,
        ),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: const Text(
          "Sad",
          style: TextStyle(fontSize: 8.0, color: Colors.white),
        ),
      ),
      reaction: Lottie.asset(
        'assets/lottie/sad.json',
        width: 40.0,
        height: 40.0,
      ),
    ),
    FeedReaction(
      id: 4,
      header: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.6),
        ),
        padding: const EdgeInsets.only(
          left: 3.0,
          right: 3.0,
          top: 2.0,
          bottom: 2.0,
        ),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: const Text(
          "Angry",
          style: TextStyle(fontSize: 8.0, color: Colors.white),
        ),
      ),
      reaction: Lottie.asset(
        'assets/lottie/angry.json',
        width: 40.0,
        height: 40.0,
      ),
    ),
  ];
}
