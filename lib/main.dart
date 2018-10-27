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
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
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
        title: Text(widget.title),
      ),
      body: Center(
        child: CourseInfoListItem()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.search),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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

    Widget buildRatingStar(double rate, int noOfRate) {
      var stars = <Widget>[];
      for (var i=0; i < rate; i++) {
        stars.add(Icon(Icons.star, color: Colors.orange,));
      }
      stars.add(Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 6.0, 0.0)));
      stars.add(Text(rate.toString()));
      stars.add(Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 6.0, 0.0)));
      stars.add(Text( 
        "(" + noOfRate.toString() + " ratings)", 
        style: TextStyle(fontSize: 12.0),)
      );
      return Container(
        width: 360.0,
        child: Row(
          children: stars,          
        )
      );
    }

    return Card(
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
                buildRatingStar(4.0, 13356),
              ],
            ),
          ),
        ]
      )
    );
  } 
}