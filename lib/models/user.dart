class User {
  final String id;
  final String? email;
  final String? name;
  final String? year;
  final String? rollNo;
  final String? branch;
  final String? profileImageUrl;

  const User({
    required this.id,
    this.email,
    this.name,
    this.year,
    this.rollNo,
    this.branch,
    this.profileImageUrl,
  });
}
