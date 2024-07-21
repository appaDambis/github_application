import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_application/bloc/github_bloc.dart';
import 'package:github_application/bloc/github_event.dart';
import 'package:github_application/bloc/github_state.dart';

class DiscussionsPage extends StatefulWidget {
  final String token;

  const DiscussionsPage({super.key, required this.token});

  @override
  State<DiscussionsPage> createState() => _DiscussionsPageState();
}

class _DiscussionsPageState extends State<DiscussionsPage> {
  @override
  void initState() {
    super.initState();
    // Trigger fetching discussions when the page loads
    context.read<GithubBloc>().add(FetchUserDiscussions(widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Discussions'),
      ),
      body: BlocBuilder<GithubBloc, GithubState>(
        builder: (context, state) {
          if (state is GithubLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GithubDiscussionsLoaded) {
            final discussions = state.discussions;

            return ListView.builder(
              itemCount: discussions.length,
              itemBuilder: (context, index) {
                final discussion = discussions[index];
                return ListTile(
                  title: Text(discussion.title),
                  subtitle: Text('Author: ${discussion.author}\n'
                      'Created at: ${discussion.createdAt}'),
                  onTap: () {
                    // Open the discussion URL
                    // Launch URL using a package like url_launcher
                  },
                );
              },
            );
          } else if (state is GithubError) {
            return Center(
                child: Text('Failed to load discussions: ${state.message}'));
          } else {
            return const Center(child: Text('No discussions found.'));
          }
        },
      ),
    );
  }
}
