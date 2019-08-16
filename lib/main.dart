import 'package:Freedemy/pages/MyHomePage.dart';
import 'package:Freedemy/services/AWSLambdaSvc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Freedemy/models/Globals.dart' as globals;

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
    );
  }
}