import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_application/bloc/github_bloc.dart';
import 'package:github_application/pages/repository/repositories_file_page.dart';

class RepositoriesPage extends StatefulWidget {
  final String username;
  final String token;

  RepositoriesPage({required this.username, required this.token});

  @override
  _RepositoriesPageState createState() => _RepositoriesPageState();
}

class _RepositoriesPageState extends State<RepositoriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<GithubBloc>().add(SearchUser(widget.username, widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositories'),
      ),
      body: BlocBuilder<GithubBloc, GithubState>(
        builder: (context, state) {
          if (state is GithubLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GithubSearchLoaded) {
            final repositories = state.repositories;

            return ListView.builder(
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                final repo = repositories[index];
                return ListTile(
                  title: Text(repo.name),
                  subtitle: Text(repo.description ?? 'No description'),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Stars: ${repo.stars}'),
                      Text('Forks: ${repo.forks}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RepositoryFilesPage(
                          username: widget.username,
                          repoName: repo.name,
                          token: widget.token,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is GithubError) {
            return Center(child: Text('Failed to load data: ${state.message}'));
          } else {
            return const Center(child: Text('Press the button to fetch data.'));
          }
        },
      ),
    );
  }
}
