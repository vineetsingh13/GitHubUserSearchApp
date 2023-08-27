import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

class UserDetailPage extends StatelessWidget {
  final String username;

  UserDetailPage({required this.username});

  Future<dynamic> _fetchUserData(String username) async {
    final dio = Dio();
    final response = await dio.get('https://api.github.com/users/$username');

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Detail'),
      ),
      body: FutureBuilder(
        future: _fetchUserData(username),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final userData = snapshot.data;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userData['avatar_url']),
                  radius: 50,
                ),
                SizedBox(height: 16),
                Text(userData['login'] ?? ''),
                SizedBox(height: 8),
                Text(userData['bio'] ?? ''),
                SizedBox(height: 8),
                Text(userData['location'] ?? ''),
                SizedBox(height: 8),
                Text(userData['public_repos'].toString() + ' Public Repos'),
                SizedBox(height: 8),
                Text('Total Followers '+ userData['followers'].toString() ),
              ],
            ),
          );
        },
      ),
    );
  }
}
