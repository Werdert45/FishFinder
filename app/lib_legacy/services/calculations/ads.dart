import 'package:firebase_admob/firebase_admob.dart';

BannerAd createBannerAd(bannerAd, targetingInfo) {
  return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.fullBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd $event");
      }
  );
}