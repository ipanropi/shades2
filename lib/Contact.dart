import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> submitFeedback(feedback) async {
  final response = await http.post(
    Uri.parse('https://uwoffmychest.com/api/submitMobileFeedback'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'feedback': feedback
    }),
  );

  if (response.statusCode == 200) {
  } else {
    throw Exception('Failed to create post');
  }
}

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text('Contact Us', style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          submitFeedback('${titleController.text}\n${contentController.text}');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Feedback submitted! Thank you!')),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Submit",
                          style: TextStyle(color: Colors.black))),
                ],
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            hintText: 'Subject',
                            hintStyle:
                            TextStyle(color: Colors.white)),
                      ),
                      TextFormField(
                        controller: contentController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        maxLines: 20,
                        decoration: const InputDecoration(
                            hintText:
                            'Issue or feedback description...',
                            hintStyle:
                            TextStyle(color: Colors.white)),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}