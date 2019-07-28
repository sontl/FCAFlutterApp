import 'package:FreePremiumCourse/models/Curriculum.dart';

class CourseComponent {
  String courseId;
  String couponCode;
  String createdDate;
  String modifiedDate;
  Curriculum curriculum;

  CourseComponent({
    this.courseId,
    this.couponCode,
    this.createdDate,
    this.modifiedDate,
    this.curriculum
  });

  factory CourseComponent.fromJson(Map<String, dynamic> json) {
    var curriculum = Curriculum.fromJson(json['curriculum']);
    return CourseComponent(
      courseId: json['course_id'],
      couponCode: json['coupon_code'],
      createdDate: json['created_date'],
      modifiedDate: json['modified_date'],
      curriculum: curriculum,
    );
  }
}