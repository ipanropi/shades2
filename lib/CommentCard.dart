import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'Comments.dart';


Future<String> submitReport(comment_id) async {
  final response = await http.post(
    Uri.parse('https://uwoffmychest.com/api/submitReport'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'content_id': comment_id,
    }),
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to create post');
  }
}

class CommentCard extends StatelessWidget {
  final List<Comments>? comments;

  const CommentCard({super.key, this.comments});

  @override
  Widget build(BuildContext context) {
    if (comments == null || comments!.isEmpty) {
      return const Column(
        children: [
          SizedBox(height: 20, width: 20),
          Center(child: Text("No Comments available", style: TextStyle(
              fontSize: 20,
              color: Colors.white
          ))),
        ],
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: comments!.length,
      itemBuilder: (context, index) {
        final comment = comments![index];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.account_circle, size: 45, color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Comment${comment.comment_id.split('-').first}', style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white
                                  )),
                                  Text(comment.to_char.replaceAll(RegExp(r'\s+'), ' ').replaceAll(',', ''), style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white

                                  )),
                                  const SizedBox(height: 2),
                                  // Optionally, add a button or icon if you want to perform some action (e.g., view comments)
                                ],
                              ),
                            ),
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
                                          final result = await submitReport(comments![index].comment_id);
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
                  const SizedBox(height: 8),
                  Text(
                      comment.content,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      )),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
          ],
        );
      },
    );
  }
}