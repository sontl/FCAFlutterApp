import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:Freedemy/AppAds.dart';
import 'package:Freedemy/DeviceUtils.dart';
import 'package:Freedemy/models/CourseDetail.dart';
import 'package:Freedemy/models/CourseStatus.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:Freedemy/models/Globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Free Premium Udemy Courses',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: 
        FutureBuilder<List>(
          future: fetchListCourseDetails(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            globals.courses = snapshot.data;
            return snapshot.hasData
                ? MyHomePage(title: 'Free Premium Udemy Courses', courses: globals.courses )
                : Center(child: CircularProgressIndicator());
          },
        ),
     // new MyHomePage(title: 'Free Premium Udemy Courses'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<CourseStatus> courses;
  final String title;
  MyHomePage({Key key, this.title, this.courses}) : super(key: key);
  
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    AppAds.init();
    AppAds.inspectAdEnv();
    AppAds.showBanner(state: this, anchorOffset: 0.0, anchorType: AnchorType.bottom);
  }

  @override
  void dispose() {
    AppAds.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
    });
  }
  Choice _selectedChoice = choices[0]; 

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

  Future<Widget> buildCourseDetailPageAsync(item) async {
    return Future.microtask(() {
        return CourseDetailPage(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    var totalFreeCourses = widget.courses.length.toString();
    final _random = new Random();
    int randomIndex = _random.nextInt(widget.courses.length);
    CourseStatus randomFeaturedCourse = widget.courses[randomIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text("FREEDEMY", style: TextStyle(fontSize: 25.0, color: Colors.white,),),
        elevation: 0.0,
        centerTitle: false,
        // actions: <Widget>[
        //   // overflow menu
        //   PopupMenuButton<Choice>(
        //     onSelected: _select,
        //     icon: Icon(Icons.category),
        //     itemBuilder: (BuildContext context) {
        //       return choices.skip(2).map((Choice choice) {
        //         return PopupMenuItem<Choice>(
        //           value: choice,
        //           child: Text(choice.title),
        //         );
        //       }).toList();
        //     },
        //   ),
        // ],
      ),
      body: ListView(
        children: <Widget>[
          GestureDetector(

            onTap: () {
                //Navigator.push(context, route);
                Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => CourseDetailPage(randomFeaturedCourse,)))
                  .then((value) {
                    print(value);
                    AppAds.dispose();
                    AppAds.init();
                    AppAds.inspectAdEnv();
                    AppAds.showBanner(anchorOffset: 0.0, anchorType: AnchorType.bottom);
                  });
              },  
              child: MasterHead(courseStatus: randomFeaturedCourse,),
          ),
          Row(
            children: <Widget>[
              const Padding(padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0)),
              Text(totalFreeCourses + " free courses in ALL CATEGORIES")
          ],),
          //Row(children: widget.courses.map((item) => new CourseInfoListItem(courseDetail: item)).toList()),
          for(var item in widget.courses)  
            GestureDetector(
              onTap: () async{
                var page = await buildCourseDetailPageAsync(item);
                var route = MaterialPageRoute(builder: (_) => page);
                //Navigator.push(context, route);
                Navigator.of(context)
                  .push(route)
                  .then((value) {
                    print(value);
                    AppAds.dispose();
                    AppAds.init();
                    AppAds.inspectAdEnv();
                    AppAds.showBanner(state: this, anchorOffset: 0.0, anchorType: AnchorType.bottom);
                  });
              },  
              child: CourseInfoListItem(courseDetail: item.courseDetail)
              ),
          //CourseInfoListItem()
          const SizedBox(height: 40),
        ],
      ), 
    );
  }
}

