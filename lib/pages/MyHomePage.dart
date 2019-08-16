import 'dart:math';

import 'package:Freedemy/AppAds.dart';
import 'package:Freedemy/models/CourseDetail.dart';
import 'package:Freedemy/models/CourseStatus.dart';
import 'package:Freedemy/pages/CourseDetailPage.dart';
import 'package:Freedemy/pages/common/FCAStarRating.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  // Choice _selectedChoice = choices[0]; 

  // void _select(Choice choice) {
  //   // Causes the app to rebuild with the new _selectedChoice.
  //   setState(() {
  //     _selectedChoice = choice;
  //   });
  // }

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
      child: FCAStarRating(rating: rating, color: Colors.orangeAccent,))
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
