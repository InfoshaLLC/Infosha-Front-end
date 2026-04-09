import 'dart:io';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedScreen {
  RewardedAd? _rewardedAd;

  final adUnitId = Platform.isAndroid ? 'ca-app-pub-8069875185667786/4019800084' : 'ca-app-pub-8069875185667786/4019800084';

  /// Loads a rewarded ad.
  void loadAd(bool isClose) {
    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedAd!.show(
            onUserEarnedReward: (ad, reward) {
              if (isClose) {
                Get.close(1);
              }
            },
          );
          ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {},
              onAdImpression: (ad) {},
              onAdFailedToShowFullScreenContent: (ad, err) {
                ad.dispose();
              },
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              onAdClicked: (ad) {});

          print('$ad loaded.');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
        },
      ),
    );
  }
}
