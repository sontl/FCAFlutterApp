import 'dart:async';
import 'dart:convert';
import 'package:FreePremiumCourse/models/CourseDetail.dart';
import 'package:flutter/material.dart';
import 'package:FreePremiumCourse/models/CourseComponent.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: 
        FutureBuilder<List>(
              future: fetchListCourseDetails(http.Client()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? MyHomePage(title: 'Free Premium Udemy Courses', courses: snapshot.data)
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

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    var totalFreeCourses = widget.courses.length.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text("     List courses in", style: TextStyle(fontSize: 25.0, color: Colors.white,),),
        elevation: 0.0,
        centerTitle: false,
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
          for(var item in widget.courses ) CourseInfoListItem(courseDetail: item)
          //CourseInfoListItem()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.search),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class FeaturedCourse extends StatefulWidget {
  final CourseDetail courseDetail;

  FeaturedCourse({Key key, this.courseDetail}) : super(key:key);
  @override
  _FeaturedCourseState createState() => new _FeaturedCourseState();
}

class _FeaturedCourseState extends State<FeaturedCourse> {
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
            child: Image.network(widget.courseDetail.img480x270Url, width: cardWidth,),),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.blueGrey.withOpacity(0.4),
              width: cardWidth,
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Text(
                widget.courseDetail.title, 
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
            child: Text(widget.courseDetail.headline),
          ), 
          CourseInfoHightlight(
            rating: widget.courseDetail.avgRating, 
            noOfRatings: widget.courseDetail.numReviews, 
            price: widget.courseDetail.listingPrice,),
          Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0)),
        ],
      )
    );
  }
}

class MasterHead extends StatefulWidget {
  final CourseDetail courseDetail;
  MasterHead({Key key, this.courseDetail}) : super(key:key);
  @override
  _MasterHeadState createState() => new _MasterHeadState();
}

class _MasterHeadState extends State<MasterHead> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Container(
          width: deviceWidth,
          height: 420.0,
          color: Colors.transparent,
        ),
        Container(
          width: deviceWidth,
          height: 150.0,
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          color: Colors.blue,
        ),
        Row(
          children: <Widget>[
            const Padding(padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0)),
            const Text("ALL CATEGORIES", style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),),
            const Icon(Icons.arrow_drop_down, color: Colors.white,)
          ],
        ), 
        Positioned(
          top: 50.0,
          child: 
            FeaturedCourse(courseDetail: widget.courseDetail,),
        )
      ],
    );
  }
}

class CourseInfoListItem extends StatefulWidget {
  final CourseDetail courseDetail;

  CourseInfoListItem({Key key, this.courseDetail}) : super(key:key);
  
  @override
  _CourseInfoListItemState createState() => new _CourseInfoListItemState();
}

class _CourseInfoListItemState extends State<CourseInfoListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(14.0),
      child: Column(
        //mainAxisSize: MainAxisSize.max,
        children: <Widget> [
          ListTile(
            title: Text(widget.courseDetail.title),
            subtitle: Text(widget.courseDetail.headline),
            leading: Image.network(
              widget.courseDetail.img480x270Url, width: 90.0,),
          ),
          Row (
              children: <Widget>[
                CourseInfoHightlight(
                  rating: widget.courseDetail.avgRating, 
                  noOfRatings: widget.courseDetail.numReviews,
                  price: widget.courseDetail.listingPrice,)
              ],
            ),
        ]
      )
    );
  }
}

class CourseInfoHightlight extends StatelessWidget {
  final double rating;
  final String price;
  final int noOfRatings;

  CourseInfoHightlight({ this.rating = .0, this.price, this.noOfRatings=0});
  
  Widget build(BuildContext context) {
    var info = <Widget>[];
    info.add(Align(
      alignment: Alignment.bottomLeft,
      child: StarRating(rating: rating, color: Colors.orangeAccent,))
    );
    info.add(Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 6.0, 0.0)));
    info.add(Text(rating.toString()));
    info.add(
      Text( 
        " (" + noOfRatings.toString() + " ratings)", 
        style: TextStyle(fontSize: 12.0)
      ),
    );
    info.add(Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0)));
    info.add(
      Text(
        price, 
        style: TextStyle(
          decoration: TextDecoration.lineThrough,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      )
    );
    info.add(
      Text(
        " FREE", 
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: Colors.green
        ),
      )
    );
    return Container(
      width: MediaQuery.of(context).size.width - 30,
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
  final response = await client.get("https://o2lw3pohuj.execute-api.ap-southeast-1.amazonaws.com/test/courses?status=VALID&with_details=true");
  if (response.statusCode == 200) {
    var coursesJson = json.decode(response.body) as List;
    List<CourseDetail> displayedCourses = coursesJson != null 
                                        ? coursesJson.map((i)=>CourseDetail.fromJson(i["course_details"][0])).toList() : null;
    return displayedCourses;
  }
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
        size: 20,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
        size: 20,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: 20,
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