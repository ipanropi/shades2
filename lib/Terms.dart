import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _privacyPolicyUri = Uri.parse('https://app.termly.io/document/terms-of-service/d4e27f4a-ff57-4147-921b-43c59db015f0');

class Terms extends StatelessWidget {
  const Terms({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
    'Terms and Conditions', style: TextStyle(color: Colors.white),
      ),
      ),
      body: Center(
        child: RichText(
          text:  TextSpan(
            children: [
              const TextSpan(
                text: 'See our Terms of Use ',
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