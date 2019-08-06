import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:ads/ads.dart';
import 'package:flutter/widgets.dart';

class AppAds {
  static Ads _ads;

  static final String _appId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544~3347511713'
      : 'ca-app-pub-3940256099942544~1458002511';

  static final String _bannerUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  /// Assign a listener.
  static MobileAdListener _eventListener = (MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        print("An ad has loaded successfully in memory.");
        break;
      case MobileAdEvent.failedToLoad:
        print("The ad failed to load into memory.");
        break;
      case MobileAdEvent.clicked:
        print("The opened ad was clicked on.");
        break;
      case MobileAdEvent.impression:
        print("The user is still looking at the ad. A new ad came up.");
        break;
      case MobileAdEvent.opened:
        print("The Ad is now open.");
        break;
      case MobileAdEvent.leftApplication:
        print("You've left the app after clicking the Ad.");
        break;
      case MobileAdEvent.closed:
        print("You've closed the Ad and returned to the app.");
        break;
      default:
        print("There's a 'new' MobileAdEvent?!");
    }
  };

  static void showBanner({
    String adUnitId,
    AdSize size,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
    MobileAdListener listener,
    State state,
    double anchorOffset,
    AnchorType anchorType}) => _ads?.showBannerAd(
      adUnitId: adUnitId,
      size: size,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      testing: testing,
      listener: listener,
      state: state,
      anchorOffset: anchorOffset,
      anchorType: anchorType,
    );

  static void hideBanner() => _ads?.hideBannerAd();

  /// Call this static function in your State object's initState() function.
  static void init() => _ads ??= Ads(
    _appId,
    bannerUnitId: _bannerUnitId,
    keywords: <String>['ibm', 'computers'],
    contentUrl: 'http://www.ibm.com',
    childDirected: false,
    testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
    testing: true,
    listener: _eventListener,
  );

  /// Remember to call this in the State object's dispose() function.
  static void dispose() => _ads?.dispose();
}