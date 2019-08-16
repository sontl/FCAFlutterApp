
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Freedemy/models/CourseStatus.dart';
import 'package:flutter/foundation.dart';

Future<List<CourseStatus>> fetchListCourseDetails(http.Client client) async {
  final response = await client.get("https://o2lw3pohuj.execute-api.ap-southeast-1.amazonaws.com/test/courses?status=VALID");
  if (response.statusCode == 200) {
    return compute(parseListCourseDetails, response.body);
  }
  return null;
}

Future<List<CourseStatus>> fetchCourseComponents(http.Client client) async {
  final response = await client.get("https://o2lw3pohuj.execute-api.ap-southeast-1.amazonaws.com/test/courses?status=VALID");
  if (response.statusCode == 200) {
    return compute(parseListCourseDetails, response.body);
  }
  return null;
}

List<CourseStatus> parseListCourseDetails(String responseBody) {
  var coursesJson = json.decode(responseBody) as List;
  return coursesJson != null ? coursesJson.map((i)=>CourseStatus.fromJson(i)).toList() : null;
} 
