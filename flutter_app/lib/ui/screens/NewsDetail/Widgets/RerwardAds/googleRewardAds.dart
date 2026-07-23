import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news/cubits/appSystemSettingCubit.dart';

const AdRequest request = AdRequest(
  keywords: <String>['news', 'video'],
  nonPersonalizedAds: true,
);

RewardedAd? rewardedAd;
int _numRewardedLoadAttempts = 0;
int maxFailedLoadAttempts = 3;

void createGoogleRewardedAd(BuildContext context) {
  if (context.read<AppConfigurationCubit>().rewardId() != "") {
    RewardedAd.load(
        adUnitId: context.read<AppConfigurationCubit>().rewardId()!,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              createGoogleRewardedAd(context);
            }
          },
        ));
  }
}

void showGoogleRewardedAd(BuildContext context, {Function? onRewardEarned}) {
  if (context.read<AppConfigurationCubit>().rewardId() != "") {
    if (rewardedAd == null) {
      debugPrint('Warning: attempt to show rewarded before loaded.');
      if (onRewardEarned != null) onRewardEarned();
      createGoogleRewardedAd(context);
      return;
    }
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => debugPrint('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createGoogleRewardedAd(context);
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createGoogleRewardedAd(context);
        if (onRewardEarned != null) onRewardEarned();
      },
    );
    rewardedAd!.setImmersiveMode(true);
    rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      debugPrint('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      if (onRewardEarned != null) onRewardEarned();
    });
    rewardedAd = null;
  } else {
    if (onRewardEarned != null) onRewardEarned();
  }
}
