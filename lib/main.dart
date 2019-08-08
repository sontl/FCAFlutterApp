import 'dart:async';
import 'dart:convert';
import 'package:FreePremiumCourse/AppAds.dart';
import 'package:FreePremiumCourse/models/CourseDetail.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:FreePremiumCourse/models/Globals.dart' as globals;
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
  final List<CourseDetail> courses;
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
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
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
    
    return Scaffold(
      appBar: AppBar(
        title: Text("ALL CATEGORIES", style: TextStyle(fontSize: 25.0, color: Colors.white,),),
        elevation: 0.0,
        centerTitle: false,
        actions: <Widget>[
          // overflow menu
          PopupMenuButton<Choice>(
            onSelected: _select,
            icon: Icon(Icons.category),
            itemBuilder: (BuildContext context) {
              return choices.skip(2).map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          MasterHead(courseDetail: widget.courses[0],),
          Row(
            children: <Widget>[
              const Padding(padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0)),
              Text(totalFreeCourses + " free courses in ALL CATEGORIES")
          ],),
          //Row(children: widget.courses.map((item) => new CourseInfoListItem(courseDetail: item)).toList()),
          for(var item in widget.courses) 
            GestureDetector(
              onTap: () async{
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => CourseDetailPage(item)),
                // );
                var page = await buildCourseDetailPageAsync(item);
                var route = MaterialPageRoute(builder: (_) => page);
                Navigator.push(context, route);
              },  
              child: CourseInfoListItem(courseDetail: item)
              ),
          //CourseInfoListItem()
          const SizedBox(height: 40),
        ],
      ), 
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.search),
        
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class FeaturedCourse extends StatelessWidget {
  final CourseDetail courseDetail;

  FeaturedCourse({Key key, this.courseDetail}) : super(key:key);
  
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
            child: Image.network(courseDetail.img480x270Url, width: cardWidth,),),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.blueGrey.withOpacity(0.4),
              width: cardWidth,
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Text(
                courseDetail.title, 
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
      )
    );
  }
}

class MasterHead extends StatelessWidget {
  final CourseDetail courseDetail;
  MasterHead({Key key, this.courseDetail}) : super(key:key);
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
            FeaturedCourse(courseDetail: courseDetail,),
        ),
        Positioned(
          child: Row(children: <Widget> [
            Text(
              courseDetail.listingPrice, 
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
              CourseInfoHightlight(
                rating: courseDetail.avgRating, 
                noOfRatings: courseDetail.numReviews,
                price: courseDetail.listingPrice,
                noOfStudent: courseDetail.numStudents,
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

Future<CourseDetail> fetchCourseDetails(http.Client client, courseId) async {
  final response =
      await client.get('https://www.udemy.com/api-2.0/courses/' + courseId 
        + '?fields[course]=title,is_paid,image_480x270,num_reviews,price,context_info,primary_category,primary_subcategory,avg_rating_recent,visible_instructors,locale,estimated_content_length,num_subscribers,headline,description');

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    return CourseDetail.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}


Future<List<CourseDetail>> fetchListCourseDetails(http.Client client) async {
  final response = await client.get("https://o2lw3pohuj.execute-api.ap-southeast-1.amazonaws.com/test/courses?status=VALID");
  if (response.statusCode == 200) {
    return compute(parseListCourseDetails, response.body);
  }
  return null;
}

Future<List<CourseDetail>> fetchCourseComponents(http.Client client) async {
  final response = await client.get("https://o2lw3pohuj.execute-api.ap-southeast-1.amazonaws.com/test/courses?status=VALID");
  if (response.statusCode == 200) {
    return compute(parseListCourseDetails, response.body);
  }
  return null;
}

List<CourseDetail> parseListCourseDetails(String responseBody) {
  var coursesJson = json.decode(responseBody) as List;
  return coursesJson != null ? coursesJson.map((i)=>CourseDetail.fromJson(i["details"])).toList() : null;
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
  final CourseDetail courseDetail;
  CourseDetailPage(this.courseDetail);

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['udemy', 'course'],
    contentUrl: 'https://udemy.com',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );
  
  @override
  Widget build(BuildContext context) {
    InterstitialAd myInterstitial = InterstitialAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
        if (event == MobileAdEvent.closed){
          AppAds.dispose();
          Navigator.push(context, MaterialPageRoute(builder: (context) => CouponDetailPage()),);
        }
      },
    );

    myInterstitial.load();
      
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          MasterHead2(courseDetail: courseDetail,),
          Container(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Created By " + courseDetail.instructors[0].displayName, 
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
                    myInterstitial.show(
                      anchorType: AnchorType.bottom,
                      anchorOffset: 0.0,
                    );
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
                          data: courseDetail.description,
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
    final CourseDetail course;

    CouponDetailPage({Key key, this.course}) : super(key: key);

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
            const SizedBox(height: 140),
            Container(
              child: Text("COUPON CODE HERE", style: TextStyle(color: Colors.blueAccent, fontSize: 30.0, decoration: TextDecoration.none),)
            ),
            const SizedBox(height: 80),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("COPY"),
                  elevation: 4.0,
                  onPressed: () {
                    
                  },
                )
            ]),
            Row (
              children: <Widget>[
                RaisedButton(
                child: Text("OPEN BROWSER"),
                onPressed: () {
                  _launchURL("https://www.udemy.com/logistic-regression-decision-tree-and-neural-network-in-r/");
                },
              ),
              ],
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("BACK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ) 
          ],
        ),
      );
    }
  }
