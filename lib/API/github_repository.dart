import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/models.dart';

class GithubRepository {
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
