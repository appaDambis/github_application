import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_application/API/github_repository.dart';
import 'package:github_application/bloc/github_bloc.dart';
import 'package:github_application/homePage.dart';
import 'package:github_sign_in/github_sign_in.dart';

class Githubsigninscreen extends StatefulWidget {
  const Githubsigninscreen({super.key});

  @override
  State<Githubsigninscreen> createState() => _GithubsigninscreenState();
}

class _GithubsigninscreenState extends State<Githubsigninscreen> {
  bool _isLoading = false;

  Future<void> signInWithGithub() async {
    setState(() {
      _isLoading = true;
    });

    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: "Ov23liKEG7I5L8WFcoXb",
        clientSecret: "973b98ec5d81b29708d64babece6fd32dd0540d8",
        redirectUrl: "https://github-app-08.firebaseapp.com/__/auth/handler");
    final result = await gitHubSignIn.signIn(context);

    if (result.token != null) {
      final githubAuthCredential = GithubAuthProvider.credential(result.token!);
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(githubAuthCredential);

      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => GithubBloc(GithubRepository()),
              child: HomePage(token: result.token!),
            ),
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Sign In'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: signInWithGithub,
                child: Text("Sign in with GitHub"),
              ),
      ),
    );
  }
}
