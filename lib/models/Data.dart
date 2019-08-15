import 'package:Freedemy/models/Section.dart';

class Data {
  List<Section> displayedSections;
  List<Section> sections;

  Data({this.displayedSections, this.sections});

  factory Data.fromJson(Map<String, dynamic> json) {
    var displayedSectionsJson = json['displayed_sections'] as List;
    List<Section> displayedSections = displayedSectionsJson != null 
                                        ? displayedSectionsJson.map((i)=>Section.fromJson(i)).toList() : null;
    var sectionsJson = json['json'] as List;                                  
    List<Section> sections = sectionsJson != null ? sectionsJson.map((i)=>Section.fromJson(i)).toList() : null;

    return Data(
      displayedSections : displayedSections,
      sections : sections,
    );
  }
}