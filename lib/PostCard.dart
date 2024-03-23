import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Post.dart';
import 'package:flutter/material.dart';
import 'PostDetailScreen.dart';

Future<String> submitReport(post_id) async {
  final response = await http.post(
    Uri.parse('https://uwoffmychest.com/api/submitReport'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'content_id': post_id,
    }),
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to create post');
  }
}


Future<void> viewPost(post_id) async{
  final response = await http.put(Uri.parse('https://uwoffmychest.com/api/updatePost?id=${post_id}'));

  if (response.statusCode == 200) {
  } else {
    throw Exception('Failed to update post');
  }
}

class PostColumn extends StatelessWidget {
  final List<Post>? posts;

  final ScrollController scrollController;

  const PostColumn({super.key, required this.posts, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    if (posts == null || posts!.isEmpty) {
      return const Center(child: Text("No posts available"));
    }

    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: posts!.length,
      itemBuilder: (context, index) {
        final post = posts![index];
        return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Update the view count
                viewPost(posts![index].post_id);
                // Navigate to the next screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostDetail(post: posts![index])));
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.account_circle,
                            size: 50, color: Colors.white),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 2),
                              Text(post.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white)),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.remove_red_eye,
                                      color: Colors.white, size: 23),
                                  const SizedBox(width: 5),
                                  Text(post.views.toString(),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                  const SizedBox(width: 10),
                                  Text(
                                      post.to_char
                                          .replaceAll(RegExp(r'\s+'), ' ')
                                          .replaceAll(',', ''),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                ],
                              ),
                              // Optionally, add a button or icon if you want to perform some action (e.g., view comments)
                            ],
                          ),
                        ),
                        PopupMenuButton(
                            onSelected: (value) async {
                              if (value == "report") {
                                bool shouldShowSnackbar = false;
                                await showDialog(context: context, builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: const Text("Report"),
                                    content: const Text("Are you sure you want to report this post?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () => Navigator.of(dialogContext).pop(),
                                          child: const Text("Cancel")
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            // Perform the report submission and wait for it
                                            final result = await submitReport(post.post_id);
                                            if (result == "Report submitted!") {
                                              // Set a flag to show the snackbar after the dialog is dismissed
                                              shouldShowSnackbar = true;
                                            }
                                            if(dialogContext.mounted){
                                              Navigator.of(dialogContext).pop();
                                            } // Dismiss the dialog
                                          },
                                          child: const Text("Report")
                                      ),
                                    ],
                                  );
                                });

                                // Check if the snackbar should be shown
                                if (shouldShowSnackbar) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Report submitted')),
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
                  ),
                  const Divider(height: 1, color: Colors.grey),
                ],
              ),
            ));
      },
    );
  }
}
