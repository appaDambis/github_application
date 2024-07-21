class Issue {
  final String title;
  final String repositoryName;
  final String state;
  final String createdAt;

  Issue({
    required this.title,
    required this.repositoryName,
    required this.state,
    required this.createdAt,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      title: json['title'],
      repositoryName: json['repository']['name'],
      state: json['state'],
      createdAt: json['created_at'],
    );
  }
}
