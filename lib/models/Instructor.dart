class Instructor {
  String title;
  String name;
  String displayName;
  String jobTitle;
  String image50x50;
  String image100x100;
  String initials;
  String url;

  Instructor({this.title, this.name, this.displayName, this.jobTitle, 
              this.image100x100, this.image50x50, this.initials, this.url});

  factory Instructor.fromJson(Map<String, dynamic> json){
    return Instructor(
      title: json['title'],
      name: json['name'],
      displayName: json['display_name'],
      jobTitle: json['job_title'],
      image50x50: json['image_50x50'],
      image100x100: json['image_100x100'],
      initials: json['initials'],
      url: json['url'],
    );
  }
}
