class UserPersonalData {
  String imageUrl;
  String email;
  String username;

  UserPersonalData(
    this.imageUrl,
    this.email,
    this.username,
  );

  factory UserPersonalData.fromMap(Map<String, dynamic> map) =>
      UserPersonalData(
        map['profileImageUrl'],
        map['userEmail'],
        map['userName'],
      );
}
