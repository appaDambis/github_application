import 'package:flutter/material.dart';

class PullRequestsPage extends StatefulWidget {
  const PullRequestsPage({super.key});

  @override
  State<PullRequestsPage> createState() => _PullRequestsPageState();
}

class _PullRequestsPageState extends State<PullRequestsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
