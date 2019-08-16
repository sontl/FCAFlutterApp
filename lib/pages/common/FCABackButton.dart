import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FCABackButton extends StatelessWidget {

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