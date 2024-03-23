import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'CommentCard.dart';
import 'Comments.dart';
import 'Post.dart';

Future<List<Comments>> fetchComments(post) async {
  final response = await http.get(
      Uri.parse('https://uwoffmychest.com/api/getComments?id=${post.post_id}'));

  if (response.statusCode == 201) {
    List<dynamic> commentListJson = jsonDecode(response.body);
    return commentListJson
        .map((commentJson) => Comments.fromJson(commentJson))
        .toList();
  } else {
    throw Exception('Failed to load comments');
  }
}

Future<String> createComment(post_id, content) async {
  final response = await http.post(
    Uri.parse('https://uwoffmychest.com/api/createMobileComment'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'post_id': post_id,
      'content': content,
    }),
  );

  if (response.statusCode == 201) {
    return response.body;
  } else {
    throw Exception('Failed to create post');
  }
}

class PostDetail extends StatefulWidget {
  const PostDetail({super.key, required this.post});

  final Post post;

  @override
  State<PostDetail> createState() => _PostDetailState(post: post);
}

class _PostDetailState extends State<PostDetail> {
  _PostDetailState({required this.post});

  final Post post;
  late Future<List<Comments>> comments;
  final commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    comments = fetchComments(post);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: const Text(
            "Post",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.account_circle_rounded,
                            size: 45, color: Colors.white),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User${post.post_id.split('-').first}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white)),
                            Text(
                              post.to_char
                                  .replaceAll(RegExp(r'\s+'), ' ')
                                  .replaceAll(',', ''),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                        const Spacer(),
                        PopupMenuButton(
                            onSelected: (value) async {
                              if (value == "report") {
                                bool shouldShowSnackbar = false;
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: const Text("Report"),
                                        content: const Text(
                                            "Are you sure you want to report this post?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(dialogContext)
                                                      .pop(),
                                              child: const Text("Cancel")),
                                          TextButton(
                                              onPressed: () async {
                                                // Perform the report submission and wait for it
                                                final result =
                                                    await submitReport(
                                                        post.post_id);
                                                if (result ==
                                                    "Report submitted!") {
                                                  // Set a flag to show the snackbar after the dialog is dismissed
                                                  shouldShowSnackbar = true;
                                                }
                                                if (dialogContext.mounted) {
                                                  Navigator.of(dialogContext)
                                                      .pop();
                                                } // Dismiss the dialog
                                              },
                                              child: const Text("Report")),
                                        ],
                                      );
                                    });

                                // Check if the snackbar should be shown
                                if (shouldShowSnackbar) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Report submitted')),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.more_vert,
                                color: Colors.white),
                            itemBuilder: (context) {
                              return [
                                const PopupMenuItem(
                                  value: "report",
                                  child: Text("Report"),
                                ),
                              ];
                            })
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      post.content,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Share',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              SizedBox(width: 5),
                              Icon(Icons.share_rounded, color: Colors.white),
                            ],
                          ),
                          onTap: () {
                            // Share the post
                            Share.share(
                                'Check out this post on UWOffMyChest: https://uwoffmychest.com/post/${post.post_id}', subject: post.title);
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    const Text('Comments',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    const SizedBox(height: 10),
                    FutureBuilder(
                        future: comments,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child:
                                    CircularProgressIndicator()); // Loading state
                          } else if (snapshot.hasError) {
                            return const Center(
                                child:
                                    Text('An error occurred')); // Error state
                          } else if (snapshot.hasData) {
                            return CommentCard(comments: snapshot.data);
                          } else {
                            return const Center(
                                child: Text('No data')); // Empty state
                          }
                        }),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: commentController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a comment';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'Add a comment',
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          createComment(post.post_id, commentController.text)
                              .then((_) => setState(() {
                                    comments = fetchComments(post);
                                  }));
                          FocusScope.of(context).requestFocus(FocusNode());
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Comment submitted"),
                                  content: const Text(
                                      "Your comment has been submitted"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("OK"))
                                  ],
                                );
                              });
                          commentController.clear();
                        }
                      },
                      icon: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 30))
                ],
              ),
            ],
          ),
        ));
  }
}
