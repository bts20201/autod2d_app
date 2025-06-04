import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListingsPage extends StatefulWidget {
  @override
  _ListingsPageState createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  List posts = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('https://autod2d.live-website.com/wp-json/wp/v2/posts?_embed'),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          posts = data;
          errorMessage = '';
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load posts: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching posts: $e';
      });
    }
  }

  String _stripHtmlTags(String? htmlString) {
    if (htmlString == null) return '';
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(regex, '').trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Listings')),
      body: posts.isEmpty
          ? errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final title = post['title']['rendered'] ?? 'No title';
                final excerpt = post['excerpt']['rendered'] ?? '';

                final imageUrl = post['_embedded']?['wp:featuredmedia']?[0]?['source_url'];

                return ListTile(
                  leading: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.image_not_supported),
                  title: Text(title),
                  subtitle: Text(_stripHtmlTags(excerpt)),
                  onTap: () {
                    // You can navigate to a detail view or webview here
                  },
                );
              },
            ),
    );
  }
}
