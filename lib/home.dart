import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'UserDetailPage.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchBar = TextEditingController();
  List<dynamic> _searchList = [];
  final dio = Dio();

  Future<void> _searchGitHubUsers(String query) async {
    final response = await dio.get('https://api.github.com/search/users', queryParameters: {'q': query});

    if (response.statusCode == 200) {
      final data = response.data;
      setState(() {
        _searchList = data['items'];
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  void _navigateToUserPage(String username) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailPage(username: username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub User Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchBar,
              onChanged: (query) {
                _searchGitHubUsers(query);
              },
              decoration: InputDecoration(
                labelText: 'search github users',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchList.length,
              itemBuilder: (context, index) {
                final user = _searchList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['avatar_url']),
                  ),
                  title: Text(user['login']),
                  onTap:(){
                    _navigateToUserPage(user['login']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: HomePage()));

