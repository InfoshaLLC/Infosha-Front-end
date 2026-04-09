import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialScreen {
  late InterstitialAd interstitialAd;
  late RewardedAd rewardedAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;

  showAds() async {
    loadAd();
  }

  showRewardedAd() {
    final adUnitId = Platform.isAndroid ? 'ca-app-pub-8069875185667786/4019800084' : 'ca-app-pub-3940256099942544/1712485313';

    RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');

            rewardedAd = ad;
            rewardedAd.show(
              onUserEarnedReward: (ad, reward) {},
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  void loadAd() {
    final adUnitId = Platform.isAndroid ? 'ca-app-pub-8069875185667786/3962478819' : 'ca-app-pub-8069875185667786/3962478819';
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          interstitialAd = ad;
          interstitialAd.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
    /* final adUnitId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/5354046379'
        : 'ca-app-pub-3940256099942544/6978759866';

    RewardedInterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedInterstitialAd = ad;
            _rewardedInterstitialAd!.show(
              onUserEarnedReward: (ad, reward) {},
            );
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedInterstitialAd failed to load: $error');
          },
        )); */
  }
}
