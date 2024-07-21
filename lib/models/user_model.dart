class User {
  final String login;
  final String avatarUrl;
  final String name;
  final String bio;
  final int publicRepos;

  User({
    required this.login,
    required this.avatarUrl,
    required this.name,
    required this.bio,
    required this.publicRepos,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'],
      avatarUrl: json['avatar_url'],
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      publicRepos: json['public_repos'],
    );
  }
}
