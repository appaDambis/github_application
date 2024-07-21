import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_application/bloc/github_bloc.dart';
import 'package:github_application/bloc/github_event.dart';
import 'package:github_application/bloc/github_state.dart';
// Assume you have a File model

class RepositoryFilesPage extends StatefulWidget {
  final String username;
  final String repoName;
  final String token;

  RepositoryFilesPage({
    required this.username,
    required this.repoName,
    required this.token,
  });

  @override
  _RepositoryFilesPageState createState() => _RepositoryFilesPageState();
}

class _RepositoryFilesPageState extends State<RepositoryFilesPage> {
  @override
  void initState() {
    super.initState();
    context.read<GithubBloc>().add(FetchRepositoryFiles(
          username: widget.username,
          repoName: widget.repoName,
          token: widget.token,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.repoName} Files'),
      ),
      body: BlocBuilder<GithubBloc, GithubState>(
        builder: (context, state) {
          if (state is GithubLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GithubFilesLoaded) {
            final files = state.files;

            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return ListTile(
                  title: Text(file.name),
                  subtitle: Text(file.path),
                );
              },
            );
          } else if (state is GithubError) {
            return Center(
                child: Text('Failed to load files: ${state.message}'));
          } else {
            return const Center(
                child: Text('Press the button to fetch files.'));
          }
        },
      ),
    );
  }
}
