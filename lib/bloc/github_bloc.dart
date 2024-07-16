import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_application/API/github_repository.dart';

import '../models/models.dart';

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

// States
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

// BLoC
class GithubBloc extends Bloc<GithubEvent, GithubState> {
  final GithubRepository githubRepository;

  GithubBloc(this.githubRepository) : super(GithubInitial()) {
    on<FetchUserData>(_onFetchUserData);
    on<SearchUser>(_onSearchUser);
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
}
