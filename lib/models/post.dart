class Post {
  final String id;
  final String userId;
  final String content;
  final DateTime timestamp;

  Post({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
  }) : assert(id != null, 'Id cannot be null'),
       assert(userId != null, 'UserId cannot be null'),
       assert(content != null, 'Content cannot be null'),
       assert(timestamp != null, 'Timestamp cannot be null');
}
