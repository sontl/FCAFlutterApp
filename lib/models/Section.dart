import 'package:Freedemy/models/Item.dart';

class Section {
  List<Item> items;
  String contentLengthText;
  int index;
  int lectureCount;
  String title;

  Section(
    { this.items,
      this.contentLengthText,
      this.index,
      this.lectureCount,
      this.title
    }
  );

  factory Section.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List;
    List<Item> items = itemsJson != null ? itemsJson.map((i)=> Item.fromJson(i)).toList() : null;
    return Section(
      items: items,
      contentLengthText: json['contentLengthText'],
      index: json['index'] as int,
      lectureCount: json['lectureCount'] as int,
      title: json['title']
    );
  }
}