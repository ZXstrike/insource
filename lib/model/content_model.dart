class ContentData {
  final String documentId;
  final String imageUrl;
  final String title;
  final List liked;
  final String creatorId;
  final String creatorName;
  final String creatorPicture;

  ContentData(
    this.documentId,
    this.imageUrl,
    this.title,
    this.liked,
    this.creatorId,
    this.creatorName,
    this.creatorPicture,
  );

  factory ContentData.fromMapToModel(
    Map<String, dynamic> map,
  ) =>
      ContentData(
        map['documentId'],
        map['imageUrl'],
        map['title'],
        map['liked'],
        map['creatorId'],
        map['creatorName'],
        map['creatorPicture'],
      );
}
