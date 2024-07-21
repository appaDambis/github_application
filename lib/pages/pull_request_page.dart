import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_application/bloc/github_bloc.dart';
import 'package:github_application/bloc/github_event.dart';
import 'package:github_application/bloc/github_state.dart';

class PullRequestsPage extends StatefulWidget {
  final String token;

  const PullRequestsPage({super.key, required this.token});

  @override
  State<PullRequestsPage> createState() => _PullRequestsPageState();
}

class _PullRequestsPageState extends State<PullRequestsPage> {
  @override
  void initState() {
    super.initState();
    // Trigger fetching pull requests when the page loads
    context.read<GithubBloc>().add(FetchUserPullRequests(widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pull Requests'),
      ),
      body: BlocBuilder<GithubBloc, GithubState>(
        builder: (context, state) {
          if (state is GithubLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GithubPullRequestsLoaded) {
            final pullRequests = state.pullRequests;

            return ListView.builder(
              itemCount: pullRequests.length,
              itemBuilder: (context, index) {
                final pr = pullRequests[index];
                return ListTile(
                  title: Text(pr.title),
                  subtitle: Text('Repository: ${pr.repositoryName}\n'
                      'State: ${pr.state}\n'
                      'Created at: ${pr.createdAt}'),
                );
              },
            );
          } else if (state is GithubError) {
            return Center(
                child: Text('Failed to load pull requests: ${state.message}'));
          } else {
            return const Center(child: Text('No pull requests found.'));
          }
        },
      ),
    );
  }
}
