import 'package:flutter/material.dart';
import 'package:tedxtok/Styles/fontStyles.dart';
import 'package:tedxtok/Styles/sizes.dart';
import 'package:tedxtok/Styles/tedTokColors.dart';
import 'package:tedxtok/topicSelectionPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LogInPage(),
      ),
    );
  }
}

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}


//pagina di Login
class _LogInPageState extends State<LogInPage> {

  @override
  void initState() {
    super.initState();
  }


//DA SISTEMARE AD ORA é SEMIVUOTA
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: tedTokColors.tedRed, // Rosso TedTok
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(sizes.stdRoundedCorner),
                bottomRight: Radius.circular(sizes.stdRoundedCorner),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'WELCOME',
                      style: fontStyles.headerText,
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'TO',
                      style: fontStyles.headerText,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/Logo_Bianco.png', // Path to the image asset
                  height: sizes.imgSize,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Instructions
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Please select a list of topics that might interest you',
              style: fontStyles.introText,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          // List of Topics
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(sizes.smallRoundedCorner),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Button

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}



