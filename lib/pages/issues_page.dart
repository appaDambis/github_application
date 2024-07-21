import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_application/bloc/github_bloc.dart';
import 'package:github_application/bloc/github_event.dart';
import 'package:github_application/bloc/github_state.dart';

class IssuesPage extends StatefulWidget {
  final String token;

  const IssuesPage({super.key, required this.token});

  @override
  State<IssuesPage> createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  @override
  void initState() {
    super.initState();
    // Trigger fetching issues when the page loads
    context.read<GithubBloc>().add(FetchUserIssues(widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Issues'),
      ),
      body: BlocBuilder<GithubBloc, GithubState>(
        builder: (context, state) {
          if (state is GithubLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GithubIssuesLoaded) {
            final issues = state.issues;

            return ListView.builder(
              itemCount: issues.length,
              itemBuilder: (context, index) {
                final issue = issues[index];
                return ListTile(
                  title: Text(issue.title),
                  subtitle: Text('Repository: ${issue.repositoryName}\n'
                      'State: ${issue.state}\n'
                      'Created at: ${issue.createdAt}'),
                );
              },
            );
          } else if (state is GithubError) {
            return Center(
                child: Text('Failed to load issues: ${state.message}'));
          } else {
            return const Center(child: Text('No issues found.'));
          }
        },
      ),
    );
  }
}
