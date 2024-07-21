class PullRequest {
  final String title;
  final String repositoryName;
  final String state;
  final String createdAt;

  PullRequest({
    required this.title,
    required this.repositoryName,
    required this.state,
    required this.createdAt,
  });

  factory PullRequest.fromJson(Map<String, dynamic> json) {
    return PullRequest(
      title: json['title'],
      repositoryName: json['base']['repo']['name'],
      state: json['state'],
      createdAt: json['created_at'],
    );
  }
}
