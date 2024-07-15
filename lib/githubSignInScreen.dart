import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';

class Githubsigninscreen extends StatefulWidget {
  const Githubsigninscreen({super.key});

  @override
  State<Githubsigninscreen> createState() => _GithubsigninscreenState();
}

class _GithubsigninscreenState extends State<Githubsigninscreen> {
  bool _isLoading = false;
  Future<UserCredential> signInWithGithub() async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: "Ov23liKEG7I5L8WFcoXb",
        clientSecret: "973b98ec5d81b29708d64babece6fd32dd0540d8",
        redirectUrl: "https://github-app-08.firebaseapp.com/__/auth/handler");
    final result = await gitHubSignIn.signIn(context);
    final githubAuthCredential = GithubAuthProvider.credential(result.token!);

    return await FirebaseAuth.instance
        .signInWithCredential(githubAuthCredential);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: ElevatedButton(
          onPressed: () async {
            signInWithGithub();
          },
          child: Text("Sign in with Github"),
        ),
      ),
    );
  }
}
