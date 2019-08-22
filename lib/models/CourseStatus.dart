import 'package:Freedemy/models/CourseDetail.dart';

class CourseStatus {
  String status;
  String courseId;
  String url;
  String couponCode;
  String modifiedDate;
  CourseDetail courseDetail;

  CourseStatus({this.status, this.courseId, this.url, this.couponCode, this.courseDetail, this.modifiedDate});

  factory CourseStatus.fromJson(Map<String, dynamic> json) {
    var courseDetailJson = json['details'];
    CourseDetail courseDetail = courseDetailJson != null ? 
      CourseDetail.fromJson(courseDetailJson) : null;

    return CourseStatus(
      url: json['url'],
      courseId: json['course_id'],
      status: json['status'],
      courseDetail: courseDetail,
      couponCode: json['coupon_code'],
      modifiedDate: json['modified_date']
    );
  }
}