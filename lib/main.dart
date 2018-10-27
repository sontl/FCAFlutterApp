import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
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
    buildRatingStar

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget> [
          const ListTile(
            title: Text('The web developer bootcamp'),
            subtitle: Text('The only course you need to learn web development - HTML, CSS, JS, Node, and More!'),
            leading: Icon(Icons.album)
          ),
          ButtonTheme.bar( // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                Icon(Icons.star),
                FlatButton(
                  child: const Text('LISTEN'),
                  onPressed: () { /* ... */ },
                ),
              ],
            ),
          ),
        ]
      )
    );
  } 
}