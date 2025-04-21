class Post {
  final String id;
  final String userId;
  final String userName;
  final String userRollNumber;
  final String content;
  final String? imageUrl;
  final String? videoUrl;
  final DateTime timestamp;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userRollNumber,
    required this.content,
    this.imageUrl,
    this.videoUrl,
    required this.timestamp,
  }) : assert(id != null, 'Id cannot be null'),
       assert(userId != null, 'UserId cannot be null'),
       assert(userName != null, 'UserName cannot be null'),
       assert(userRollNumber != null, 'UserRollNumber cannot be null'),
       assert(content != null, 'Content cannot be null'),
       assert(timestamp != null, 'Timestamp cannot be null');
}
