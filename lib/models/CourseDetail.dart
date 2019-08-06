
import 'package:FreePremiumCourse/models/Instructor.dart';

class CourseDetail {
  int id;
  String title;
  bool isPaid;
  String description;
  String headline;
  double avgRating;
  String listingPrice;
  String img480x270Url;
  String img96x54Url;
  String img48x27Url;
  String created;
  String statusLabel;

  int numReviews;
  int numStudents;
  List<Instructor> instructors;

  CourseDetail({
    this.id, this.title, this.isPaid, this.description, this.headline, this.avgRating, this.listingPrice,
    this.img480x270Url, this.img96x54Url, this.img48x27Url, this.numReviews, this.numStudents, this.instructors,
    this.created, this.statusLabel
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    var avgRating = num.parse(json['avg_rating_recent'].toStringAsFixed(1));
    var instructorsJson = json['visible_instructors'] as List;
    List<Instructor> instructors = instructorsJson != null 
                                        ? instructorsJson.map((i)=>Instructor.fromJson(i)).toList() : null;
    return CourseDetail(
      id: json['id'] as int,
      title: json['title'],
      isPaid: json['id_paid'] as bool,
      description: json['description'],
      headline: json['headline'],
      avgRating: avgRating as double,
      listingPrice: json['price'],
      img480x270Url: json['image_480x270'],
      img96x54Url: json['image_96x54'],
      img48x27Url: json['image_48x27'],
      numReviews: json['num_reviews'] as int,
      numStudents: json['num_subscribers'] as int,
      instructors: instructors,
      created: json['created'],
      statusLabel: json['status_label']
    );
  }
}