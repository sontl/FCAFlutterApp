class Item {
  bool canBeReviewed;
  String contentSummary;
  String description;
  int id;
  bool isCodingExercise;
  String itemType;
  bool landingPageUrl;
  String learnUrl;
  int objectIndex;
  String previewUrl;
  String title;
  int videoAssetId; 

  Item({this.canBeReviewed, this.contentSummary, this.description, this.id, this.isCodingExercise,
        this.itemType, this.landingPageUrl, this.learnUrl, this.objectIndex, this.previewUrl, this.title, this.videoAssetId});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      canBeReviewed: json['canBeReviewed'] as bool,
      contentSummary: json['contentSummary'],
      description: json['description'],
      id: json['id'] as int,
      isCodingExercise: json['isCodingExercise'] as bool,
      itemType: json['itemType'],
      landingPageUrl: json['landingPageUrl'],
      learnUrl: json['learnUrl'],
      objectIndex: json['objectIndex'] as int,
      previewUrl: json['previewUrl'],
      title: json['title'],
      videoAssetId: json['videoAssetId'] as int,
    );
  }
}