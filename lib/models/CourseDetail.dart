
class CourseDetail {
  int id;
  String title;
  bool isPaid;
  String description;
  String headline;
  double avgRating;
  String listingPrice;
  String img480x270Url;
  int numReviews;

  CourseDetail({
    this.id, this.title, this.isPaid, this.description, this.headline, 
    this.avgRating, this.listingPrice, this.img480x270Url, this.numReviews
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    var avgRating = num.parse(json['avg_rating_recent'].toStringAsFixed(1));
    return CourseDetail(
      id: json['id'] as int,
      title: json['title'],
      isPaid: json['id_paid'] as bool,
      description: json['description'],
      headline: json['headline'],
      avgRating: avgRating as double,
      listingPrice: json['price'],
      img480x270Url: json['image_480x270'],
      numReviews: json['num_reviews'] as int,
    );
  }
}