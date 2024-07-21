class Repository {
  final String name;
  final String description;
  final String language;
  final int stars;
  final int forks;
  final String htmlUrl;

  Repository({
    required this.name,
    required this.description,
    required this.language,
    required this.stars,
    required this.forks,
    required this.htmlUrl,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'],
      description: json['description'] ?? '',
      language: json['language'] ?? '',
      stars: json['stargazers_count'],
      forks: json['forks_count'],
      htmlUrl: json['html_url'],
    );
  }
}
