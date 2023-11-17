class Post {
  final String description;
  final String uid;
  final String username;
  final List likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profileImage;
  Post(
      {required this.description,
      required this.uid,
      required this.username,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profileImage,
      required this.likes});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'uid': uid,
      'username': username,
      'likes': likes,
      'postId': postId,
      'datePublished': datePublished.millisecondsSinceEpoch,
      'postUrl': postUrl,
      'profImage': profileImage,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      description: map['description'] as String,
      uid: map['uid'] as String,
      username: map['username'] as String,
      likes: map['likes'] as List,
      postId: map['postId'] as String,
      datePublished: DateTime.fromMillisecondsSinceEpoch(map['datePublished'] as int),
      postUrl: map['postUrl'] as String,
      profileImage: map['profImage'] as String,
    );
  }
}
