import 'package:equatable/equatable.dart';

// Events
abstract class GithubEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUserData extends GithubEvent {
  final String token;

  FetchUserData(this.token);

  @override
  List<Object> get props => [token];
}

class SearchUser extends GithubEvent {
  final String username;
  final String token;

  SearchUser(this.username, this.token);

  @override
  List<Object> get props => [username, token];
}

class FetchRepositoryFiles extends GithubEvent {
  final String username;
  final String repoName;
  final String token;

  FetchRepositoryFiles({
    required this.username,
    required this.repoName,
    required this.token,
  });
}

class FetchUserPullRequests extends GithubEvent {
  final String token;

  FetchUserPullRequests(this.token);
}

class FetchUserIssues extends GithubEvent {
  final String token;

  FetchUserIssues(this.token);
}

class FetchUserDiscussions extends GithubEvent {
  final String token;

  FetchUserDiscussions(this.token);
}

class FetchUserProjects extends GithubEvent {
  final String token;

  FetchUserProjects(this.token);
}

class FetchStarredRepositories extends GithubEvent {
  final String token;

  FetchStarredRepositories(this.token);
}
