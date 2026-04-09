import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infosha/views/widgets/Interstitial_screen.dart';
import 'package:infosha/views/widgets/rewarded_ads_widget.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';

class LoadAfterThreeVisit {
  int profileVisitCount = 0;
  DateTime? lastResetTime;

  loadAds(BuildContext context) async {
    if (Provider.of<UserViewModel>(context, listen: false).userModel.is_subscription_active == null ||
        Provider.of<UserViewModel>(context, listen: false).userModel.is_subscription_active == false) {
      _loadProfileVisitData();
      _incrementProfileVisit();
    }
  }

  Future<void> _loadProfileVisitData() async {
    final prefs = await SharedPreferences.getInstance();
    profileVisitCount = prefs.getInt('profileVisitCount') ?? 0;
    final lastReset = prefs.getString('lastResetTime');
    if (lastReset != null) {
      lastResetTime = DateTime.parse(lastReset);
      if (DateTime.now().difference(lastResetTime!).inHours >= 24) {
        profileVisitCount = 0;
        lastResetTime = DateTime.now();
        await prefs.setInt('profileVisitCount', profileVisitCount);
        await prefs.setString('lastResetTime', lastResetTime!.toIso8601String());
      }
    } else {
      lastResetTime = DateTime.now();
      await prefs.setString('lastResetTime', lastResetTime!.toIso8601String());
    }
  }

  Future<void> _incrementProfileVisit() async {
    final prefs = await SharedPreferences.getInstance();
    profileVisitCount++;
    await prefs.setInt('profileVisitCount', profileVisitCount);
    if (profileVisitCount > 3) {
      if (DateTime.now().difference(lastResetTime!).inHours < 24) {
        // Continuously show 30-second ad if 24 hours haven't passed
        RewardedScreen().loadAd(false); // Show rewarded ad (30 seconds)
      } else {
        // Reset if 24 hours have passed
        profileVisitCount = 0;
        lastResetTime = DateTime.now();
        await prefs.setInt('profileVisitCount', profileVisitCount);
        await prefs.setString('lastResetTime', lastResetTime!.toIso8601String());
      }
      /*  profileVisitCount = 0;
      lastResetTime = DateTime.now();
      await prefs.setInt('profileVisitCount', profileVisitCount);
      await prefs.setString('lastResetTime', lastResetTime!.toIso8601String());
      RewardedScreen().loadAd(false); */
    } else {
      InterstitialScreen().showAds();
    }
    log("profileVisitCount ===> $profileVisitCount");
  }
}