class FeaturedCourse extends StatelessWidget {
  final CourseStatus courseStatus;
  FeaturedCourse({Key key, this.courseStatus}) : super(key:key);
  
  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.9;
    Widget photoWithCaption = Container(
      width: cardWidth,
      margin: EdgeInsets.all(10.0),
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Center(
            child: Image.network(courseStatus.courseDetail.img480x270Url, width: cardWidth,),),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.blueGrey.withOpacity(0.4),
              width: cardWidth,
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Text(
                courseStatus.courseDetail.title, 
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),),
            ),
          ),
        ],
      )
    ); 

    return Card(
      margin: EdgeInsets.all(14.0),
      child: Column(
        children: <Widget>[
          photoWithCaption,
          Container(
            width: cardWidth,
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: Text(courseStatus.courseDetail.headline),
          ), 
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
            child: CourseInfoHightlight(
              rating: courseStatus.courseDetail.avgRating, 
              noOfRatings: courseStatus.courseDetail.numReviews, 
              price: courseStatus.courseDetail.listingPrice,
              noOfStudent: courseStatus.courseDetail.numStudents,
              showPrice: false,
            ),
          ),
          Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0)),
        ],
      )
    );
  }
}

class MasterHead extends StatelessWidget {
  final CourseStatus courseStatus;
  MasterHead({Key key, this.courseStatus}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Container(
          width: deviceWidth,
          height: 310.0,
          color: Colors.transparent,
        ),
        Container(
          width: deviceWidth,
          height: 100.0,
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          color: Colors.blue,
        ),
        Positioned(
          child: 
            FeaturedCourse(courseStatus: courseStatus,),
        ),
        Positioned(
          child: Row(children: <Widget> [
            Text(
              courseStatus.courseDetail.listingPrice, 
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.blue,
              ),
            ),
            Text(
              " FREE", 
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color:Colors.green),
            )],
          ), 
          left: 36.0,
          top: 34.0,
        )
      ],
    );
  }
}
class CourseInfoListItem extends StatelessWidget {
  final CourseDetail courseDetail;

  CourseInfoListItem({Key key, this.courseDetail}) : super(key:key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        //mainAxisSize: MainAxisSize.max,
        children: <Widget> [
          ListTile(
            title: Text(courseDetail.title),
            subtitle: Text(courseDetail.headline),
            leading: Image.network(
              courseDetail.img96x54Url, width: 90.0,),
          ),
          Row (
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 0.0),
                child: CourseInfoHightlight(
                  rating: courseDetail.avgRating, 
                  noOfRatings: courseDetail.numReviews, 
                  price: courseDetail.listingPrice,
                  noOfStudent: courseDetail.numStudents,
                ),
              ),
            ],
          ),
          
        ]
      ),
    );
    
  }
}

class CourseInfoHightlight extends StatelessWidget {
  final double rating;
  final String price;
  final int noOfRatings;
  final int noOfStudent;
  final bool showPrice;

  CourseInfoHightlight({ this.rating = .0, this.price, this.noOfRatings=0, this.noOfStudent=0, this.showPrice=true});
  
  Widget build(BuildContext context) {
    var info = <Widget>[];
    info.add(Align(
      alignment: Alignment.bottomLeft,
      child: StarRating(rating: rating, color: Colors.orangeAccent,))
    );
    info.add(Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 6.0, 0.0)));
    info.add(Text(rating.toString(), 
        style: TextStyle(fontSize: 12.0)));
    info.add(
      Text( 
        " (" + noOfRatings.toString() + " ratings)", 
        style: TextStyle(fontSize: 12.0)
      ),
    );
    info.add(
      Text( 
        "  " + noOfStudent.toString() + " students", 
        style: TextStyle(fontSize: 12.0)
      ),
    );
    if (showPrice) {
      info.add(Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0)));
      info.add(
        Text(
          price, 
          style: TextStyle(
            decoration: TextDecoration.lineThrough,
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        )
      );
      info.add(
        Text(
          " FREE", 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            color: Colors.green
          ),
        )
      );
    }
    
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Row(
        children: info,          
      )
    );
  }
}

Future<List<CourseStatus>> fetchListCourseDetails(http.Client client) async {
  final response = await client.get("https://o2lw3pohuj.execute-api.ap-southeast-1.amazonaws.com/test/courses?status=VALID");
  if (response.statusCode == 200) {
    return compute(parseListCourseDetails, response.body);
  }
  return null;
}

