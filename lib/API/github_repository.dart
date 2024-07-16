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
}
