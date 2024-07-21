import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_application/bloc/github_bloc.dart';
import 'package:github_application/bloc/github_event.dart';
import 'package:github_application/bloc/github_state.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  final String username;
  final String token;

  UserPage({required this.username, required this.token});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? _fcmToken;
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _firebaseMessaging.getToken().then((token) {
          setState(() {
            _fcmToken = token;
          });
          if (_fcmToken != null) {
            FirebaseFirestore.instance.collection('users').doc(user.uid).set({
              'fcmToken': _fcmToken,
            });
          }
        });
      }
    });
    _checkSubscriptionStatus();
    context.read<GithubBloc>().add(SearchUser(widget.username, widget.token));
  }

  void _checkSubscriptionStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('subscriptions')
          .doc('${user.uid}_${widget.username}')
          .get();

      setState(() {
        _isSubscribed = snapshot.exists;
      });
    }
  }

  void _subscribeToUser() async {
    User? user = _auth.currentUser;
    if (user != null && _fcmToken != null) {
      await FirebaseFirestore.instance
          .collection('subscriptions')
          .doc('${user.uid}_${widget.username}')
          .set({
        'username': widget.username,
        'fcmToken': _fcmToken,
        'userId': user.uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subscribed to ${widget.username}')),
      );

      setState(() {
        _isSubscribed = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to subscribe')),
      );
    }
  }

  void _unsubscribeFromUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('subscriptions')
          .doc('${user.uid}_${widget.username}')
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unsubscribed from ${widget.username}')),
      );

      setState(() {
        _isSubscribed = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to unsubscribe')),
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
                    'Name: ${user.name}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Bio: ${user.bio}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Public Repositories: ${user.publicRepos}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  _isSubscribed
                      ? ElevatedButton(
                          onPressed: _unsubscribeFromUser,
                          child: Text('Unsubscribe'),
                        )
                      : ElevatedButton(
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
                                SnackBar(
                                    content: Text('Could not launch $url')),
                              );
                            }
                          },
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
