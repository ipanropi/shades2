import 'package:flutter/material.dart';

class Guidelines extends StatelessWidget {
  const Guidelines({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text('Community Guidelines', style: TextStyle(color: Colors.white),),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Shades!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                'Our platform is dedicated to providing students a safe space to share their experiences, thoughts, and stories anonymously. To ensure our community remains supportive and respectful, we ask all participants to adhere to the following guidelines:',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                '1. Respect Anonymity',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Do not attempt to guess, reveal, or ask for the identities of any posters or commenters. Avoid sharing any personal information that could inadvertently identify you or someone else.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                '2. Be Supportive and Respectful',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Treat all stories and comments with respect and empathy. Understand that everyones experience is unique, and refrain from invalidating others feelings or experiences. Use supportive language and offer encouragement or constructive advice.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                '3. No Hate Speech or Bullying',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Hate speech, bullying, and discrimination of any kind are strictly prohibited. Do not post or comment anything that could be seen as offensive, threatening, or harmful towards individuals or groups based on race, ethnicity, nationality, sex, gender identity, sexual orientation, religion, or disability.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                '4. Keep It Appropriate',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Avoid explicit content or language that is not suitable for all ages. Do not post graphic descriptions of violence or sexual content.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                '5. Stay On Topic',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Ensure your posts and comments are relevant to the purpose of our website. Do not spam the platform with off-topic content or promotional material.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                '6. Report Concerns',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'If you encounter any posts or comments that violate these guidelines, please use the report feature or contact a moderator directly. Our team is committed to maintaining a safe space and will take appropriate action on reported content.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                '7. Remember the Impact of Your Words',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Before posting or commenting, consider the impact your words may have on others. Aim to contribute positively to the conversation and support those sharing their stories.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Consequences:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Violating these guidelines may result in the removal of content, temporary bans, or permanent bans from the platform, depending on the severity of the violation.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Thank You for Helping Us Maintain a Positive Community!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'By adhering to these guidelines, you play a vital role in fostering a supportive and respectful environment for all students to share and connect. Thank you for being a part of our community.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      )
    );
  }
}