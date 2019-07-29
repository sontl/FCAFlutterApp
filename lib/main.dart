import 'dart:async';
import 'dart:convert';
import 'package:FreePremiumCourse/models/CourseDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

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
            child: Text(courseDetail.headline),
          ), 
          CourseInfoHightlight(
            rating: courseDetail.avgRating, 
            noOfRatings: courseDetail.numReviews, 
            price: courseDetail.listingPrice,),
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
              courseDetail.img480x270Url, width: 90.0,),
          ),
          Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CourseInfoHightlight(
                  rating: courseDetail.avgRating, 
                  noOfRatings: courseDetail.numReviews,
                  price: courseDetail.listingPrice,)
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
  List<CourseDetail> displayedCourses;
  final response = await client.get("https://o2lw3pohuj.execute-api.ap-southeast-1.amazonaws.com/test/courses?status=VALID&with_details=true");
  if (response.statusCode == 200) {
    var coursesJson = json.decode(response.body) as List;
    displayedCourses = coursesJson != null 
                                        ? coursesJson.map((i)=>CourseDetail.fromJson(i["course_details"][0])).toList() : null;
  }
  return displayedCourses;
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