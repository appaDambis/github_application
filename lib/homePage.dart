import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_application/bloc/github_bloc.dart';
import 'package:github_application/pages/discussions_page.dart';
import 'package:github_application/pages/issues_page.dart';
import 'package:github_application/pages/organixations_page.dart';
import 'package:github_application/pages/projects_page.dart';
import 'package:github_application/pages/pull_request_page.dart';
import 'package:github_application/pages/repository/repositories_page.dart';
import 'package:github_application/pages/starred_page.dart';
import 'package:github_application/pages/user_page.dart';

class HomePage extends StatefulWidget {
  final String token;

  HomePage({required this.token});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Trigger fetching user data when the page loads
    context.read<GithubBloc>().add(FetchUserData(widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Home'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search users...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final username = _searchController.text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPage(
                          username: username,
                          token: widget.token,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<GithubBloc, GithubState>(
          builder: (context, state) {
            if (state is GithubLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GithubLoaded) {
              final user = state.user;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.avatarUrl),
                      radius: 40,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome, ${user.login}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Name: ${user.name ?? 'Not provided'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Bio: ${user.bio ?? 'Not provided'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Public Repositories: ${user.publicRepos}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    _buildMenuItem(
                      context,
                      'Pull Requests',
                      Icons.call_merge,
                      _navigateToPullRequests,
                    ),
                    _buildMenuItem(
                      context,
                      'Issues',
                      Icons.error_outline,
                      _navigateToIssues,
                    ),
                    _buildMenuItem(
                      context,
                      'Discussions',
                      Icons.chat_bubble_outline,
                      _navigateToDiscussions,
                    ),
                    _buildMenuItem(
                      context,
                      'Projects',
                      Icons.work_outline,
                      _navigateToProjects,
                    ),
                    _buildMenuItem(
                      context,
                      'Repositories',
                      Icons.folder_open,
                      () => _navigateToRepositories(user.login),
                    ),
                    _buildMenuItem(
                      context,
                      'Organizations',
                      Icons.people_outline,
                      _navigateToOrganizations,
                    ),
                    _buildMenuItem(
                      context,
                      'Starred Repositories',
                      Icons.star_outline,
                      _navigateToStarred,
                    ),
                  ],
                ),
              );
            } else if (state is GithubError) {
              return Center(
                  child: Text('Failed to load data: ${state.message}'));
            } else {
              return const Center(
                  child: Text('Press the button to fetch data.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _navigateToPullRequests() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PullRequestsPage()),
    );
  }

  void _navigateToIssues() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => IssuesPage()),
    );
  }

  void _navigateToDiscussions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DiscussionsPage()),
    );
  }

  void _navigateToProjects() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProjectsPage()),
    );
  }

  void _navigateToRepositories(String username) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RepositoriesPage(
                token: widget.token,
                username: username,
              )),
    );
  }

  void _navigateToOrganizations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrganizationsPage()),
    );
  }

  void _navigateToStarred() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StarredPage()),
    );
  }
}
