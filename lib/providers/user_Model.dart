class UserModel {
  final String uid;
  final String name;
  final String email;
  final String image;
  final DateTime lastActive;
  final bool isOnline;

  UserModel(
      {required this.uid,
      required this.email,
      required this.image,
      required this.isOnline,
      required this.lastActive,
      required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // print(json);
    return UserModel(
        uid: json['uid'],
        email: json['email'],
        image: json['image'],
        isOnline: json['isOnline'] ?? false,
        lastActive: json['lastActive'].toDate(),
        name: json['name']);
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'image': image,
        'lastActive': lastActive,
        'isOnline': isOnline,
      };
}
