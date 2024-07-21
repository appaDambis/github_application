import 'package:equatable/equatable.dart';
import 'package:github_application/API/github_repository.dart';
import 'package:github_application/models/discussions_model.dart';
import 'package:github_application/models/issues_models.dart';
import 'package:github_application/models/projects_model.dart';
import 'package:github_application/models/pull_requests_model.dart';
import 'package:github_application/models/repository_model.dart';
import 'package:github_application/models/user_model.dart';

abstract class GithubState extends Equatable {
  @override
  List<Object> get props => [];
}

class GithubInitial extends GithubState {}

class GithubLoading extends GithubState {}

class GithubLoaded extends GithubState {
  final User user;
  final List<Repository> repositories;

  GithubLoaded({required this.user, required this.repositories});

  @override
  List<Object> get props => [user, repositories];
}

class GithubSearchLoaded extends GithubState {
  final User user;
  final List<Repository> repositories;

  GithubSearchLoaded({required this.user, required this.repositories});

  @override
  List<Object> get props => [user, repositories];
}

class GithubError extends GithubState {
  final String message;

  GithubError(this.message);

  @override
  List<Object> get props => [message];
}

class GithubFilesLoaded extends GithubState {
  final List<File> files;

  GithubFilesLoaded({required this.files});
}

class GithubPullRequestsLoaded extends GithubState {
  final List<PullRequest> pullRequests;

  GithubPullRequestsLoaded(this.pullRequests);
}

class GithubIssuesLoaded extends GithubState {
  final List<Issue> issues;

  GithubIssuesLoaded(this.issues);
}

class GithubDiscussionsLoaded extends GithubState {
  final List<Discussion> discussions;

  GithubDiscussionsLoaded(this.discussions);
}

class GithubProjectsLoaded extends GithubState {
  final List<Project> projects;

  GithubProjectsLoaded(this.projects);
}

class GithubStarredLoaded extends GithubState {
  final List<Repository> repositories;

  GithubStarredLoaded(this.repositories);
}
