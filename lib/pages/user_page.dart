import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_application/bloc/github_bloc.dart';

class UserPage extends StatefulWidget {
  final String username;
  final String token;

  UserPage({required this.username, required this.token});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    context.read<GithubBloc>().add(SearchUser(widget.username, widget.token));

    _firebaseMessaging.getToken().then((token) {
      setState(() {
        _fcmToken = token;
      });
    });
  }

  void _subscribeToUser() async {
    if (_fcmToken != null) {
      // Save subscription to Firestore
      await FirebaseFirestore.instance.collection('subscriptions').add({
        'username': widget.username,
        'fcmToken': _fcmToken,
      });

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subscribed to ${widget.username}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username}\'s Repositories'),
      ),
      body: BlocBuilder<GithubBloc, GithubState>(
        builder: (context, state) {
          if (state is GithubLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GithubSearchLoaded) {
            final user = state.user;
            final repositories = state.repositories;

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
                    'Username: ${user.login}',
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
                  ElevatedButton(
                    onPressed: _subscribeToUser,
                    child: Text('Subscribe'),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Repositories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
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
                        );
                      },
                    ),
                  ),
                ],
              ),
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
