import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_application/bloc/github_bloc.dart';
import 'package:github_application/bloc/github_event.dart';
import 'package:github_application/bloc/github_state.dart';

class ProjectsPage extends StatefulWidget {
  final String token;

  const ProjectsPage({super.key, required this.token});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  void initState() {
    super.initState();
    // Trigger fetching projects when the page loads
    context.read<GithubBloc>().add(FetchUserProjects(widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Projects'),
      ),
      body: BlocBuilder<GithubBloc, GithubState>(
        builder: (context, state) {
          if (state is GithubLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GithubProjectsLoaded) {
            final projects = state.projects;

            return ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return ListTile(
                  title: Text(project.name),
                  subtitle: Text('Created at: ${project.createdAt}\n'
                      'Description: ${project.body}'),
                  onTap: () {
                    // Open the project URL
                    // Launch URL using a package like url_launcher
                  },
                );
              },
            );
          } else if (state is GithubError) {
            return Center(
                child: Text('Failed to load projects: ${state.message}'));
          } else {
            return const Center(child: Text('No projects found.'));
          }
        },
      ),
    );
  }
}
