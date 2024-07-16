import 'dart:convert';

import 'package:github_application/models/models.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api.github.com';

  Future<User> getUserData(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {'Authorization': 'token $token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<Repository>> getUserRepositories(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/repos'),
      headers: {'Authorization': 'token $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> reposJson = json.decode(response.body);
      return reposJson.map((json) => Repository.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load repositories');
    }
  }

  Future<User> searchUser(String username, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$username'),
      headers: {'Authorization': 'token $token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<Repository>> getUserRepositoriesByUsername(
      String username, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$username/repos'),
      headers: {'Authorization': 'token $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> reposJson = json.decode(response.body);
      return reposJson.map((json) => Repository.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load repositories');
    }
  }
}
