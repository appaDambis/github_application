class Project {
  final String name;
  final String url;
  final String body;
  final String createdAt;

  Project({
    required this.name,
    required this.url,
    required this.body,
    required this.createdAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'],
      url: json['html_url'],
      body: json['body'] ?? '',
      createdAt: json['created_at'],
    );
  }
}
