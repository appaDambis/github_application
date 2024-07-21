import 'dart:convert';

import 'package:github_application/models/discussions_model.dart';
import 'package:github_application/models/issues_models.dart';
import 'package:github_application/models/projects_model.dart';
import 'package:github_application/models/pull_requests_model.dart';
import 'package:github_application/models/repository_model.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class GithubRepository {
  Future<List<Issue>> fetchUserIssues(String token) async {
    final response = await http.get(
      Uri.parse('https://api.github.com/issues?filter=created&state=all'),
      headers: {'Authorization': 'token $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Issue.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load issues');
    }
  }

  Future<List<PullRequest>> fetchUserPullRequests(String token) async {
    final response = await http.get(
      Uri.parse('https://api.github.com/search/issues?q=is:pr+author:@me'),
      headers: {'Authorization': 'token $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body)['items'];
      return jsonList.map((json) => PullRequest.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pull requests');
    }
  }

  Future<User> fetchUserData(String token) async {
    final response = await http.get(
      Uri.parse('https://api.github.com/user'),
      headers: {'Authorization': 'token $token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<Repository>> fetchUserRepositories(String token) async {
    final response = await http.get(
      Uri.parse('https://api.github.com/user/repos'),
      headers: {'Authorization': 'token $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Repository.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load repositories');
    }
  }

  Future<User> searchUser(String username, String token) async {
    final response = await http.get(
      Uri.parse('https://api.github.com/users/$username'),
      headers: {'Authorization': 'token $token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('User not found');
    }
  }

  Future<List<Repository>> searchUserRepositories(
      String username, String token) async {
    final response = await http.get(
      Uri.parse('https://api.github.com/users/$username/repos'),
      headers: {'Authorization': 'token $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Repository.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load repositories');
    }
  }

  Future<List<File>> fetchRepositoryFiles(
      String username, String repoName, String token) async {
    final String apiUrl =
        'https://api.github.com/repos/$username/$repoName/contents';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/vnd.github.v3+json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<File> files = jsonData.map((e) => File.fromJson(e)).toList();
        return files;
      } else {
        throw Exception('Failed to load files: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load files: $e');
    }
  }

  Future<List<Discussion>> fetchUserDiscussions(String token) async {
    final response = await http.get(
      Uri.parse('https://api.github.com/user/discussions'),
      headers: {
        'Authorization': 'token $token',
        'Accept': 'application/vnd.github.inertia-preview+json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Discussion.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load discussion');
    }
  }

  Future<List<Project>> fetchUserProjects(String token) async {
    final response = await http.get(
      Uri.parse('https://api.github.com/user/projects'),
      headers: {
        'Authorization': 'token $token',
        'Accept': 'application/vnd.github.inertia-preview+json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<List<Repository>> fetchStarredRepositories(String token) async {
    final response = await http.get(
      Uri.parse('https://api.github.com/user/starred'),
      headers: {
        'Authorization': 'token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Repository.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load starred repositories');
    }
  }
}

class File {
  final String name;
  final String path;

  File({required this.name, required this.path});

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      name: json['name'],
      path: json['path'],
    );
  }
}
