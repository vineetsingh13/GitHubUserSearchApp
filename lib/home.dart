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

  //theme for light
  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,

  );

  //theme for dark
  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.deepPurple,

  );

  //variable for toggling the theme
  bool _isDarkMode = false;
  TextEditingController _searchBar = TextEditingController();
  List<dynamic> _searchList = [];
  final dio = Dio();

  //method to toggle theme
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }


  //future method that adds the data from the api in the searchList
  Future<void> _searchGitHubUsers(String query) async {
    final response = await dio.get('https://api.github.com/search/users',
        queryParameters: {'q': query});

    if (response.statusCode == 200) {
      final data = response.data;
      setState(() {
        _searchList = data['items'];
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  //method to navigate to the userDetailPage with the username for passing as a parameter and the darkmode theme to make the next page
  //know the theme of the app
  void _navigateToUserPage(String username) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailPage(username: username,isDark: _isDarkMode,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? darkTheme : lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('GitHub User Search'),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
              onPressed: _toggleTheme,
            ),
          ],
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
                    onTap: () {
                      _navigateToUserPage(user['login']);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(HomePage());
