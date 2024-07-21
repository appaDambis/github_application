import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_application/bloc/github_bloc.dart';
import 'package:github_application/bloc/github_event.dart';
import 'package:github_application/bloc/github_state.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  subtitle: Text(repo.description),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Stars: ${repo.stars}'),
                      Text('Forks: ${repo.forks}'),
                    ],
                  ),
                  onTap: () async {
                    final url = repo.htmlUrl;
                    if (await launch(url)) {
                      await launch(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch $url')),
                      );
                    }
                  },
                );
              },
            );
          } else if (state is GithubError) {
            return Center(
                child: Text(
                    'Failed to load starred repositories: ${state.message}'));
          } else {
            return const Center(child: Text('No starred repositories found.'));
          }
        },
      ),
    );
  }
}
