import 'package:FreePremiumCourse/models/Data.dart';

class Curriculum {
  Data data;
  Curriculum({this.data});

  factory Curriculum.fromJson(Map<String, dynamic> json) {
    var data = Data.fromJson(json['data']);
    return Curriculum(data: data);
  }
}