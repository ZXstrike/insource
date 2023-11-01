class ContentData {
  final String documentId;
  final String imageUrl;
  final String title;
  final List liked;
  final List saved;
  final String creatorId;
  final String creatorName;
  final String creatorPicture;

  ContentData(
    this.documentId,
    this.imageUrl,
    this.title,
    this.liked,
    this.saved,
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
        map['saved'],
        map['creatorId'],
        map['creatorName'],
        map['creatorPicture'],
      );
}
