import 'package:flutter/material.dart';

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
      home: new MyHomePage(title: 'Free Premium Udemy Courses'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  
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
    return Scaffold(
      appBar: AppBar(
        title: Text("     List courses in", style: TextStyle(fontSize: 25.0, color: Colors.white,),),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: ListView(
        children: <Widget>[
          MasterHead(),
          Row(
            children: <Widget>[
              const Padding(padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0)),
              Text("23 free courses in ALL CATEGORIES")
          ],),
          CourseInfoListItem()
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
            child: Image.network("https://udemy-images.udemy.com/course/480x270/1949472_451a_2.jpg", width: cardWidth,),),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.blueGrey.withOpacity(0.4),
              width: cardWidth,
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Text(
                "The Ultimate Guide to Real World Applications with Unity", 
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
            child: Text("No MERN or MEAN… just Express. For those who’ve learned a bit about the most awesome node framework, and want more. | By Robert Bunch"),
          ), 
          CourseInfoHightlight(rating: 4.9, noOfRatings: 11234, price: 98.98,),
          Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0)),
        ],
      )
    );
  }
}

class MasterHead extends StatefulWidget {
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
          child: FeaturedCourse(),
        )
      ],
    );
  }
}

class CourseInfoListItem extends StatefulWidget {
  @override
  _CourseInfoListItemState createState() => new _CourseInfoListItemState();
}

class _CourseInfoListItemState extends State<CourseInfoListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget> [
          ListTile(
            title: Text('The web developer bootcamp'),
            subtitle: Text('The only course you need to learn web development - HTML, CSS, JS, Node, and More!'),
            leading: Image.network(
              "https://udemy-images.udemy.com/course/480x270/1326292_4dcf.jpg", width: 90.0,),
          ),
          ButtonTheme.bar( // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                CourseInfoHightlight(rating: 4.2, noOfRatings: 32124, price: 212.99,)
              ],
            ),
          ),
        ]
      )
    );
  } 
}

class CourseInfoHightlight extends StatelessWidget {
  final double rating;
  final double price;
  final int noOfRatings;

  CourseInfoHightlight({ this.rating = .0, this.price=.0, this.noOfRatings=0});
  
  Widget build(BuildContext context) {
    var info = <Widget>[];
    info.add(StarRating(rating: rating, color: Colors.orangeAccent,));
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
        "\$" + price.toString(), 
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
      width: 360.0,
      child: Row(
        children: info,          
      )
    );
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
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
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