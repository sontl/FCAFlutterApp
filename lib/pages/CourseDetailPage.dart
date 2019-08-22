import 'dart:io';
import 'package:Freedemy/utils/DeviceUtils.dart';
import 'package:Freedemy/models/CourseDetail.dart';
import 'package:Freedemy/models/CourseStatus.dart';
import 'package:Freedemy/pages/CouponDetailPage.dart';
import 'package:Freedemy/pages/MyHomePage.dart';
import 'package:Freedemy/pages/common/FCABackButton.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

class CourseDetailPage extends StatelessWidget {
  final CourseStatus courseStatus;
  
  CourseDetailPage(this.courseStatus);

  final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['udemy', 'course'],
    contentUrl: 'https://udemy.com',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );
  
  @override
  Widget build(BuildContext context) {
    bool ignoreFullScreenAds = false;
    var adUnitId = DeviceUtils.currentBuildMode() == BuildMode.RELEASE 
        ? Platform.isAndroid ? 'ca-app-pub-8426215910423009/2020162133'
            : 'ca-app-pub-3940256099942544/4411468910' 
        : InterstitialAd.testAdUnitId;
    print('InterstitialAd id: ' + adUnitId);
    InterstitialAd myInterstitial = InterstitialAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: adUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.closed){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CouponDetailPage(course: courseStatus,)),);
        } else if (event == MobileAdEvent.failedToLoad) {
          ignoreFullScreenAds = true;
        }
      },
    );

    myInterstitial.load().catchError((e){
      print(e);
    });
    final f = new DateFormat('dd-MMM-yyyy hh:mm');
    var modifiedDate = f.format(DateTime.parse(courseStatus.modifiedDate));
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          MasterHead2(courseDetail: courseStatus.courseDetail,),
          Container(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Created By " + courseStatus.courseDetail.instructors[0].displayName, 
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 13.0, color: Colors.black, 
                        fontWeight: FontWeight.normal, decoration: TextDecoration.none
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top:8.0, bottom:10.0),
                      child: Text(
                        
                        "Last Updated " + modifiedDate, 
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    
                  ],
                ),
                new RaisedButton(
                  child: const Text('SHOW COUPON', style: TextStyle(fontSize: 20, color: Colors.white)),
                  color: Theme.of(context).accentColor,
                  elevation: 4.0,
                  splashColor: Colors.blue,
                  highlightElevation: 8.0,
                  disabledElevation: 0.0,
                  onPressed: () {
                    if (ignoreFullScreenAds) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CouponDetailPage(course: courseStatus,)),);
                    } else {
                      myInterstitial.show(
                        anchorType: AnchorType.bottom,
                        anchorOffset: 0.0,
                      ).catchError((error){
                        print(error);
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  color: Color.fromRGBO(209, 209, 209, 0.4),
                  padding: EdgeInsets.all(4.0),
                  margin: EdgeInsets.all(0.0),
                  child: Column(
                    children: <Widget>[
                      Container(child: 
                        Html(
                          data: courseStatus.courseDetail.description,
                          padding: EdgeInsets.all(4.0),
                          defaultTextStyle: TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.normal, color: Colors.black,
                            decoration: TextDecoration.none
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      )
    ,); 
  }
}

class MasterHead2 extends StatelessWidget {
  final CourseDetail courseDetail;
  MasterHead2({Key key, this.courseDetail}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    return FeaturedCourse2(courseDetail: courseDetail,);
  }
}

class FeaturedCourse2 extends StatelessWidget {
  final CourseDetail courseDetail;
  
  FeaturedCourse2({Key key, this.courseDetail}) : super(key:key);
  
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    Widget photoWithCaption = Container(
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Center(
            child: Image.network(courseDetail.img480x270Url,),),
          Positioned(
            bottom: 0.0,
            width: deviceWidth,
            child: Container(
              color: Colors.blueGrey.withOpacity(0.6),
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Text(
                courseDetail.title, 
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),),
            ),
          ),
          Positioned(
            top: 10.0,
            left: 10.0,
            child: FCABackButton(),  
          ),
          Positioned(
            child: Row(children: <Widget> [
              Container(
                color: Colors.white60.withOpacity(0.7),
                child: Text(
                  courseDetail.listingPrice, 
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              ],
            ), 
            right: 40.0,
            top: 10.0,
          ),
          ClipRect(
            child: Banner(
              message: "FREE",
              location: BannerLocation.topEnd,
              color: Colors.blue,
              child: Container(
                height: 60.0,
              ),
            ),
          )
        ],
      )
    ); 

    return Card(
      child: Column(
        children: <Widget>[
          photoWithCaption,
          Container(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: Text(courseDetail.headline),
          ), 
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            child: CourseInfoHightlight(
              rating: courseDetail.avgRating, 
              noOfRatings: courseDetail.numReviews, 
              price: courseDetail.listingPrice,
              noOfStudent: courseDetail.numStudents,
              showPrice: false,),
          )
          ,
          Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0)),
        ],
      ),
      elevation: 0.4,
    );
  }
}