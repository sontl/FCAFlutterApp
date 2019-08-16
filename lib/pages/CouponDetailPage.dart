import 'package:Freedemy/pages/AppAds.dart';
import 'package:Freedemy/models/CourseStatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class CouponDetailPage extends StatelessWidget {
  final CourseStatus course;

  CouponDetailPage({Key key, this.course}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coupon code'),
      ),
      body: FCASnackBar(courseStatus: course,), // Complete this code in the next step.
    );
  }
}

class FCASnackBar extends StatelessWidget {
  final CourseStatus courseStatus;
  FCASnackBar({this.courseStatus});

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
                child: const Text('SHARE'),
                onPressed: () {
                  final RenderBox box = context.findRenderObject();
                  Share.share(courseStatus.url,
                      sharePositionOrigin:
                      box.localToGlobal(Offset.zero) &
                      box.size);
                },
              ),
            ],
          ),
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
                      label: 'Dismiss',
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