Future<List<CourseStatus>> fetchCourseComponents(http.Client client) async {
  final response = await client.get("https://o2lw3pohuj.execute-api.ap-southeast-1.amazonaws.com/test/courses?status=VALID");
  if (response.statusCode == 200) {
    return compute(parseListCourseDetails, response.body);
  }
  return null;
}

List<CourseStatus> parseListCourseDetails(String responseBody) {
  var coursesJson = json.decode(responseBody) as List;
  return coursesJson != null ? coursesJson.map((i)=>CourseStatus.fromJson(i)).toList() : null;
} 

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;

  StarRating({this.starCount = 5, this.rating = .0, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
        size: 14,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
        size: 14,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: 14,
      );
    }
    return InkResponse(
      onTap: onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: List.generate(starCount, (index) => buildStar(context, index)));
  }
}

class CourseDetailPage extends StatelessWidget {
  final CourseStatus courseStatus;
  bool ignoreFullScreenAds = false;
  CourseDetailPage(this.courseStatus);

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['udemy', 'course'],
    contentUrl: 'https://udemy.com',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );
  
  @override
  Widget build(BuildContext context) {
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
                        "Last Updated " + DateTime.now().toIso8601String(), 
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
                  splashColor: Colors.blueGrey,
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
            child: BackButton(),  
          ),
          Positioned(
            child: Row(children: <Widget> [
              Container(
                color: Colors.white60.withOpacity(0.8),
                child: Text(
                  courseDetail.listingPrice, 
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.blue,
                  ),
                ),
              ),
              Container(
                color: Colors.white60.withOpacity(0.8),
                child: Text(
                  " FREE", 
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color:Colors.green),
                ),
              )],
            ), 
            right: 10.0,
            top: 10.0,
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
          CourseInfoHightlight(
            rating: courseDetail.avgRating, 
            noOfRatings: courseDetail.numReviews, 
            price: courseDetail.listingPrice,
            noOfStudent: courseDetail.numStudents,
            showPrice: false,),
          Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0)),
        ],
      ),
      elevation: 0.4,
    );
  }
}

class BackButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // When the child is tapped, show a snackbar.
      onTap: () {
        Navigator.pop(context);
      },
      // The custom button
      child: Container(
          color: Colors.blueGrey.withOpacity(0.3),
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
        ),
      ),
    );
  }
}

class CouponDetailPage extends StatelessWidget {
  final CourseStatus course;

  CouponDetailPage({Key key, this.course}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coupon code'),
      ),
      body: SnackBarPage(courseStatus: course,), // Complete this code in the next step.
    );
  }
}

class SnackBarPage extends StatelessWidget {
  CourseStatus courseStatus;
  SnackBarPage({this.courseStatus});

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 120),
          Container(
            child: Text(courseStatus.couponCode, style: TextStyle(color: Colors.blueAccent, fontSize: 30.0, decoration: TextDecoration.none, fontWeight: FontWeight.bold),)
          ),
          const SizedBox(height: 120),
          Row(
            children: <Widget>[
              RaisedButton(
                child: Text("COPY"),
                elevation: 4.0,
                onPressed: () {
                  Clipboard.setData(new ClipboardData(text: courseStatus.couponCode));

                  AppAds.dispose();
                  final snackBar = SnackBar(
                    content: Text('Yay! Coupon is copied!'),
                    action: SnackBarAction(
                      label: 'Close',
                      onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );

                // Find the Scaffold in the widget tree and use
                // it to show a SnackBar.
                Scaffold.of(context).showSnackBar(snackBar);
                },
              )
          ]),
          Row (
            children: <Widget>[
              RaisedButton(
              child: Text("TAKE IT NOW"),
              onPressed: () {
                _launchURL(courseStatus.url);
              },
            ),
            ],
          ),
        ],
      ),
    );
  }
}
