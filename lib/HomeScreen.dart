import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Contact.dart';
import 'Guidelines.dart';
import 'NotificationController.dart';
import 'Post.dart';
import 'PostCard.dart';
import 'PrivacyPolicy.dart';
import 'Terms.dart';



Future<List<Post>> fetchPosts() async {
  try {
    final response =
        await http.get(Uri.parse('https://uwoffmychest.com/api/posts'));

    if (response.statusCode == 200) {
      List<dynamic> postListJson = jsonDecode(response.body);
      return postListJson.map((postJson) => Post.fromJson(postJson)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    throw Exception('Failed to load posts');
  }
}

Future<String> createPost(title, content) async {
  final response = await http.post(
    Uri.parse('https://uwoffmychest.com/api/createMobilePost'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'content': content,
    }),
  );

  if (response.statusCode == 201) {
    return response.body;
  } else {
    throw Exception('Failed to create post');
  }
}

void scheduleNotification() async {
  String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10, // Unique ID for this notification
      channelKey: 'scheduled', // Ensure this channel key is initialized in your app
      title: 'Check out the latest confessions!',
      body: 'New confessions are available to read. Tap to view them now.',
    ),
    schedule: NotificationInterval(
        interval: 259200, // Interval in seconds (60 seconds = 1 minute)
        timeZone: localTimeZone,
        repeats: true // Enable repeating
    ),
  );
}

void resetAndScheduleNotification() async {
  // Cancel any existing scheduled notifications
  await AwesomeNotifications().cancelAllSchedules();

  // Schedule a new notification for 3 days from now
  scheduleNotification();
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Post>> post;
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  int navigationBarIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    resetAndScheduleNotification();
    super.initState();
    post = fetchPosts();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      bottomNavigationBar:
      NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 60,
          labelTextStyle: MaterialStateProperty.all(const TextStyle(color: Colors.white)),
        ),
        child: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          onDestinationSelected: (int index) {
            setState(() {
              navigationBarIndex = index;
            });

            if(index == 0){
              _scrollController.animateTo(0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeIn);
            }
            else if(index == 1){
              setState(() {
                navigationBarIndex = 0;
              });
              showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  backgroundColor: Colors.black,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 30,
                                  )),
                              ElevatedButton(
                                  onPressed: () {
                                    // First, check if the form is valid
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      // If the form is valid, proceed to attempt post creation
                                      try {
                                        createPost(titleController.text,
                                            contentController.text)
                                            .then((_) {
                                          // Assuming createPost function is correct and post is created successfully
                                          if (mounted) {
                                            Navigator.pop(
                                                context); // Close the modal
                                          }
                                          setState(() {
                                            titleController
                                                .clear(); // Clear the text fields
                                            contentController.clear();
                                            post =
                                                fetchPosts();
                                            navigationBarIndex = 0;// Refresh the list of posts
                                          });
                                        }).catchError((error) {
                                          // Handle any errors that occur during post creation
                                          print('Error creating post: $error');
                                        });
                                      } catch (error) {
                                        // Handle any errors here
                                        print('Error: $error');
                                      }
                                    } else {
                                      // If the form is not valid, show an error dialog or handle it accordingly
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Error'),
                                              content: const Text(
                                                  'Please enter a title and content'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Close'),
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                  },
                                  child: const Text("Post",
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
                                        hintText: 'Title',
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
                                        'What\'s on your mind?...',
                                        hintStyle:
                                        TextStyle(color: Colors.white)),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    );
                  });
            }
            else if(index == 2){
              _scaffoldKey.currentState?.openDrawer();
              setState(() {
                navigationBarIndex = 0;
              });
            }
          },
          selectedIndex: navigationBarIndex,
          indicatorColor: Colors.white,
          backgroundColor: Colors.black,
          destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home, color: Colors.white, size: 30),
            selectedIcon: Icon(Icons.home_outlined, size: 30),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle, color: Colors.white, size: 30),
            selectedIcon: Icon(Icons.add_circle_outline, size: 30),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings, color: Colors.white, size: 30),
            selectedIcon: Icon(Icons.settings_outlined, size: 30),
            label: 'Notifications',
          ),
        ],
        ),
      ),
      drawer: const SettingsDrawer(),
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.black,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    _scrollController.animateTo(0,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeIn);
                  },
                  child: const ImageIcon(
                      AssetImage("assets/icons/shade.png"),
                      color: Colors.white,
                      size: 40),
                )
              ],
            ),
            Container(
                color: Colors.grey,
                height: 0.3,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10)),
          ]),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: post,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator()); // Loading state
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(snapshot.error.toString())); // Error state
                  } else if (snapshot.hasData) {
                    return RefreshIndicator(
                        displacement: 40,
                        onRefresh: () {
                          setState(() {
                            post = fetchPosts();
                          });
                          return post;
                        },
                        child: PostColumn(
                            posts: snapshot.data,
                            scrollController: _scrollController)
                    );

                  } else {
                    return const Center(child: Text('No data')); // Empty state
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 100, // Adjust the height as needed
            color: Colors.black,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Settings', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Contact Us', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Contact()));
            },
          ),
          ListTile(
            title: const Text('Guidelines', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Guidelines()));
            },
          ),
          ListTile(
            title: const Text('Term of Use', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Terms()));
            },
          ),
          ListTile(
            title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrivacyPolicy()));
            },
          ),
        ],
      ),
    );
  }
}
