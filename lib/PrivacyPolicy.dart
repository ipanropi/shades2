import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _privacyPolicyUri = Uri.parse('https://app.termly.io/document/privacy-policy/3c34def4-72aa-48be-bdf2-64cd156572ae');


class PrivacyPolicy extends StatelessWidget {

  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text('Privacy Policy', style: TextStyle(color: Colors.white),)
      ),
      body: Center(
        child: RichText(
          text:  TextSpan(
            children: [
              const TextSpan(
                text: 'See our Privacy Policy ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(_privacyPolicyUri),
                text: 'here',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}