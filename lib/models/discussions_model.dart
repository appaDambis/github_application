class Discussion {
  final String title;
  final String url;
  final String createdAt;
  final String author;

  Discussion({
    required this.title,
    required this.url,
    required this.createdAt,
    required this.author,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) {
    return Discussion(
      title: json['title'],
      url: json['url'],
      createdAt: json['createdAt'],
      author: json['author']['login'],
    );
  }
}
