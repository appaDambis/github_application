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

class Repository {
  final String name;
  final String description;
  final String language;
  final int stars;
  final int forks;

  Repository({
    required this.name,
    required this.description,
    required this.language,
    required this.stars,
    required this.forks,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'],
      description: json['description'] ?? '',
      language: json['language'] ?? '',
      stars: json['stargazers_count'],
      forks: json['forks_count'],
    );
  }
}
