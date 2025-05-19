import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListingsPage extends StatefulWidget {
  @override
  _ListingsPageState createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  List posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('https://autod2d.live-website.com/wp-json/wp/v2/posts'),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          posts = data;
        });
      } else {
        print('Failed to load posts: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  String _stripHtmlTags(String htmlString) {
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(regex, '').trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Listings')),
      body: posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final title = post['title']['rendered'] ?? 'No title';
                final excerpt = post['excerpt']['rendered'] ?? '';

                return ListTile(
                  title: Text(title),
                  subtitle: Text(_stripHtmlTags(excerpt)),
                );
              },
            ),
    );
  }
}
