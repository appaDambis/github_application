import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_application/API/github_repository.dart';
import 'package:github_application/bloc/github_event.dart';
import 'package:github_application/bloc/github_state.dart';

class GithubBloc extends Bloc<GithubEvent, GithubState> {
  final GithubRepository githubRepository;

  GithubBloc(this.githubRepository) : super(GithubInitial()) {
    on<FetchUserData>(_onFetchUserData);
    on<SearchUser>(_onSearchUser);
    on<FetchRepositoryFiles>(_onFetchRepositoryFiles);
    on<FetchUserPullRequests>(_onFetchUserPullRequests);
    on<FetchUserIssues>(_onFetchUserIssues);
    on<FetchUserDiscussions>(_onFetchUserDiscussions);
    on<FetchUserProjects>(_onFetchUserProjects);
    on<FetchStarredRepositories>(_onFetchStarredRepositories);
  }

  void _onFetchUserData(FetchUserData event, Emitter<GithubState> emit) async {
    emit(GithubLoading());
    try {
      final user = await githubRepository.fetchUserData(event.token);
      final repositories =
          await githubRepository.fetchUserRepositories(event.token);
      emit(GithubLoaded(user: user, repositories: repositories));
    } catch (e) {
      emit(GithubError(e.toString()));
    }
  }

  void _onSearchUser(SearchUser event, Emitter<GithubState> emit) async {
    emit(GithubLoading());
    try {
      final user =
          await githubRepository.searchUser(event.username, event.token);
      final repositories = await githubRepository.searchUserRepositories(
          event.username, event.token);
      emit(GithubSearchLoaded(user: user, repositories: repositories));
    } catch (e) {
      emit(GithubError(e.toString()));
    }
  }

  void _onFetchRepositoryFiles(
      FetchRepositoryFiles event, Emitter<GithubState> emit) async {
    emit(GithubLoading());
    try {
      final files = await githubRepository.fetchRepositoryFiles(
        event.username,
        event.repoName,
        event.token,
      );
      emit(GithubFilesLoaded(files: files));
    } catch (e) {
      emit(GithubError(e.toString()));
    }
  }

  void _onFetchUserPullRequests(
      FetchUserPullRequests event, Emitter<GithubState> emit) async {
    emit(GithubLoading());
    try {
      final pullRequests =
          await githubRepository.fetchUserPullRequests(event.token);
      emit(GithubPullRequestsLoaded(pullRequests));
    } catch (e) {
      emit(GithubError(e.toString()));
    }
  }

  void _onFetchUserIssues(
      FetchUserIssues event, Emitter<GithubState> emit) async {
    emit(GithubLoading());
    try {
      final issues = await githubRepository.fetchUserIssues(event.token);
      emit(GithubIssuesLoaded(issues));
    } catch (e) {
      emit(GithubError(e.toString()));
    }
  }

  void _onFetchUserDiscussions(
      FetchUserDiscussions event, Emitter<GithubState> emit) async {
    emit(GithubLoading());
    try {
      final discussions =
          await githubRepository.fetchUserDiscussions(event.token);
      emit(GithubDiscussionsLoaded(discussions));
    } catch (e) {
      emit(GithubError(e.toString()));
    }
  }

  void _onFetchUserProjects(
      FetchUserProjects event, Emitter<GithubState> emit) async {
    emit(GithubLoading());
    try {
      final projects = await githubRepository.fetchUserProjects(event.token);
      emit(GithubProjectsLoaded(projects));
    } catch (e) {
      emit(GithubError(e.toString()));
    }
  }

  void _onFetchStarredRepositories(
      FetchStarredRepositories event, Emitter<GithubState> emit) async {
    emit(GithubLoading());
    try {
      final repositories =
          await githubRepository.fetchStarredRepositories(event.token);
      emit(GithubStarredLoaded(repositories));
    } catch (e) {
      emit(GithubError(e.toString()));
    }
  }
}
